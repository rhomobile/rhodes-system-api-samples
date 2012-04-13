package com.nlist;

import java.util.ArrayList;

import com.rhomobile.rhodes.RhodesService;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.widget.AdapterView;
import android.widget.ListView;

public class NlistView extends ListView {

	public NlistView(NlistAdapter adapter) {
		super(RhodesService.getContext());
		setAdapter(adapter);
		setBackgroundColor(0xFF000000);

		setOnItemClickListener(new AdapterView.OnItemClickListener() {
   		    public void onItemClick(android.widget.AdapterView adapter, android.view.View view, int position, long arg3) {  
		        Nlist.onItemClicked(position);     
	        }
        });  	
	}
	
}
