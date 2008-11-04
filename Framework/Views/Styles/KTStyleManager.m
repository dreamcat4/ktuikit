//
//  KTStyleManager.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTStyleManager.h"

#define kKTStyleManagerBackgroundColorKey @"backgroundColor"
#define kKTStyleManagerBackgroundGradientKey @"backgroundGradient"
#define kKTStyleManagerBackgroundGradientAngleKey @"gradientAngle"
#define kKTStyleManagerBorderWidthTopKey @"borderWidthTop"
#define kKTStyleManagerBorderWidthRightKey @"borderWidthRight"
#define kKTStyleManagerBorderWidthBottomKey @"borderWidthBottom"
#define kKTStyleManagerBorderWidthLeftKey @"borderWidthLeft"
#define kKTStyleManagerBorderColorTopKey @"borderColorTop"
#define kKTStyleManagerBorderColorRightKey @"borderColorRight"
#define kKTStyleManagerBorderColorBottomKey @"borderColorBottom"
#define kKTStyleManagerBorderColorLeftKey @"borderColorLeft"

@interface KTStyleManager (Private)
- (NSArray*)keysForCoding;
@end


@implementation KTStyleManager

@synthesize backgroundColor = mBackgroundColor;
@synthesize borderColorTop = mBorderColorTop;
@synthesize borderColorRight = mBorderColorRight;
@synthesize borderColorBottom = mBorderColorBottom;
@synthesize borderColorLeft = mBorderColorLeft;
@synthesize	borderWidthTop = mBorderWidthTop;
@synthesize borderWidthRight = mBorderWidthRight;
@synthesize borderWidthBottom = mBorderWidthBottom;
@synthesize borderWidthLeft = mBorderWidthLeft;
@synthesize backgroundGradient = mBackgroundGradient;
@synthesize gradientAngle = mGradientAngle;

//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithView:(id<KTStyle>)theView
{
	if(![super init])
		return self;
	
	[self setView:theView];
	[self setBackgroundColor:[NSColor clearColor]];
	[self setBorderColorTop:[NSColor clearColor] right:[NSColor clearColor] bottom:[NSColor clearColor] left:[NSColor clearColor]];
	[self setBackgroundGradient:nil angle:0];
	[self setBorderWidth:0];
	return self;
}


- (void)dealloc
{
	[mBackgroundColor release];
	[mBorderColorTop release];
	[mBorderColorRight release];
	[mBorderColorBottom release];
	[mBorderColorLeft release];
	[mBackgroundGradient release];
	[mBackgroundImage release];
	
	[super dealloc];
}


//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
	if ([[self superclass] instancesRespondToSelector:@selector(initWithCoder:)]) {
		if (![(id)super initWithCoder:theCoder])
			return nil;
	}
	
	for (NSString *key in [self keysForCoding])
		[self setValue:[theCoder decodeObjectForKey:key] forKey:key];
	
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{
	if ([[self superclass] instancesRespondToSelector:@selector(encodeWithCoder:)])
		[(id)super encodeWithCoder:theCoder];
	for (NSString *key in [self keysForCoding])
		[theCoder encodeObject:[self valueForKey:key] forKey:key];
}

//=========================================================== 
// - keysForCoding
//=========================================================== 
- (NSArray *)keysForCoding
{
	return [NSArray arrayWithObjects:kKTStyleManagerBackgroundColorKey,kKTStyleManagerBackgroundGradientKey, kKTStyleManagerBackgroundGradientAngleKey, kKTStyleManagerBorderWidthTopKey, kKTStyleManagerBorderWidthRightKey, kKTStyleManagerBorderWidthBottomKey, kKTStyleManagerBorderWidthLeftKey, kKTStyleManagerBorderColorTopKey, kKTStyleManagerBorderColorRightKey, kKTStyleManagerBorderColorBottomKey, kKTStyleManagerBorderColorLeftKey, nil];
}

//=========================================================== 
// - setNilValueForKey:
//=========================================================== 
- (void)setNilValueForKey:(NSString *)key;
{
	if([key isEqualToString:kKTStyleManagerBackgroundGradientAngleKey])
		[self setGradientAngle:0.0];
	else if([key isEqualToString:kKTStyleManagerBorderWidthTopKey])
		[self setBorderWidthTop:0.0];
	else if([key isEqualToString:kKTStyleManagerBorderWidthRightKey])
		[self setBorderWidthRight:0.0];
	else if([key isEqualToString:kKTStyleManagerBorderWidthBottomKey])
		[self setBorderWidthBottom:0.0];
	else if([key isEqualToString:kKTStyleManagerBorderWidthLeftKey])
		[self setBorderWidthLeft:0.0];

	else
		[super setNilValueForKey:key];
}


- (void)setView:(id<KTStyle>)theView
{
	wView = theView;
}

