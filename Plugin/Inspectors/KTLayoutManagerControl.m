//
//  KTLayoutManagerUI.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTLayoutManagerControl.h"
#import <KTUIKitFramework/KTLayoutManager.h>

#define	kCenterRectSize 100
#define kStrutMarkerSize 10

@interface KTLayoutManagerControl (Private)
- (void)setUpRects;
- (void)drawStrutInRect:(NSRect)theRect flexible:(BOOL)theBool;
//- (CGFloat)marginTopForSelection;
//- (CGFloat)marginRightForSelection;
//- (CGFloat)marginBottomForSelection;
//- (CGFloat)marginLeftForSelection;
//- (KTSizeType)widthTypeForSelection;
//- (KTSizeType)heightTypeForSelection;
//- (KTVerticalPositionType)verticalPositionTypeForSelection;
//- (KTHorizontalPositionType)horizontalPositionTypeForSelection;
@end

@implementation KTLayoutManagerControl

@synthesize delegate = wDelegate;
//=========================================================== 
// - initWithFrame:
//=========================================================== 
- (id)initWithFrame:(NSRect)theFrame
{
	if(![super initWithFrame:theFrame])
		return nil;
		
	[self setUpRects];							
	[[self styleManager] setBorderColor:[NSColor colorWithDeviceWhite:.6 alpha:1]];
	[[self styleManager] setBorderWidth:1];		
	
	return self;
}

//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
	if (![super initWithCoder:theCoder])
		return nil;
	
	[self setDelegate:[theCoder decodeObjectForKey:@"delegate"]];
	
	[self setUpRects];							
	//[[self styleManager] setBackgroundColor:[NSColor whiteColor]];
	[[self styleManager] setBorderColor:[NSColor colorWithDeviceWhite:0 alpha:1]];
	[[self styleManager] setBorderWidth:1];						 
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{	
	[super encodeWithCoder:theCoder];
	
	[theCoder encodeObject:[self delegate] forKey:@"delegate"];
}




