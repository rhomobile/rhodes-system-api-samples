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

	// Part 1 - Native View inside WebView - open manually
	
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


	// Part 2 - Native View entire WebView, open by view type name as prefix of URL
	
	
	public static native WebView getWebViewObject(int tab_index);
	//{
	//	return RhodesService.getInstance().getMainView().getWebView(tab_index);
	//}

	public static View makeNativeView() {
		Context ctx = RhodesService.getInstance().getContext();
		View view = new RainbowBigView(ctx, null);
		return view;
	}
	
	public static void navigateInNativeView(View view, String command) {
		RainbowBigView rbv = (RainbowBigView)view;
		RainbowView rv = rbv.mRainbowView;
		if (command.equals("play")) {
			rv.playAnimation();
		}
		else if (command.equals("stop")) {
			rv.stopAnimation();
		}
		else if (command.equals("red")) {
			rv.setColor(255, 0, 0);
		}
		else if (command.equals("green")) {
			rv.setColor(0, 255, 0);
		}
		else if (command.equals("blue")) {
			rv.setColor(0, 0, 255);
		}
	}
	
	public static void destroyNativeView(View view) {
		// nothing - Java objects will remove automatically
	}
	
	public static native void returnToHTML();
	
}
