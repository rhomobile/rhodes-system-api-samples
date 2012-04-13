package com.nlist;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.util.Xml;

public class NlistDataCache  {

	private String mBaseURL = null;

	private HashMap<Integer,NlistData> mCacheOldest = null;
	private HashMap<Integer,NlistData> mCacheNewest = null;
	
	private int mCacheSize = 0;
	private int mPortionSize = 0;
	private int mFullSize = 0;
	
	public NlistDataCache(String baseURL, int cache_size, int portion_size, int full_size) {
		mBaseURL = baseURL;
		mCacheOldest = new HashMap<Integer,NlistData>();
		mCacheNewest = new HashMap<Integer,NlistData>();
		mCacheSize = cache_size;
		mPortionSize = portion_size;
		mFullSize = full_size;
	}
	
	public NlistData getData(int index) {
		NlistData data = mCacheNewest.get(new Integer(index));
		if (data == null) {
			data = mCacheOldest.get(new Integer(index));
		}
		
		if (data == null) {
			try {
				executeHttpGet(index - (mPortionSize/2), mPortionSize);
			}
			catch (Exception e) {
				// TODO: handle exception
			}
		}
		data = mCacheNewest.get(new Integer(index));
		if (data == null) {
			data = mCacheOldest.get(new Integer(index));
		}
		
		return data;
	}
	
	
	
	private class DataParser extends DefaultHandler {
		
		private int mIndex = -1;
		private StringBuffer mData = null;
		
	    @Override
	    public void characters(char[] ch, int start, int length)
	            throws SAXException {
	        super.characters(ch, start, length);
	        String chars = new String(ch, start, length);
	        if (mData == null) {
	        	mData = new StringBuffer(chars);
	        }
	        else {
	        	mData.append(chars);
	        }
	        
	    }

	    @Override
	    public void endElement(String uri, String localName, String name)
	            throws SAXException {
	        super.endElement(uri, localName, name);
	        if (localName.equalsIgnoreCase("item")) {
	        	if ((mIndex >= 0) && (mData != null)) {
	        		
	        		if (mCacheNewest.size() > (mCacheSize/2)) {
	        			mCacheOldest = mCacheNewest;
	        			mCacheNewest = new HashMap<Integer, NlistData>();
	        		}
	        		
	        		mCacheNewest.put(new Integer(mIndex), new NlistData(mData.toString()));
	        	}
        		mData = null;
	        }
	    }

	    @Override
	    public void startElement(String uri, String localName, String name,
	            Attributes attributes) throws SAXException {
	        super.startElement(uri, localName, name, attributes);
	        if (localName.equalsIgnoreCase("item") && (attributes != null)) {
	        	String sindex = attributes.getValue("index");
	        	if (sindex != null) {
	        		mIndex = Integer.parseInt(sindex);
	        	}
	        }
	    }		
		
		public void parseXML(Reader reader) {
			try {
	            Xml.parse(reader, this);
	        } catch (Exception e) {
	            throw new RuntimeException(e);
	        }			
		}
	}
	
	
	public void executeHttpGet(int index, int count) throws Exception {
        BufferedReader in = null;
        int start = index;
        int size = count;
        if (start < 0) {
        	start = 0;
        }
        if (start >= mFullSize) {
        	start = mFullSize-1;
        }
        if ((start + size) > mFullSize) {
        	size = mFullSize - start;
        }
        try {
            HttpClient client = new DefaultHttpClient();
            HttpGet request = new HttpGet();
            request.setURI(new URI(mBaseURL + "?&start_item="+String.valueOf(start)+"&items_count="+String.valueOf(size)));
            HttpResponse response = client.execute(request);
            in = new BufferedReader
            (new InputStreamReader(response.getEntity().getContent()));
            
            DataParser parser = new DataParser();
            parser.parseXML(in);
        } finally {
            if (in != null) {
                try {
                    	in.close();
                    } 
                catch (IOException e) {
                    	e.printStackTrace();
                }
            }
        }
    }	

	
}
