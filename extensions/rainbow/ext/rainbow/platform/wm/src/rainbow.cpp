//#include "stdafx.h"




#include <common/RhodesApp.h>
#include <logging/RhoLogConf.h>


#include <stdlib.h>
#include <windows.h>
#include <commctrl.h>

#include <RhoNativeViewManager.h>
#include "rubyext/WebView.h"



#include "rainbow.h"




#define TIMER_ID 555
#define RAINBOW_WINDOW_CLASS_ID  "Rainbow Window Class"

static int cur_x = 0;
static int color_R = 255;
static int color_G = 255;
static int color_B = 0;


// объявление функций
LRESULT CALLBACK RainbowWndProc(HWND, UINT, WPARAM, LPARAM);
ATOM RegRainbowWindowClass(HINSTANCE, LPCTSTR);



ATOM RegRainbowWindowClass(HINSTANCE hInst, LPCTSTR lpzClassName)
{
	WNDCLASS wcWindowClass = {0};
	wcWindowClass.lpfnWndProc = (WNDPROC)RainbowWndProc;
	wcWindowClass.style = CS_HREDRAW|CS_VREDRAW;
	wcWindowClass.hInstance = hInst;
	wcWindowClass.lpszClassName = lpzClassName;
	wcWindowClass.hCursor = NULL;//LoadCursor(NULL, IDC_ARROW);
	wcWindowClass.hbrBackground = CreateSolidBrush(0xFFFFFF00);//(HBRUSH)COLOR_APPWORKSPACE;
	return RegisterClass(&wcWindowClass);
}


void paintGradient(HDC hdc, int left, int right, int top, int bottom) {

	RECT rect;
	HBRUSH hBrush;
	HBRUSH hOldBrush;
	int i;
	for (i = 0 ; i < 64; i++) {
		rect.left = left + (i*(right-left+1))/64;
		rect.top = top;
		rect.right = left + ((i+1)*(right-left+1))/64;
		rect.bottom = bottom;

		hBrush = CreateSolidBrush(0xFF000000 | (((i*(color_B))/64) << 16)| (((i*(color_G))/64) << 8)| (((i*(color_R))/64)));
		if (i == 0) {
			hOldBrush = (HBRUSH)SelectObject(hdc, hBrush);
		}
		else {
			SelectObject(hdc, hBrush);
		}
		FillRect(hdc, &rect, hBrush);
		DeleteObject(hBrush);
	}
	SelectObject(hdc, hOldBrush);

}

