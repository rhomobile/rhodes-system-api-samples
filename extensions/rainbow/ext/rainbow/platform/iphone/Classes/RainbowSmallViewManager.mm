//
//  RainbowSmallViewManager.m
//  Rainbow
//
//  Created by Dmitry Soldatenkov on 10/15/10.
//  Copyright 2010 __Rhomobile__. All rights reserved.
//




#import "RainbowEffectView.h"
//#import "RhodesApp.h"
#import "RainbowSmallViewManager.h"
#import "RhoNativeViewManager.h"



@implementation RainbowSmallViewManager

static RainbowSmallViewManager *instance = NULL;
static RainbowEffectView *view = NULL;

+ (RainbowSmallViewManager*)getInstance {
	if (instance == NULL) {
		instance = [[RainbowSmallViewManager alloc] init];
	}
	return instance;
}

- (void)closeViewCommand:(NSObject*)args {
	if (view != NULL) {
		[view removeFromSuperview];
		[view release];
		view = NULL;
	}
}


- (void)openViewCommand:(NSObject*)args {
	if (view != NULL) {
		[self closeViewCommand:nil];
	}
	view = [[RainbowEffectView alloc] initWithFrame:CGRectMake(20,20,280,100)];
	UIWebView* wv = (UIWebView*)RhoNativeViewManager::getWebViewObject(-1);
	wv = [[wv subviews] objectAtIndex:0];
	[wv addSubview:view];
	[wv setNeedsDisplay];
}




- (void)openView {
	[self performSelectorOnMainThread:@selector(openViewCommand:) withObject:nil waitUntilDone:NO];	
}

- (void)closeView {
	[self performSelectorOnMainThread:@selector(closeViewCommand:) withObject:nil waitUntilDone:NO];	
}



- (void)setRed {
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();
	CGFloat bsc[4] = {1,0,0,1};
	CGColorRef baseColor = CGColorCreate(clr_spc, bsc);
	if (view != NULL) {
		[view setBaseColor:baseColor];
		[view setNeedsDisplay];
	}	
    CGColorSpaceRelease(clr_spc);
}

- (void)setGreen {
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();
	CGFloat bsc[4] = {0,1,0,1};
	CGColorRef baseColor = CGColorCreate(clr_spc, bsc);
	if (view != NULL) {
		[view setBaseColor:baseColor];
		[view setNeedsDisplay];
	}	
    CGColorSpaceRelease(clr_spc);
}

- (void)setBlue {
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();
	CGFloat bsc[4] = {0,0,1,1};
	CGColorRef baseColor = CGColorCreate(clr_spc, bsc);
	if (view != NULL) {
		[view setBaseColor:baseColor];
		[view setNeedsDisplay];
	}	
    CGColorSpaceRelease(clr_spc);
}

- (void)executeCommandCommand:(NSString*)str {
	NSString* curl = str;
	NSString* s_red = @"red";
	NSString* s_green = @"green";
	NSString* s_blue = @"blue";
	NSString* s_play = @"play";
	NSString* s_stop = @"stop";
	if ([s_red compare:curl] == NSOrderedSame) {
		[self setRed];
	}
	if ([s_green compare:curl] == NSOrderedSame) {
		[self setGreen];
	}
	if ([s_blue compare:curl] == NSOrderedSame) {
		[self setBlue];
	}
	if ([s_play compare:curl] == NSOrderedSame) {
		if (view != NULL) {
			[view play];
		}	
	}
	if ([s_stop compare:curl] == NSOrderedSame) {
		if (view != NULL) {
			[view stop];
		}	
	}
}

- (void)executeCommand:(const char*)url {
	NSString* str = [NSString stringWithUTF8String:url];
	[self performSelectorOnMainThread:@selector(executeCommandCommand:) withObject:str waitUntilDone:NO];	
}
	

@end





extern "C" void rainbow_open_native_view() {
	[[RainbowSmallViewManager getInstance] openView];
}

extern "C" void rainbow_close_native_view() {
	[[RainbowSmallViewManager getInstance] closeView];
}

extern "C" void rainbow_execute_command_in_native_view(const char* command) {
	[[RainbowSmallViewManager getInstance] executeCommand:command];
}
