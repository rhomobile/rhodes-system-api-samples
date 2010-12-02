package com.rainbow;

import java.util.ArrayList;

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
	private static ArrayList ourViews = new ArrayList();
	
	private static final boolean logging_enable = false;	
	
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

	public static int makeNativeView() {
		Context ctx = RhodesService.getInstance().getContext();
		View view = new RainbowBigView(ctx, null);
		ourViews.add(view);
		return ourViews.size()-1;
	}
	
	public static View getViewById(int id) {
		if ((id >= 0) && (id < ourViews.size())) {
			return (View)ourViews.get(id);
		}
		return null;
	}
	
	public static void navigateInNativeView(int id, String command) {
		if (logging_enable) RhodesService.platformLog("Rainbow", "navigateInNativeView() START");
		View view = getViewById(id);
		if ((view == null) || (command == null)) {
			if (logging_enable) RhodesService.platformLog("Rainbow", "navigateInNativeView() view or command is null !!!");
			return;
		}
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
		if (logging_enable) RhodesService.platformLog("Rainbow", "navigateInNativeView() FINISH");
	}
	
	public static void destroyNativeView(int id) {
		// nothing - Java objects will remove automatically
		ourViews.set(id, null);
	}
	
	public static native void returnToHTML();
	
}