LRESULT CALLBACK RainbowWndProc(
						 HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	RECT rect;
	GetClientRect(hWnd,&rect);
	int wnd_w = rect.right - rect.left;

	switch (message)
	{
	case WM_LBUTTONUP:
		//MessageBox(hWnd, TEXT("Touch !"), TEXT("Event"), 0);
		break;
	case WM_PAINT :
		PAINTSTRUCT ps;
		HDC hDC;

		hDC = BeginPaint(hWnd,&ps);

		paintGradient(hDC, cur_x - wnd_w, cur_x, rect.top, rect.bottom);
		paintGradient(hDC, cur_x, cur_x + wnd_w, rect.top, rect.bottom);

		EndPaint(hWnd,&ps);


		break;
	case WM_TIMER :
		cur_x += 5;
		if (cur_x > wnd_w) {
			cur_x = 0;
		}
		InvalidateRect(hWnd, NULL, false);

		SetTimer(hWnd, TIMER_ID, 50, NULL);
		break;
	case WM_COMMAND :
		// close the native view !
		rho_webview_navigate("/app/NativeView/goto_html", 0);	

		break;
	default:  
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}











HWND registerAndMakeRainbowWindow() {

	HINSTANCE hInstance = NULL;

	LPCTSTR lpzClass = TEXT(RAINBOW_WINDOW_CLASS_ID);

	RegRainbowWindowClass(hInstance, lpzClass);

	RECT rect;
	GetWindowRect((HWND)RhoNativeViewManager::getWebViewObject(-1),&rect);

	color_R = 255;
	color_G = 255;
	color_B = 0;


	int x = 0;
	int y = 0;
	int w = rect.right - rect.left;
	int h = rect.bottom - rect.top;

	cur_x = 0;

	HWND hWnd = CreateWindow(lpzClass, TEXT("Native Window"), 
		WS_VISIBLE, x, y, w, h, 0, NULL, 
		hInstance, NULL);

	HWND hButton = CreateWindow(TEXT("BUTTON"), TEXT("Close Native View"), 
		WS_VISIBLE, (w - 300)/2, h - 100, 300, 40, hWnd, NULL, 
		hInstance, NULL);

	SetTimer(hWnd, TIMER_ID, 50, NULL);

	InvalidateRect(hWnd, NULL, true);

	return hWnd;
}


static HWND small_window_hwnd = NULL;

void open_small_rainbow_window_command() {

	HINSTANCE hInstance = NULL;

	LPCTSTR lpzClass = TEXT(RAINBOW_WINDOW_CLASS_ID);

	RegRainbowWindowClass(hInstance, lpzClass);

	color_R = 255;
	color_G = 255;
	color_B = 0;

	cur_x = 0;

	HWND webViewHWND = (HWND)RhoNativeViewManager::getWebViewObject(-1);

	HWND hWnd = CreateWindow(lpzClass, TEXT("Native Window"), 
		WS_VISIBLE, 50, 50, 200, 100, 0, NULL, 
		hInstance, NULL);

	SetParent(hWnd, webViewHWND);
	ShowWindow(hWnd, SW_SHOWNORMAL);

	::SetWindowPos(hWnd, HWND_TOP, 50, 50, 200, 100, SWP_SHOWWINDOW);

	SetTimer(hWnd, TIMER_ID, 50, NULL);

	InvalidateRect(hWnd, NULL, true);

	small_window_hwnd = hWnd;

}

void close_small_rainbow_window_command() {
	if (small_window_hwnd != NULL) {
		DestroyWindow(small_window_hwnd);
		small_window_hwnd = NULL;
	}
}

class RainbowOpenSmallViewCommand : public RhoNativeViewRunnable {
public:
	void run() {
		open_small_rainbow_window_command();
	}
};

class RainbowCloseSmallViewCommand : public RhoNativeViewRunnable {
public:
	void run() {
		close_small_rainbow_window_command();
	}
};

static RainbowOpenSmallViewCommand rainbow_open_command;
static RainbowCloseSmallViewCommand rainbow_close_command;

extern "C" void rainbow_open_native_view() {
	RhoNativeViewUtil::executeInUIThread_WM(&rainbow_open_command);
}

extern "C" void rainbow_close_native_view() {
	RhoNativeViewUtil::executeInUIThread_WM(&rainbow_close_command);
}

extern "C" void rainbow_execute_command_in_native_view(const char* command) {
	if (strcmp(command, "red") == 0) {
		color_R = 255;
		color_G = 0;
		color_B = 0;
	}
	if (strcmp(command, "green") == 0) {
		color_R = 0;
		color_G = 255;
		color_B = 0;
	}
	if (strcmp(command, "blue") == 0) {
		color_R = 0;
		color_G = 0;
		color_B = 255;
	}
	if (strcmp(command, "play") == 0) {
		if (small_window_hwnd != NULL) {
			KillTimer(small_window_hwnd, TIMER_ID);
			SetTimer(small_window_hwnd, TIMER_ID, 50, NULL);
		}
	}
	if (strcmp(command, "stop") == 0) {
		if (small_window_hwnd != NULL) {
			KillTimer(small_window_hwnd, TIMER_ID);
		}
	}
	InvalidateRect(small_window_hwnd, NULL, true);
}



class RainbowNativeView : public NativeView {
public:
	RainbowNativeView() {
		mViewHWND = 0;
	}
	virtual ~RainbowNativeView() {
		if (mViewHWND != 0) {
			KillTimer(mViewHWND, 555);
			//CloseWindow(mViewHWND);
			//ShowWindow(mViewHWND, SW_HIDE);
			//SetParent(mViewHWND, 0);
			DestroyWindow(mViewHWND);
		}
	}

	virtual void* getView() {
		if (mViewHWND == 0) {
			mViewHWND = registerAndMakeRainbowWindow();
		}
		return mViewHWND;
	}

	virtual void navigate(const char* url) {
		if (strcmp(url, "red") == 0) {
			color_R = 255;
			color_G = 0;
			color_B = 0;
		}
		if (strcmp(url, "green") == 0) {
			color_R = 0;
			color_G = 255;
			color_B = 0;
		}
		if (strcmp(url, "blue") == 0) {
			color_R = 0;
			color_G = 0;
			color_B = 255;
		}
	}
private:
	HWND mViewHWND;
};

class RainbowNativeViewFactory;

static RainbowNativeViewFactory* ourFactory = NULL;

class RainbowNativeViewFactory : public NativeViewFactory {
public:

	virtual NativeView* getNativeView(const char* viewType) {
		return new RainbowNativeView();
	}

	virtual void destroyNativeView(NativeView* nativeView) {
		delete nativeView;
	}

	static RainbowNativeViewFactory* instance() {
		if (ourFactory == NULL) {
			ourFactory = new RainbowNativeViewFactory();
		}
		return ourFactory;
	}

};


extern "C" void Init_RainbowRuby(void);	

extern "C" void Init_Rainbow() {
	RhoNativeViewManager::registerViewType("rainbow_view", RainbowNativeViewFactory::instance());
	Init_RainbowRuby();

};

