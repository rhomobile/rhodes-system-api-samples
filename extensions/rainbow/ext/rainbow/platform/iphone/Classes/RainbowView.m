//
//  RainbowView.m
//  Rainbow
//
//  Created by Dmitry Soldatenkov on 8/26/10.
//  Copyright 2010 __Rhomobile__. All rights reserved.
//


#import "RainbowView.h"

// rhodes/platform/shared/rubyext/WebView.h
#import "WebView.h"
//void rho_webview_navigate(const char* url, int index);


// rhodes/platform/shared/common/RhodesApp.h
#import "RhodesApp.h"
//void rho_net_request(const char *url);
//char* rho_http_normalizeurl(const char* szUrl);



@implementation RainbowView



- (id)init {
	if ((self = [super initWithFrame:CGRectMake(0,0,320,460)])) {
        // Initialization code
		self.backgroundColor = [UIColor groupTableViewBackgroundColor];
		self.opaque = YES;
    }

	mEffectView = [[RainbowEffectView alloc] initWithFrame:CGRectMake(20,20,280,100)];
	[self addSubview:mEffectView];
	//[mEffectView play];
	
	
	UIButton* button;
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Red" forState: UIControlStateNormal];
	button.hidden = NO;
	button.frame = CGRectMake(20,130,86,30);
	[button addTarget: self 
               action: @selector(onRed:) 
     forControlEvents: UIControlEventTouchDown];
	[self addSubview:button];
	//[button release];
	
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Green" forState: UIControlStateNormal];
	button.hidden = NO;
	button.frame = CGRectMake(117,130,86,30);
	[button addTarget: self 
               action: @selector(onGreen:) 
     forControlEvents: UIControlEventTouchDown];
	[self addSubview:button];
	//[button release];

	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Blue" forState: UIControlStateNormal];
	button.hidden = NO;
	button.frame = CGRectMake(213,130,86,30);
	[button addTarget: self 
               action: @selector(onBlue:) 
     forControlEvents: UIControlEventTouchDown];
	[self addSubview:button];
	//[button release];
	
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"STOP" forState: UIControlStateNormal];
	button.hidden = NO;
	button.frame = CGRectMake(20,170,135,30);
	[button addTarget: self 
               action: @selector(onStop:) 
     forControlEvents: UIControlEventTouchDown];
	[self addSubview:button];
	//[button release];
	
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"PLAY" forState: UIControlStateNormal];
	button.hidden = NO;
	button.frame = CGRectMake(165,170,135,30);
	[button addTarget: self 
               action: @selector(onPlay:) 
     forControlEvents: UIControlEventTouchDown];
	[self addSubview:button];
	//[button release];

	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Close Native View" forState: UIControlStateNormal];
	button.hidden = NO;
	button.frame = CGRectMake(20,210,280,30);
	[button addTarget: self 
               action: @selector(onClose:) 
     forControlEvents: UIControlEventTouchDown];
	[self addSubview:button];
	//[button release];
	
	[self setNeedsDisplay];
	
    return self;
	
}


- (void)onRed:(id)info {
	//do not change location or view - just execute Ruby code
	rho_net_request(rho_http_normalizeurl("/app/NativeView/goto_red"));
}

- (void)onGreen:(id)info {
	//do not change location or view - just execute Ruby code
	rho_net_request(rho_http_normalizeurl("/app/NativeView/goto_green"));
}

- (void)onBlue:(id)info {
	//do not change location or view - just execute Ruby code
	rho_net_request(rho_http_normalizeurl("/app/NativeView/goto_blue"));
}

- (void)onStop:(id)info {
	[mEffectView stop];
}

- (void)onPlay:(id)info {
	[mEffectView play];
}

- (void)onClose:(id)info {
	//need to change view - should be use navigate instead of net_request
	rho_webview_navigate("/app/NativeView/goto_html", 0);	
}


- (void)dealloc {
	[mEffectView release];
	[super dealloc];
}


- (void)setRed {
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();
	CGFloat bsc[4] = {1,0,0,1};
	CGColorRef baseColor = CGColorCreate(clr_spc, bsc);
	[mEffectView setBaseColor:baseColor];
    CGColorSpaceRelease(clr_spc);
	[self setNeedsDisplay];
}

- (void)setGreen {
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();
	CGFloat bsc[4] = {0,1,0,1};
	CGColorRef baseColor = CGColorCreate(clr_spc, bsc);
	[mEffectView setBaseColor:baseColor];
    CGColorSpaceRelease(clr_spc);
	[self setNeedsDisplay];
}

- (void)setBlue {
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();
	CGFloat bsc[4] = {0,0,1,1};
	CGColorRef baseColor = CGColorCreate(clr_spc, bsc);
	[mEffectView setBaseColor:baseColor];
    CGColorSpaceRelease(clr_spc);
	[self setNeedsDisplay];
}

- (void)navigate:(const char*)url {
	NSString* curl = [NSString stringWithUTF8String:url];
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
		[self onPlay:nil];
	}
	if ([s_stop compare:curl] == NSOrderedSame) {
		[self onStop:nil];
	}
}



@end
