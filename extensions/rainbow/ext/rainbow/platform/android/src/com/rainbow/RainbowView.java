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
import android.view.ViewParent;
import android.webkit.WebView;
import android.widget.Button;

import java.io.Serializable;
import java.io.IOException;

//import com.rhomobile.rhodes.Logger;

class RainbowView extends SurfaceView implements SurfaceHolder.Callback {

	public static String mStateID = "RainbowViewState";

	int mCurrentPosition;
	int mColorR;
	int mColorG;
	int mColorB;
	int mIsAnimation;
	Timer mTimer = null;

	
	private class RainbowTimerTask extends TimerTask {
		public void run () {
			onAnimate();
		}
	}

	private class InvalidateTask implements Runnable {
		public void run () {
			invalidate();
		}
	}
	
	public class RainbowViewState extends Object implements Serializable {
		// use this for save/restore state of view
		int mCurrentPosition;
		int mColorR;
		int mColorG;
		int mColorB;
		int mIsAnimation;

		private void writeObject(java.io.ObjectOutputStream out) throws IOException {
			out.writeInt(mCurrentPosition);
			out.writeInt(mColorR);
			out.writeInt(mColorG);
			out.writeInt(mColorB);
			out.writeInt(mIsAnimation);
		}
		
		private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
			mCurrentPosition = in.readInt();
			mColorR = in.readInt();
			mColorG = in.readInt();
			mColorB = in.readInt();
			mIsAnimation = in.readInt();
		}
	}

	private static final String TAG = "RainbowView";
	
	
    /** Handle to the application context, used to e.g. fetch Drawables. */
    private Context mContext;
	
    Bitmap mBitmap = null;
    Canvas mCanvas = null;
    
    private Handler mHandler = new Handler();
    private Runnable mInvalidateTask = new InvalidateTask();
    
  
    public void playAnimation() {
    	if (mIsAnimation != 0) {
    		return;
    	}
    	stopAnimation();
    	mIsAnimation = 1;
    	mTimer = new Timer("RainbowTimer");
    	mTimer.schedule(new RainbowTimerTask(), 50, 50);
    	mHandler.post(mInvalidateTask);
    }

    public void stopAnimation() {
    	if (mIsAnimation == 0) {
    		return;
    	}
    	mIsAnimation = 0;
    	if (mTimer != null) {
    		mTimer.cancel();
    		mTimer = null;
    	}
    	mHandler.post(mInvalidateTask);
    }

    public void setColor(int R, int G, int B) {
    	mColorR = R;
    	mColorG = G;
    	mColorB = B;
    	mHandler.post(mInvalidateTask);
    }
    
    private void onAnimate() {
    	mCurrentPosition = mCurrentPosition + 1;
    	if (mCurrentPosition >= 100) {
    		mCurrentPosition = 0;
    	}
    	mHandler.post(mInvalidateTask);
    	//doFullRedraw();
    }
    
	public void onRestoreInstanceState(Bundle savedInstanceState) {
		RainbowViewState s = (RainbowViewState)savedInstanceState.getSerializable(mStateID);
		mCurrentPosition = s.mCurrentPosition;
		mColorR = s.mColorR;
		mColorG = s.mColorG;
		mColorB = s.mColorB;
		mIsAnimation = s.mIsAnimation;
		if (mIsAnimation != 0) {
			playAnimation();
		}
	}

	public void onSaveInstanceState(Bundle outState) {
		RainbowViewState s = new RainbowViewState();
		s.mCurrentPosition = mCurrentPosition;
		s.mColorR = mColorR;
		s.mColorG = mColorG;
		s.mColorB = mColorB;
		s.mIsAnimation = mIsAnimation;
		outState.putSerializable(mStateID, s);
	}
	
	private void drawHorizontalGradient(Canvas canvas, int left, int top, int right, int bottom) {
        Paint paint = new Paint();
        paint.setAntiAlias(false);
        paint.setARGB(255, 0, 0, 0);
        int i;
        for (i = 0 ; i < 64; i++) {
        	int cleft = left + (i*(right-left+1))/64;
        	int ctop = top;
        	int cright = left + ((i+1)*(right-left+1))/64;
        	int cbottom = bottom;
        	paint.setARGB(255, (i*(mColorR))/64, (i*(mColorG))/64, (i*(mColorB))/64);
       		canvas.drawRect(cleft, ctop, cright, cbottom, paint);
        }
	}
	
	private void doFullRedraw() {
		if ((mBitmap == null) || (mCanvas == null)) {
			return;
		}
        int curpos = (mCurrentPosition*mCanvas.getWidth())/100;
        mCanvas.clipRect(0,0,mCanvas.getWidth(), mCanvas.getHeight());
        drawHorizontalGradient(mCanvas, curpos - mCanvas.getWidth(), 0, curpos, mCanvas.getHeight());
        drawHorizontalGradient(mCanvas, curpos, 0, curpos + mCanvas.getWidth(), mCanvas.getHeight());
        // update screen
        /*
	     Canvas c = null;
	     try {
	         c = getHolder().lockCanvas(null);
	         if (c != null) {
	        	 synchronized (getHolder()) {
	        		 c.drawBitmap(mBitmap, 0, 0, null);
	        	 }
	         }
	     } finally {
	         if (c != null) {
	        	 getHolder().unlockCanvasAndPost(c);
	         }
	     }
	     //*/    	 
	}
	
	protected void onDraw (Canvas canvas) {
		//super.onDraw(canvas);
		if (mBitmap != null) {
			doFullRedraw();
			canvas.drawBitmap(mBitmap, 0, 0, null);
		}
	}
    
   
    public RainbowView(Context context, AttributeSet attrs) {
        super(context, attrs);
        //Logger.D(TAG, "RainbowView()");

        // register our interest in hearing about changes to our surface
        SurfaceHolder holder = getHolder();
        holder.addCallback(this);

        setVisibility(VISIBLE);

	mCurrentPosition = 0;
	mColorR = 255;
	mColorG = 255;
	mColorB = 0;
	mIsAnimation = 0;
	
	mTimer = null;
		
	playAnimation();
       
        setFocusable(true); // make sure we get key events
        
        setBackgroundColor(Color.BLACK);
        
        SurfaceHolder surfaceHolder = getHolder();
        if (surfaceHolder != null) {
        		surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_NORMAL);
    	}
        

    }
	
    public Bitmap makeBitmap() {
    	return mBitmap;
    }
    
    public boolean onTouchEvent(MotionEvent event) {
    	 float x = event.getX();
    	 float y = event.getY();
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                	break;
                case MotionEvent.ACTION_MOVE:
                    break;
                case MotionEvent.ACTION_UP:
                    break;
            }
    	 return true;
     }
     
    //protected void onLayout (boolean changed, int left, int top, int right, int bottom) {
    //	super.onLayout(changed, left, top, right, bottom);
    	//surfaceChanged(getHolder(), 0, right-left+1, bottom-top+1);
    //}
    
    /* Callback invoked when the surface dimensions change. */
    public void surfaceChanged(SurfaceHolder holder, int format, int width,
            int height) {
    	if (mBitmap != null) {
	    	if ((mBitmap.getWidth() == width) && (mBitmap.getHeight() == height)) {
	    		return;
	    	}
	   	}
        mBitmap = Bitmap.createBitmap(getWidth(), getHeight(), Bitmap.Config.RGB_565);
        mCanvas = new Canvas(mBitmap);
        doFullRedraw();
    }
    
    /*
     * Callback invoked when the Surface has been created and is ready to be
     * used.
     */
    public void surfaceCreated(SurfaceHolder holder) {
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
 		mBitmap = null;
 		mCanvas = null;
    }
    
}