//=========================================================== 
// - setUpRects
//=========================================================== 
- (void)setUpRects
{
	// right...this is unreadable, will rewrite...
	CGFloat aMarginLongSize;
	mCenterRect = NSMakeRect([self bounds].size.width*.5-kCenterRectSize*.5+.5, 
							 [self bounds].size.height*.5-kCenterRectSize*.5+.5, 
							 kCenterRectSize, 
							 kCenterRectSize);
	aMarginLongSize = ([self bounds].size.height - kCenterRectSize)/2.0;
	mTopMarginRect = NSMakeRect([self bounds].size.width*.5-kStrutMarkerSize*.5+.5,
								mCenterRect.origin.y+mCenterRect.size.height+2,
								kStrutMarkerSize,
								aMarginLongSize-5);
	mBottomMarginRect = NSMakeRect(mTopMarginRect.origin.x, 2.5, mTopMarginRect.size.width, mTopMarginRect.size.height+1);
	aMarginLongSize = ([self bounds].size.width - kCenterRectSize)/2.0;
	mLeftMarginRect = NSMakeRect(2.5, mCenterRect.origin.y+mCenterRect.size.height*.5-kStrutMarkerSize*.5, aMarginLongSize-4, kStrutMarkerSize);
	mRightMarginRect = NSMakeRect(mCenterRect.origin.x+mCenterRect.size.width+2, mLeftMarginRect.origin.y, mLeftMarginRect.size.width-1, mLeftMarginRect.size.height);
	mCenterHorizontalRect = NSMakeRect(mCenterRect.origin.x+mCenterRect.size.width*.5-15, mCenterRect.origin.y+mCenterRect.size.width*.5, 30, 1);
	mCenterVerticalRect = NSMakeRect(mCenterRect.origin.x+mCenterRect.size.width*.5, mCenterRect.origin.y+mCenterRect.size.height*.5-15, 1, 30);

	if(wRightMarginTextField==nil)
	{
		wRightMarginTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(mRightMarginRect.origin.x, mRightMarginRect.origin.y+mRightMarginRect.size.height, mRightMarginRect.size.width, 16)];
		[wRightMarginTextField setAlignment:NSCenterTextAlignment];
		[wRightMarginTextField setBordered:NO];
		[wRightMarginTextField setBezeled:NO];
		[wRightMarginTextField setFocusRingType:NSFocusRingTypeNone];
		[wRightMarginTextField setDrawsBackground:NO];
		[self addSubview:wRightMarginTextField];
		[wRightMarginTextField release];
	}
	if(wBottomMarginTextField==nil)
	{
		wBottomMarginTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(mBottomMarginRect.origin.x+mBottomMarginRect.size.width+.5, mBottomMarginRect.origin.y+mBottomMarginRect.size.height*.5-8, 60, 16)];
		[wBottomMarginTextField setAlignment:NSLeftTextAlignment];
		[wBottomMarginTextField setBordered:NO];
		[wBottomMarginTextField setBezeled:NO];
		[wBottomMarginTextField setDrawsBackground:NO];
		[wBottomMarginTextField setFocusRingType:NSFocusRingTypeNone];
		[self addSubview:wBottomMarginTextField];
		[wBottomMarginTextField release];
	}
	if(wTopMarginTextField==nil)
	{
		wTopMarginTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(mTopMarginRect.origin.x+mTopMarginRect.size.width+.5, mTopMarginRect.origin.y+mTopMarginRect.size.height*.5-8, 60, 16)];
		[wTopMarginTextField setAlignment:NSLeftTextAlignment];
		[wTopMarginTextField setBordered:NO];
		[wTopMarginTextField setBezeled:NO];
		[wTopMarginTextField setDrawsBackground:NO];
		[wTopMarginTextField setFocusRingType:NSFocusRingTypeNone];
		[self addSubview:wTopMarginTextField];
		[wTopMarginTextField release];
	}
	if(wLeftMarginTextField==nil)
	{
		wLeftMarginTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(mLeftMarginRect.origin.x, mLeftMarginRect.origin.y+mLeftMarginRect.size.height, mLeftMarginRect.size.width, 16)];
		[wLeftMarginTextField setAlignment:NSCenterTextAlignment];
		[wLeftMarginTextField setBordered:NO];
		[wLeftMarginTextField setBezeled:NO];
		[wLeftMarginTextField setDrawsBackground:NO];
		[wLeftMarginTextField setFocusRingType:NSFocusRingTypeNone];
		[self addSubview:wLeftMarginTextField];
		[wLeftMarginTextField release];
	}
	
}



