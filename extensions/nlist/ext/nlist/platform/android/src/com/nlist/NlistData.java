package com.nlist;

import java.util.ArrayList;

import org.json.JSONObject;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.os.Bundle;

public class NlistData  {

	private String mTitle = null;
	private String mSubtitle = null;
	private String mNumber = null;
	
	public NlistData(String jsonData) {
		try {
			JSONObject jObject = new JSONObject(jsonData); 
			mTitle = jObject.getString("title");
			mSubtitle = jObject.getString("subtitle");
			mNumber = jObject.getString("number");
		}
		catch (Exception e) {
			// TODO: handle exception
		}
	}
	
	public String getTitle() {
		return mTitle;
	}
	
	public String getSubtitle() {
		return mSubtitle;
	}
	
	public String getNumber() {
		return mNumber;
	}

	
}