- (void)drawStylesInRect:(NSRect)theRect context:(CGContextRef)theContext view:(id<KTStyle>)theView
{
	// either gradient or color fill, if gradient is set, it'll draw instead of color fill....
	 if(mBackgroundGradient != nil)
	 {
		[mBackgroundGradient drawInRect:theRect angle:mGradientAngle];
	 }
	 else if(mBackgroundColor != [NSColor clearColor])
	{
		NSColor * aColor = [mBackgroundColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGContextSetRGBFillColor(theContext, [aColor redComponent], [aColor greenComponent], [aColor blueComponent], [aColor alphaComponent]);
		CGRect aCGViewBounds = CGRectMake(theRect.origin.x, theRect.origin.y, theRect.size.width, theRect.size.height);
		CGContextFillRect(theContext, aCGViewBounds);
	}
	
	// Stroke - we can control color & line thickness of individual
	// sides of the rectangle

	CGContextSetLineWidth(theContext, 1);
	NSPoint	aStrokePoint = theRect.origin;
	
	// move the point to the top left corner to begin, .5 for pixelCracks
	aStrokePoint.y = theRect.size.height - .5;
	
	// Top
	if(		mBorderWidthTop > 0 
		&&	mBorderColorTop != [NSColor clearColor])
	{
		CGContextBeginPath(theContext);
		CGContextMoveToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		aStrokePoint.x += theRect.size.width - .5;
		CGContextAddLineToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		
		CGContextSetLineWidth(theContext, mBorderWidthTop);
		NSColor * aConvertedColor = [mBorderColorTop colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGContextSetRGBStrokeColor(theContext,	
								   [aConvertedColor redComponent], 
								   [aConvertedColor greenComponent], 
								   [aConvertedColor blueComponent], 
								   [aConvertedColor alphaComponent]								   
		);
		CGContextStrokePath(theContext);
	}
	else
	{
		aStrokePoint.x += theRect.size.width - .5;
		//CGPathMoveToPoint(aMutablePath, NULL, aStrokePoint.x,  aStrokePoint.y);
	}
	
	// Right
	if(		mBorderWidthRight > 0 
		&&	mBorderColorRight != [NSColor clearColor])
	{
		CGContextBeginPath(theContext);
		CGContextMoveToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		aStrokePoint.y -= theRect.size.height - 1;  
		CGContextAddLineToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		
		CGContextSetLineWidth(theContext, mBorderWidthRight);
		NSColor * aConvertedColor = [mBorderColorRight colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGContextSetRGBStrokeColor(theContext,	
								   [aConvertedColor redComponent], 
								   [aConvertedColor greenComponent], 
								   [aConvertedColor blueComponent], 
								   [aConvertedColor alphaComponent]								   
		);
		
		CGContextStrokePath(theContext);
	}
	else
	{
		aStrokePoint.y -= theRect.size.height - 1;
	}
	
	// Bottom
	if(		mBorderWidthBottom > 0 
		&&	mBorderColorBottom != [NSColor clearColor])
	{
		CGContextBeginPath(theContext);
		CGContextMoveToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		aStrokePoint.x -= theRect.size.width - 1;     
		CGContextAddLineToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		
		CGContextSetLineWidth(theContext, mBorderWidthBottom);
		NSColor * aConvertedColor = [mBorderColorBottom colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGContextSetRGBStrokeColor(theContext,	
								   [aConvertedColor redComponent], 
								   [aConvertedColor greenComponent], 
								   [aConvertedColor blueComponent], 
								   [aConvertedColor alphaComponent]								   
		);
		CGContextStrokePath(theContext);
	}
	else
	{
		aStrokePoint.x -= theRect.size.width - 1;
	}
	
	// Left
	if(		mBorderWidthLeft > 0 
		&&	mBorderColorLeft != [NSColor clearColor])
	{
		CGContextBeginPath(theContext);
		CGContextMoveToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		aStrokePoint.y += theRect.size.height; 
		CGContextAddLineToPoint(theContext, aStrokePoint.x,  aStrokePoint.y);
		
		CGContextSetLineWidth(theContext, mBorderWidthLeft);
		NSColor * aConvertedColor = [mBorderColorLeft colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGContextSetRGBStrokeColor(theContext,	
								   [aConvertedColor redComponent], 
								   [aConvertedColor greenComponent], 
								   [aConvertedColor blueComponent], 
								   [aConvertedColor alphaComponent]								   
		);
		CGContextStrokePath(theContext);
	}
	
	// let subclasses do their custom drawing
	CGRect aRect;
	aRect.origin.x = theRect.origin.x;
	aRect.origin.y = theRect.origin.y;
	aRect.size.width = theRect.size.width;
	aRect.size.height = theRect.size.height;
}

- (void)setBorderColor:(NSColor*)theColor
{
	[self setBorderColorTop:theColor right:theColor bottom:theColor left:theColor];
}

- (void)setBorderColorTop:(NSColor*)theTopColor right:(NSColor*)theRightColor bottom:(NSColor*)theBottomColor left:(NSColor*)theLeftColor
{
	[self setBorderColorTop:theTopColor];
	[self setBorderColorRight:theRightColor];
	[self setBorderColorBottom:theBottomColor];
	[self setBorderColorLeft:theLeftColor];
}

- (void)setBorderWidth:(CGFloat)theWidth
{
	[self setBorderWidthTop:theWidth right:theWidth bottom:theWidth left:theWidth];
}

- (void)setBorderWidthTop:(CGFloat)theTopWidth right:(CGFloat)theRightWidth bottom:(CGFloat)theBottomWidth left:(CGFloat)theLeftWidth
{
	[self setBorderWidthTop:theTopWidth];
	[self setBorderWidthRight:theRightWidth];
	[self setBorderWidthBottom:theBottomWidth];
	[self setBorderWidthLeft:theLeftWidth];
}

- (void)setBackgroundImage:(NSImage*)theBackgroundImage tile:(BOOL)theBool
{
}

- (void)setBackgroundGradient:(NSGradient*)theGradient angle:(CGFloat)theAngle
{
	[self setBackgroundGradient:theGradient];
	[self setGradientAngle:theAngle];
}



@end