//=========================================================== 
// - drawInContext:
//=========================================================== 
- (void)drawInContext:(CGContextRef)theContext
{
	NSLog(@"drawing %@",self);
	
	NSRect aViewRect = [self bounds];
	aViewRect.origin.x+=.5;
	aViewRect.origin.y+=.5;
	
	NSArray * anInspectedViewArray = nil;
	if([wDelegate respondsToSelector:@selector(inspectedViews)])
		anInspectedViewArray = [wDelegate inspectedViews];
	
	// center rect
	[[NSColor colorWithDeviceWhite:.6 alpha:1] set];
	[NSBezierPath strokeRect:mCenterRect];
	[[NSColor colorWithDeviceRed:103.0/255.0 green:154.0/255.0 blue:255.0/255.0 alpha:.4] set];
	[NSBezierPath fillRect:mCenterRect];
	
	
	BOOL	aFoundMultipleValueHPos = NO;
	BOOL	aFoundMultipleValueVPos = NO;
	BOOL	aFoundMultipleValueWidthType = NO;
	BOOL	aFoundMultipleValueHeightType = NO;

	if([anInspectedViewArray count] > 0)
	{
		// get the first values
		id<KTViewLayout>	aFirstView = [anInspectedViewArray objectAtIndex:0];
		KTLayoutManager *	aFirstLayoutManger = [aFirstView viewLayoutManager];
		
		// margins
		mMarginTop = [[aFirstView parent] frame].size.height - ([aFirstView frame].origin.y+[aFirstView frame].size.height);
		mMarginRight = [[aFirstView parent] frame].size.width - ([aFirstView frame].origin.x+[aFirstView frame].size.width);
		mMarginBottom = [aFirstView frame].origin.y;
		mMarginLeft = [aFirstView frame].origin.x;
		[aFirstLayoutManger setMarginTop:mMarginTop right:mMarginRight bottom:mMarginBottom left:mMarginLeft];
		
		// resizing behaviors
		mHorizontalPositionType = [aFirstLayoutManger horizontalPositionType];
		mVerticalPositionType = [aFirstLayoutManger verticalPositionType];
		mWidthType = [aFirstLayoutManger widthType];
		mHeightType = [aFirstLayoutManger heightType];
				
		int i;
		for(i = 1; i < [anInspectedViewArray count]; i++)
		{
			id<KTViewLayout>	aView = [anInspectedViewArray objectAtIndex:i];
			KTLayoutManager *	aLayoutManager = [aView viewLayoutManager];
			
			// Vertical Behavior
			
			// top margin
			CGFloat aViewMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
			[aLayoutManager setMarginTop:aViewMargin];
			if(aViewMargin!=mMarginTop)
				mMarginTop = -1;
			// bottom margin
			aViewMargin = [aView frame].origin.y;
			[aLayoutManager setMarginBottom:aViewMargin];
			if(aViewMargin!=mMarginBottom)
				mMarginBottom = -1;	
			// vertical pos
			if([aLayoutManager verticalPositionType]!=mVerticalPositionType)
				aFoundMultipleValueVPos = YES;
			// height type
			if([aLayoutManager heightType]!=mHeightType)
				aFoundMultipleValueHeightType = YES;
		
			// Horizontal Behavior
			
			// margin left
			aViewMargin = [aView frame].origin.x;
			[aLayoutManager setMarginLeft:aViewMargin];
			if(aViewMargin!=mMarginLeft)
				mMarginLeft = -1;
			// margin right
			aViewMargin = [[aView parent] frame].size.width - ([aView frame].origin.x+[aView frame].size.width);
			[aLayoutManager setMarginRight:aViewMargin];
			if(aViewMargin!=mMarginRight)
				mMarginRight = -1;
			// horizontal pos
			if([aLayoutManager horizontalPositionType]!=mHorizontalPositionType)
				aFoundMultipleValueHPos = YES;
			//width type
			if([aLayoutManager widthType]!=mWidthType)
				aFoundMultipleValueWidthType = YES;
		}
	}
	
	// draw vertical layout info
	if(mMarginTop!=-1)
	{
	
		NSLog(@"margin top: %f", mMarginTop);
	}
	else
		NSLog(@"margin top: multiple values");

	
	if(aFoundMultipleValueVPos==NO)
	{
	
		// Top Strut
		
		if(		mVerticalPositionType == KTVerticalPositionStickTop
			||	mHeightType == KTSizeFill )
		{
			// draw top strut enabled
			[[NSColor blackColor] set];
			[wTopMarginTextField setIntValue:mMarginTop];
			if(mMarginTop >= 0)
				[wTopMarginTextField setTextColor:[NSColor blackColor]];
			else
				[wTopMarginTextField setTextColor:[NSColor redColor]];
			[wTopMarginTextField setEnabled:YES];
			[wTopMarginTextField setEditable:YES];
			[wTopMarginTextField setSelectable:YES];
			[self drawStrutInRect:mTopMarginRect flexible:NO];	
		}
		else
		{
			// draw top strut disabled
			[[NSColor colorWithDeviceWhite:.6 alpha:1] set];
			[wTopMarginTextField setStringValue:@"flexible"];
			[wTopMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:1]];
			[wTopMarginTextField setEnabled:YES];
			[wTopMarginTextField setEditable:NO];
			[wTopMarginTextField setSelectable:NO];
			[self drawStrutInRect:mTopMarginRect flexible:YES];	
		}	
			
			
		if (	mVerticalPositionType == KTVerticalPositionStickBottom
			||	mHeightType == KTSizeFill
			||	mVerticalPositionType == KTVerticalPositionAbsolute)
		{
			// draw bottom strut enabled
			[[NSColor blackColor] set];
			[wBottomMarginTextField setIntValue:mMarginBottom];
			if(mMarginBottom >= 0)
				[wBottomMarginTextField setTextColor:[NSColor blackColor]];
			else
				[wBottomMarginTextField setTextColor:[NSColor redColor]];
			[wBottomMarginTextField setEnabled:YES];
			[wBottomMarginTextField setEditable:YES];
			[wBottomMarginTextField setSelectable:YES];
			[self drawStrutInRect:mBottomMarginRect flexible:NO];	
		}
		else
		{
			// draw bottom struct disabled
			[[NSColor colorWithDeviceWhite:.6 alpha:1] set];
			[wBottomMarginTextField setStringValue:@"flexible"];
			[wBottomMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:1]];
			[wBottomMarginTextField setEnabled:YES];
			[wBottomMarginTextField setEditable:NO];
			[wBottomMarginTextField setSelectable:NO];
			[self drawStrutInRect:mBottomMarginRect flexible:YES];	
		}
		
		// draw the fill height indicator
		[[NSColor colorWithDeviceRed:62.0/255.0 green:93.0/255.0 blue:154.0/255.0 alpha:1] set];
		NSRect aHeightIndicatorRect = NSMakeRect(NSMidX(mCenterRect)-kStrutMarkerSize*.5, NSMinY(mCenterRect)+2, kStrutMarkerSize, mCenterRect.size.height-4);
		if(mHeightType==KTSizeFill)
			[self drawStrutInRect:aHeightIndicatorRect flexible:YES];
		else
			[self drawStrutInRect:aHeightIndicatorRect flexible:NO];					
		
	}
	else
	{
		// multiple values for vertical layout...what to do?
	}
	
	// draw horizontal layout info
	if(aFoundMultipleValueHPos==NO)
	{
		
		// Left strut
		if(		mHorizontalPositionType == KTHorizontalPositionStickLeft
			||	mWidthType == KTSizeFill 
			||	mHorizontalPositionType == KTHorizontalPositionAbsolute)
		{
			// draw left strut enabled
			
			[[NSColor blackColor] set];
			if(mMarginLeft >= 0)
				[wLeftMarginTextField setTextColor:[NSColor blackColor]];
			else
				[wLeftMarginTextField setTextColor:[NSColor redColor]];
			[wLeftMarginTextField setIntValue:mMarginLeft];
			[wLeftMarginTextField setEnabled:YES];
			[wLeftMarginTextField setEditable:YES];
			[wLeftMarginTextField setSelectable:YES];
			[self drawStrutInRect:mLeftMarginRect flexible:NO];
		}
		else
		{
			// draw left strut disabled
			[[NSColor colorWithDeviceWhite:.6 alpha:1] set];
			[wLeftMarginTextField setStringValue:@"flexible"];
			[wLeftMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:1]];
			[wLeftMarginTextField setEnabled:YES];
			[wLeftMarginTextField setEditable:NO];
			[wLeftMarginTextField setSelectable:NO];
			[self drawStrutInRect:mLeftMarginRect flexible:YES];
		}
		
		// Right strut
		if(		mHorizontalPositionType == KTHorizontalPositionStickRight
			||	mWidthType == KTSizeFill)
		{
			// draw right strut enabled
			[[NSColor blackColor] set];
			[wRightMarginTextField setIntValue:mMarginRight];
			if(mMarginRight >= 0)
				[wRightMarginTextField setTextColor:[NSColor blackColor]];
			else
				[wRightMarginTextField setTextColor:[NSColor redColor]];
			[wRightMarginTextField setEnabled:YES];
			[wRightMarginTextField setEditable:YES];
			[wRightMarginTextField setSelectable:YES];
			[self drawStrutInRect:mRightMarginRect flexible:NO];	
		}
		else
		{
			// draw right strut disabled
			[[NSColor colorWithDeviceWhite:.6 alpha:1] set];
			[wRightMarginTextField setStringValue:@"flexible"];
			[wRightMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:1]];
			[wRightMarginTextField setEnabled:YES];
			[wRightMarginTextField setEditable:NO];
			[wRightMarginTextField setSelectable:NO];
			[self drawStrutInRect:mRightMarginRect flexible:YES];	
		}
		
		
		
		// draw the fill width indicator
		[[NSColor colorWithDeviceRed:62.0/255.0 green:93.0/255.0 blue:154.0/255.0 alpha:1] set];
		NSRect aWidthIndicatorRect = NSMakeRect(NSMinX(mCenterRect)+2, NSMidY(mCenterRect)-kStrutMarkerSize*.5, mCenterRect.size.width-4, kStrutMarkerSize);
		if(mWidthType==KTSizeFill)
			[self drawStrutInRect:aWidthIndicatorRect flexible:YES];
		else
			[self drawStrutInRect:aWidthIndicatorRect flexible:NO];
	}
	else
	{
		// how to draw multiple values??
	}
}

