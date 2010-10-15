//
//  RainbowView.m
//  Rainbow
//
//  Created by Dmitry Soldatenkov on 8/26/10.
//  Copyright 2010 __Rhomobile__. All rights reserved.
//


#import "RainbowEffectView.h"

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

