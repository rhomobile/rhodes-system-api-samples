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



@implementation RainbowEffectView

- (id)initWithFrame:(CGRect)rect {
	if ((self = [super initWithFrame:rect])) {
        // Initialization code
		self.backgroundColor = [UIColor blackColor];
		self.opaque = YES;
    }
	timer = nil;
	currentPosition = 0;
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();//CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGFloat bsc[4] = {1,1,0,1};
	baseColor = CGColorCreate(clr_spc, bsc);
	CGFloat bkgc[4] = {0,0,0,1};
	bkgColor = CGColorCreate(clr_spc, bkgc);
    CGColorSpaceRelease(clr_spc);
	return self;
}

- (void)dealloc {
	[timer release];
	CGColorRelease(baseColor);
	CGColorRelease(bkgColor);
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGFloat locations[2];
	locations[0] = 0;
	locations[1] = 1;
	CGColorSpaceRef clr_spc = CGColorSpaceCreateDeviceRGB();
 
	CGFloat* c1 = CGColorGetComponents(bkgColor);
	CGFloat* c2 = CGColorGetComponents(baseColor);
	CGFloat components[8] = { c1[0], c1[1], c1[2], c1[3],  // Start color
	c2[0], c2[1], c2[2], c2[3] }; 
	size_t num_locations = 2;
 
	CGGradientRef gradient = CGGradientCreateWithColorComponents (clr_spc, components,locations, num_locations);	 
	CGRect myrect = [self frame];
	CGPoint p0;
	CGPoint p1;
	CGPoint p2;
	CGFloat curPos = (myrect.size.width * (CGFloat)currentPosition) / (100.0);
	p0.x = curPos - myrect.size.width;
	p0.y = 0;
	p1.x = curPos;
	p1.y = 0;
	p2.x = curPos + myrect.size.width;
	p2.y = 0;
	
	CGContextDrawLinearGradient(
								context,
								gradient,
								p0,
								p1,
								0
								);
	CGContextDrawLinearGradient(
								context,
								gradient,
								p1,
								p2,
								0
								);
	
	CGGradientRelease(gradient);
    CGColorSpaceRelease(clr_spc);
}

- (void)play {
	[self stop];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.f/25.f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stop {
	[timer invalidate];
	timer = nil;
}

- (void)setBaseColor:(CGColorRef)color {
	//CGColorRelease(baseColor);
	baseColor = color;
	CGColorRetain(baseColor);
	[self setNeedsDisplay];
}

- (void)onTimer:(id)info {
	currentPosition++;
	if (currentPosition > 100) {
		currentPosition = 0;
	}
	[self setNeedsDisplay];
}


@end



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