- (void)drawStrutInRect:(NSRect)theRect flexible:(BOOL)theBool
{
	NSBezierPath * aStrutPath = [NSBezierPath bezierPath];
	NSPoint aPoint;
	if(theRect.size.width > theRect.size.height)
	{
		// horizontal orientation
		
		aPoint = NSMakePoint(NSMaxX(theRect), NSMidY(theRect));
		[aStrutPath moveToPoint:aPoint];
		if(theBool)
		{
			// go 1/4 down and stroke
			aPoint = NSMakePoint(aPoint.x-theRect.size.width*.25, aPoint.y);
			[aStrutPath lineToPoint:aPoint];
			[aStrutPath stroke];
			
			// a dashed path
			NSBezierPath * aDashedPath = [NSBezierPath bezierPath];
			[aDashedPath moveToPoint:aPoint];
			float aLineDash[1];
			aLineDash[0] = 2.0;
			[aDashedPath setLineDash:aLineDash count:1 phase:0.0];
			aPoint = NSMakePoint(aPoint.x-theRect.size.width*.5, aPoint.y);
			[aDashedPath lineToPoint:aPoint];
			[aDashedPath stroke];
			
			// regular stroke the rest of the way
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(NSMinX(theRect), NSMidY(theRect));
			[aStrutPath lineToPoint:aPoint];
			[aStrutPath stroke];
			
			// left marker
			aPoint = NSMakePoint(NSMinX(theRect)+kStrutMarkerSize*.5, NSMidY(theRect)-kStrutMarkerSize*.5);
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(NSMinX(theRect), NSMidY(theRect));
			[aStrutPath lineToPoint:aPoint];
			aPoint = NSMakePoint(aPoint.x+kStrutMarkerSize*.5, aPoint.y+kStrutMarkerSize*.5);
			[aStrutPath lineToPoint:aPoint];

			// right marker
			aPoint = NSMakePoint(NSMaxX(theRect)-kStrutMarkerSize*.5, NSMidY(theRect)+kStrutMarkerSize*.5);
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(NSMaxX(theRect), NSMidY(theRect));
			[aStrutPath lineToPoint:aPoint];
			aPoint = NSMakePoint(aPoint.x-kStrutMarkerSize*.5, aPoint.y-kStrutMarkerSize*.5);
			[aStrutPath lineToPoint:aPoint];
			[aStrutPath stroke];
		}
		else
		{
			// bottom middle
			aPoint = NSMakePoint(NSMinX(theRect), NSMidY(theRect));
			[aStrutPath lineToPoint:aPoint];
			
			// left marker
			aPoint = NSMakePoint(NSMinX(theRect), NSMidY(theRect)-kStrutMarkerSize*.5);
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(aPoint.x, aPoint.y+kStrutMarkerSize);
			[aStrutPath lineToPoint:aPoint];

			// bottom marker
			aPoint = NSMakePoint(NSMaxX(theRect), NSMidY(theRect)-kStrutMarkerSize*.5);		
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(aPoint.x, aPoint.y+kStrutMarkerSize);	
			[aStrutPath lineToPoint:aPoint];
			[aStrutPath stroke];
		}
	}
	else
	{
		// vertical orientation
		aPoint = NSMakePoint(NSMidX(theRect), NSMaxY(theRect));
		[aStrutPath moveToPoint:aPoint];
		
		if(theBool)
		{
			// go 1/4 down and stroke
			aPoint = NSMakePoint(aPoint.x, aPoint.y-theRect.size.height*.25);
			[aStrutPath lineToPoint:aPoint];
			[aStrutPath stroke];
			
			// a dashed path
			NSBezierPath * aDashedPath = [NSBezierPath bezierPath];
			[aDashedPath moveToPoint:aPoint];
			float aLineDash[1];
			aLineDash[0] = 2.0;
			[aDashedPath setLineDash:aLineDash count:1 phase:0.0];
			aPoint = NSMakePoint(aPoint.x, aPoint.y-theRect.size.height*.5);
			[aDashedPath lineToPoint:aPoint];
			[aDashedPath stroke];
			
			// regular stroke the rest of the way
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(NSMidX(theRect), NSMinY(theRect));
			[aStrutPath lineToPoint:aPoint];
			[aStrutPath stroke];
			
			// top marker
			aPoint = NSMakePoint(NSMidX(theRect)-kStrutMarkerSize*.5, NSMaxY(theRect)-kStrutMarkerSize*.5);
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(NSMidX(theRect), NSMaxY(theRect));
			[aStrutPath lineToPoint:aPoint];
			aPoint = NSMakePoint(NSMidX(theRect)+kStrutMarkerSize*.5, NSMaxY(theRect)-kStrutMarkerSize*.5);
			[aStrutPath lineToPoint:aPoint];

			// bottom marker
			aPoint = NSMakePoint(NSMidX(theRect)-kStrutMarkerSize*.5, NSMinY(theRect)+kStrutMarkerSize*.5);
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(NSMidX(theRect), NSMinY(theRect));
			[aStrutPath lineToPoint:aPoint];
			aPoint = NSMakePoint(NSMidX(theRect)+kStrutMarkerSize*.5, NSMinY(theRect)+kStrutMarkerSize*.5);
			[aStrutPath lineToPoint:aPoint];			
			[aStrutPath stroke];

		}
		else
		{
			// bottom middle
			aPoint = NSMakePoint(NSMidX(theRect), NSMinY(theRect));
			[aStrutPath lineToPoint:aPoint];
			
			// top marker
			aPoint = NSMakePoint(NSMidX(theRect)-kStrutMarkerSize*.5, NSMaxY(theRect));
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(aPoint.x+kStrutMarkerSize, aPoint.y);
			[aStrutPath lineToPoint:aPoint];

			// bottom marker
			aPoint = NSMakePoint(NSMidX(theRect)-kStrutMarkerSize*.5, NSMinY(theRect));
			[aStrutPath moveToPoint:aPoint];
			aPoint = NSMakePoint(aPoint.x+kStrutMarkerSize, aPoint.y);
			[aStrutPath lineToPoint:aPoint];
			[aStrutPath stroke];
		}
	}
}


