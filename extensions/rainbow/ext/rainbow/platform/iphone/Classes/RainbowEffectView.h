
//
//  RainbowView.h
//  Rainbow
//
//  Created by Dmitry Soldatenkov on 8/26/10.
//  Copyright 2010 __Rhomobile__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RainbowEffectView : UIView {
	NSTimer* timer;
	int currentPosition;
	CGColorRef baseColor;
	CGColorRef bkgColor;
}

- (id)initWithFrame:(CGRect)rect;
- (void)dealloc;

- (void)drawRect:(CGRect)rect;

- (void)play;
- (void)stop;
- (void)setBaseColor:(CGColorRef)color;

- (void)onTimer:(id)info;

@end

