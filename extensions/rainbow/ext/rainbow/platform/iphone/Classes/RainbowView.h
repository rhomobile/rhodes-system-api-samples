
//
//  RainbowView.h
//  Rainbow
//
//  Created by Dmitry Soldatenkov on 8/26/10.
//  Copyright 2010 __Rhomobile__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RainbowEffectView.h"


@interface RainbowView : UIView {
	
	CGMutablePathRef mPath;
	CGPoint mLastPoint;
	RainbowEffectView* mEffectView;
	
}

- (id)init;
- (void)dealloc;
- (void)doClear;
- (UIImage*)makeUIImage;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)navigate:(const char*)url;

@end
