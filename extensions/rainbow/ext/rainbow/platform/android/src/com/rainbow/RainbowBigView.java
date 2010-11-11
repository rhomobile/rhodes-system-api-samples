package com.rainbow;

import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.PointF;
import android.os.Bundle;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.LinearLayout;

import java.io.Serializable;
import java.io.IOException;

//import com.rhomobile.rhodes.Logger;

class RainbowBigView extends LinearLayout {

	public RainbowView mRainbowView = null;

	private static final String TAG = "RainbowBigView";
	
	
    /** Handle to the application context, used to e.g. fetch Drawables. */
    private Context mContext;
	
	
    
   
    public RainbowBigView(Context context, AttributeSet attrs) {
        super(context, attrs);


		setOrientation(LinearLayout.VERTICAL);
 
        setVisibility(VISIBLE);

        setFocusable(true); // make sure we get key events
        
        setBackgroundColor(Color.GRAY);
        
    	Button button = new Button(context);
    	button.setClickable(true);
    	String msg = "Close Native View";
    	button.setText(msg.toCharArray(), 0, msg.length());
    	
    	mRainbowView = new RainbowView(context, attrs);
    	
    	addView( mRainbowView, 0, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, 0, 1));

        button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Perform action on click
            	Rainbow.returnToHTML();
            }
        });

    	addView( button, 1, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT, 0));
    }
    
}




