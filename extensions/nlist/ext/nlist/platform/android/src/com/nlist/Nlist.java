package com.nlist;

import java.util.Map;

import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;

import com.rhomobile.rhodes.extmanager.AbstractRhoExtension;
import com.rhomobile.rhodes.extmanager.IRhoExtManager;
import com.rhomobile.rhodes.extmanager.IRhoExtension;
import com.rhomobile.rhodes.extmanager.IRhoWebView;
import com.rhomobile.rhodes.extmanager.RhoExtManager;
import com.rhomobile.rhodes.util.PerformOnUiThread;

public class Nlist {

	private static NlistView ourListView = null;
	private static NlistAdapter ourAdapter = null;
	private static NlistDataCache ourDataCache = null;
	private static String ourCallbackURL = null;
	
	private static IRhoExtension ourExtListener = null;
	
	public static void openViewCommand() {
		
		View w = (View)RhoExtManager.getInstance().getWebView().getContainerView();
		
		ourListView = new NlistView(ourAdapter);
		
		ourListView.setLayoutParams(
				new AbsoluteLayout.LayoutParams(	ViewGroup.LayoutParams.MATCH_PARENT, 
													ViewGroup.LayoutParams.MATCH_PARENT, 
													0, 
													0));
		//ViewGroup wv = (ViewGroup)(((View)w).getParent());
		ViewGroup wv = (ViewGroup)(((View)w));
		if ((wv != null) && (ourListView != null)) {
			wv.addView(ourListView);
			wv.bringChildToFront(ourListView);	
			ourListView.requestFocus();
			ourListView.bringToFront();
			ourListView.invalidate();
		}
		if (ourExtListener == null) {
			ourExtListener = new AbstractRhoExtension() {
				public boolean onBeforeNavigate(IRhoExtManager extManager, String url,
						IRhoWebView webView, boolean res) {
					closeViewCommand();
					return res;
				}
			};
			RhoExtManager.getInstance().registerExtension("nlist", ourExtListener);
		}
	}
	
	public static void closeViewCommand() {
		View w = (View)RhoExtManager.getInstance().getWebView().getContainerView();
		//ViewGroup wv = (ViewGroup)(((View)w).getParent());
		ViewGroup wv = (ViewGroup)(((View)w));
		if ((wv != null) && (ourListView != null)) {
			wv.removeView(ourListView);
			ourListView = null;
			ourAdapter = null;
			ourDataCache = null;
			ourCallbackURL = null;
		}
	}
	
	public static void openView(Object params, String callback) {
		
		Map<Object,Object> settings = (Map<Object,Object>)params;
		
		   //list_params = { :items_count => 10000, :item_height => 64, :item_request_url => base_url, :data_request_url => data_url, :item_data_cache_size => 300, :item_data_portion_size => 50}
		   	
		int items_count = 0;
		int item_data_portion_size = 10;
		int item_data_cache_size = 0;
		String data_request_url = null;
		ourCallbackURL = callback;
		
		
		Object count_obj = settings.get("items_count");
		if ((count_obj != null) && (count_obj instanceof String)) {
			items_count = Integer.parseInt((String)count_obj);
		}
		
		Object item_data_portion_size_obj = settings.get("item_data_portion_size");
		if ((item_data_portion_size_obj != null) && (item_data_portion_size_obj instanceof String)) {
			item_data_portion_size = Integer.parseInt((String)item_data_portion_size_obj);
		}
		
		Object item_data_cache_size_obj = settings.get("item_data_cache_size");
		if ((item_data_cache_size_obj != null) && (item_data_cache_size_obj instanceof String)) {
			item_data_cache_size = Integer.parseInt((String)item_data_cache_size_obj);
		}

		Object data_request_url_obj = settings.get("data_request_url");
		if ((data_request_url_obj != null) && (data_request_url_obj instanceof String)) {
			data_request_url = (String)data_request_url_obj;
		}
		ourDataCache = new NlistDataCache(data_request_url, item_data_cache_size, item_data_portion_size, items_count);
		ourAdapter = new NlistAdapter(items_count, ourDataCache);
		
		PerformOnUiThread.exec( new Runnable () {
			public void run() {
				closeViewCommand();
				openViewCommand();
			}
		});
		
	}
	
	public static void closeView() {
		PerformOnUiThread.exec( new Runnable () {
			public void run() {
				closeViewCommand();
			}
		});
	}
	
	private static native void callCallback(String url, String body);
	
	public static void onItemClicked(int index) {
		if (ourCallbackURL != null) {
			callCallback(ourCallbackURL, "&rho_callback=1&selected_item="+String.valueOf(index));
		}
	}
	
}
