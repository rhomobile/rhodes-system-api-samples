package com.rainbow;

import com.rhomobile.rhodes.RhodesService;

import android.content.Context;
import android.view.View;
import android.webkit.WebView;
import android.widget.AbsoluteLayout;
import android.widget.LinearLayout;
import android.view.Gravity;
import android.view.ViewGroup;

public class Rainbow {

	
	private static RainbowView ourView = null;
	
	public static void openNativeView() {
		RhodesService.getInstance().post( new Runnable() {
			public void run() {
				if (ourView != null) {
					return;
				}
				Context ctx = RhodesService.getInstance().getContext();
		
				ourView = new RainbowView(ctx, null);
				ourView.setLayoutParams(new AbsoluteLayout.LayoutParams(200, 200, 10, 10));
				WebView wv = getWebViewObject(0);
				wv.addView(ourView);
				wv.bringChildToFront(ourView);
			}
		});
		
	}

	public static void closeNativeView() {
		RhodesService.getInstance().post( new Runnable() {
			public void run() {
				if (ourView != null) {
					ViewGroup wv = getWebViewObject(0);
					if (wv != null) {
						ourView.stopAnimation();
						wv.removeView(ourView);
					}
					ourView = null;
				}
			}
		});
	} 

	public static void executeCommandInNativeView(String command) {
		if (ourView == null) {
			return;
		}
		if (command.equals("play")) {
			ourView.playAnimation();
		}
		else if (command.equals("stop")) {
			ourView.stopAnimation();
		}
		else if (command.equals("red")) {
			ourView.setColor(255, 0, 0);
		}
		else if (command.equals("green")) {
			ourView.setColor(0, 255, 0);
		}
		else if (command.equals("blue")) {
			ourView.setColor(0, 0, 255);
		}
	}


	public static native WebView getWebViewObject(int tab_index);
	//{
	//	return RhodesService.getInstance().getMainView().getWebView(tab_index);
	//}

}