//=========================================================== 
// - mouseDown:
//=========================================================== 
- (void)mouseDown:(NSEvent*)theEvent
{
	NSPoint aMousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if(NSPointInRect(aMousePoint, mTopMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
		if([anInspectedViewArray count] > 0)
		{
			// two cases will have it enabled
			// 1. absolute top margin (stick top)
			// 2. absolute top and bottom (fill height)
			if(mHeightType==KTSizeFill || mVerticalPositionType==KTVerticalPositionStickTop)
			{
				// in either case we want to clear the top margin
				// clear width type & vertical postion type
				for(id<KTViewLayout> aView in anInspectedViewArray)
				{
					KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
					[aViewLayoutManager setMarginTop:0];
					CGFloat aBottomMargin = [aView frame].origin.y;
					[aViewLayoutManager setMarginBottom:aBottomMargin];
					[aViewLayoutManager setHeightType:KTSizeAbsolute];
					[aViewLayoutManager setVerticalPositionType:KTVerticalPositionStickBottom];
				}
				[self setNeedsDisplay:YES];
				return;
			}
			else
			{
				// otherwise check if a bottom margin is set, we want to fill height
				for(id<KTViewLayout> aView in anInspectedViewArray)
				{
					KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
					[aViewLayoutManager setMarginTop:mMarginTop];
					if(		[aViewLayoutManager verticalPositionType]==KTVerticalPositionStickBottom
						||	[aViewLayoutManager verticalPositionType]==KTVerticalPositionAbsolute)
					{
						CGFloat aTopMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
						CGFloat aBottomMargin = [aView frame].origin.y;
						[aViewLayoutManager setMarginTop:aTopMargin];
						[aViewLayoutManager setMarginBottom:aBottomMargin];
						[aViewLayoutManager setHeightType:KTSizeFill];
					}
					else
					{
						CGFloat aTopMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
						[aViewLayoutManager setMarginTop:aTopMargin];
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionStickTop];
					}
				}
				[self setNeedsDisplay:YES];
				return;
			}
		}
	}
	else if(NSPointInRect(aMousePoint, mBottomMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
		if([anInspectedViewArray count] > 0)
		{
			// two cases will have it enabled
			// 1. absolute top margin (stick top)
			// 2. absolute top and bottom (fill height)
			if(mHeightType==KTSizeFill)
			{
				// if current size type is to fill, need to clear margin bottom & size type
				// set margin to stick top
				for(id<KTViewLayout> aView in anInspectedViewArray)
				{
					KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
					[aViewLayoutManager setMarginBottom:0];
					[aViewLayoutManager setHeightType:KTSizeAbsolute];
					[aViewLayoutManager setVerticalPositionType:KTVerticalPositionStickTop];
				}
				[self setNeedsDisplay:YES];
				return;
			}
			if(mVerticalPositionType == KTVerticalPositionStickTop)
			{
				for(id<KTViewLayout> aView in anInspectedViewArray)
				{
					KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
					CGFloat aTopMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
					CGFloat aBottomMargin = [aView frame].origin.y;
					[aViewLayoutManager setMarginTop:aTopMargin];
					[aViewLayoutManager setMarginBottom:aBottomMargin];
					[aViewLayoutManager setHeightType:KTSizeFill];
				}
				[self setNeedsDisplay:YES];
				return;
			}
		}
	}
	else if(NSPointInRect(aMousePoint, mLeftMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
		if([anInspectedViewArray count] > 0)
		{
			if(	mWidthType == KTSizeFill)
			{
				// the left strut is enabled
				// we can only disable it if the right strut is also enabled
				for(id<KTViewLayout> aView in anInspectedViewArray)
				{
					// clear margin left and size type
					// and set to stick right
					KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
					[aViewLayoutManager setMarginLeft:0];
					[aViewLayoutManager setWidthType:KTSizeAbsolute];
					[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionStickRight];
				}
				[self setNeedsDisplay:YES];
				return;
			}
			else
			{
				// the strut is not enabled
				// we want to enable it
				// if the right strut is enabled
				// we're going to give two margins and fill width
				if(mHorizontalPositionType == KTHorizontalPositionStickRight)
				{
					for(id<KTViewLayout> aView in anInspectedViewArray)
					{
						KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
						CGFloat aRightMargin = [[aView parent] frame].size.width - ([aView frame].origin.x+[aView frame].size.width);
						CGFloat aLeftMargin = [aView frame].origin.x;
						[aViewLayoutManager setMarginRight:aRightMargin];
						[aViewLayoutManager setMarginLeft:aLeftMargin];
						[aViewLayoutManager setWidthType:KTSizeFill];
					}
					[self setNeedsDisplay:YES];
					return;
				}	
			}
		}
	}
	else if(NSPointInRect(aMousePoint, mRightMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
		if([anInspectedViewArray count] > 0)
		{
			// the right struct is disabled
			if(	mWidthType != KTSizeFill)
			{
				// enable it
				
				// if the left strut is enable
				// we want to set both margins and fill width
				for(id<KTViewLayout> aView in anInspectedViewArray)
				{
					KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
					CGFloat aRightMargin = [[aView parent] frame].size.width - ([aView frame].origin.x+[aView frame].size.width);
					CGFloat aLeftMargin = [aView frame].origin.x;
					[aViewLayoutManager setMarginRight:aRightMargin];
					[aViewLayoutManager setMarginLeft:aLeftMargin];
					[aViewLayoutManager setWidthType:KTSizeFill];
				}
				[self setNeedsDisplay:YES];
				return;
			}
			else
			{
				// clear the margin type
				// set back to the default
				for(id<KTViewLayout> aView in anInspectedViewArray)
				{
					KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
					[aViewLayoutManager setMarginRight:0];
					[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionAbsolute];
					[aViewLayoutManager setWidthType:KTSizeAbsolute];
				}	
				[self setNeedsDisplay:YES];
				return;
			}
		}
	}
}


- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (void)becomeFirstResponder
{
	[self setNeedsDisplay:YES];
}



@end
