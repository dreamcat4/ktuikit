//
//  KTStyleManager.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTStyle.h"

@interface KTStyleManager : NSObject 
{
	NSColor *			mBackgroundColor;
	NSColor *			mBorderColorTop;
	NSColor *			mBorderColorRight;
	NSColor *			mBorderColorBottom;
	NSColor *			mBorderColorLeft;
	//NSColor *			mRoundedRectBorderColor;
	//BOOL				mDrawAsRoundedRect;
	
	CGFloat				mBorderWidthTop;
	CGFloat				mBorderWidthRight;
	CGFloat				mBorderWidthBottom;
	CGFloat				mBorderWidthLeft;
	//CGFloat				mRoundedRectBorderWidth;
	
	NSGradient *		mBackgroundGradient;
	CGFloat				mGradientAngle;
	NSImage *			mBackgroundImage;
	BOOL				mTileImage;
	
	id<KTStyle>			wView;
}

@property(readwrite,retain) NSColor * backgroundColor;
@property(readwrite,retain) NSGradient * backgroundGradient;
@property(readwrite,assign) CGFloat gradientAngle;
@property(readwrite,retain) NSColor * borderColorTop;
@property(readwrite,retain) NSColor * borderColorRight;
@property(readwrite,retain) NSColor * borderColorBottom;
@property(readwrite,retain) NSColor * borderColorLeft;
@property(readwrite,assign) CGFloat	borderWidthTop;
@property(readwrite,assign) CGFloat borderWidthRight;
@property(readwrite,assign) CGFloat borderWidthBottom;
@property(readwrite,assign) CGFloat borderWidthLeft;


- (id)initWithView:(id<KTStyle>)theView;
- (void)setView:(id<KTStyle>)theView;

// Extra configuration API

- (void)setBackgroundImage:(NSImage*)theBackgroundImage tile:(BOOL)theBool;
- (void)setBackgroundGradient:(NSGradient*)theGradient angle:(CGFloat)theAngle;

- (void)setBorderColor:(NSColor*)theColor;
- (void)setBorderColorTop:(NSColor*)TheTopColor right:(NSColor*)theRightColor bottom:(NSColor*)theBottomColor left:(NSColor*)theLeftColor;
- (void)setBorderWidth:(CGFloat)theWidth;
- (void)setBorderWidthTop:(CGFloat)theTopWidth right:(CGFloat)theRightWidth bottom:(CGFloat)theBottomWidth left:(CGFloat)theLeftWidth;


- (void)drawStylesInRect:(NSRect)TheFrame context:(CGContextRef)theContext view:(id<KTStyle>)theView;



@end
