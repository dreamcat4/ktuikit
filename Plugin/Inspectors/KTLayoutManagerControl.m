//
//  KTLayoutManagerUI.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTLayoutManagerControl.h"
#import <KTUIKit/KTLayoutManager.h>

#define	kCenterRectSize 100
#define kStrutMarkerSize 10

@interface KTLayoutManagerControl (Private)

- (void)setUpRects;
- (void)drawStrutInRect:(NSRect)theRect flexible:(BOOL)theBool;
- (BOOL)isTopStrutEnabled;
- (BOOL)isBottomStrutEnabled;
- (BOOL)isRightStrutEnabled;
- (BOOL)isLeftStrutEnabled;

@end

@implementation KTLayoutManagerControl

@synthesize delegate = wDelegate;
@synthesize isEnabled = mIsEnabled;

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

#pragma mark Drawing
//=========================================================== 
// - drawInContext:
//=========================================================== 
- (void)drawInContext:(CGContextRef)theContext
{	

	CGFloat anEnabledAlpha = 1.0;
	if(mIsEnabled==NO)
		anEnabledAlpha = .4;
		
	NSRect aViewRect = [self bounds];
	aViewRect.origin.x+=.5;
	aViewRect.origin.y+=.5;
	
	NSArray * anInspectedViewArray = nil;
	if([wDelegate respondsToSelector:@selector(inspectedViews)])
		anInspectedViewArray = [wDelegate inspectedViews];
	
	// center rect
	[[NSColor colorWithDeviceWhite:.6 alpha:1*anEnabledAlpha] set];
	[NSBezierPath strokeRect:mCenterRect];
	[[NSColor colorWithDeviceRed:103.0/255.0 green:154.0/255.0 blue:255.0/255.0 alpha:.4*anEnabledAlpha] set];
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
		
		if(mVerticalPositionType==KTVerticalPositionProportional)
		{
			CGFloat aLeftOverHeight = [[aFirstView parent] frame].size.height - [aFirstView frame].size.height;
			if(aLeftOverHeight==0)
				aLeftOverHeight = 1;
			CGFloat aPercentage = [aFirstView frame].origin.y/aLeftOverHeight;
			[aFirstLayoutManger setVerticalPositionPercentage:aPercentage];
		}
		if(mHorizontalPositionType==KTHorizontalPositionProportional)
		{
			if(NSWidth([[aFirstView parent]frame])!=0)
			{
				CGFloat aLeftOverWidth = NSWidth([[aFirstView parent]frame]) - NSWidth([aFirstView frame]);
				if(aLeftOverWidth==0)
					aLeftOverWidth = 1;
				CGFloat aPercentage = [aFirstView frame].origin.x/aLeftOverWidth;
				[aFirstLayoutManger setHorizontalPositionPercentage:aPercentage];
			}
		}
		
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
	

	if(aFoundMultipleValueVPos==NO)
	{
		// Top Strut
		if(	[self isTopStrutEnabled])
		{	
			// draw top strut enabled
			[wTopMarginTextField setIntValue:mMarginTop];
			if(mMarginTop >= 0)
				[wTopMarginTextField setTextColor:[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha]];
			else
				[wTopMarginTextField setTextColor:[NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:anEnabledAlpha]];
//			[wTopMarginTextField setEditable:YES];
//			[wTopMarginTextField setSelectable:YES];
			[[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mTopMarginRect flexible:NO];	
		}
		else
		{
			// draw top strut disabled
			[wTopMarginTextField setStringValue:@"flexible"];
			[wTopMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha]];
//			[wTopMarginTextField setSelectable:NO];
			[[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mTopMarginRect flexible:YES];	
		}	
			
		
		// Bottom strut
		if ([self isBottomStrutEnabled])
		{
			// draw bottom strut enabled
			[wBottomMarginTextField setIntValue:mMarginBottom];
			if(mMarginBottom >= 0)
				[wBottomMarginTextField setTextColor:[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha]];
			else
				[wBottomMarginTextField setTextColor:[NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:anEnabledAlpha]];
			[wBottomMarginTextField setEnabled:YES];
			[wBottomMarginTextField setEditable:YES];
			[wBottomMarginTextField setSelectable:YES];
			[[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mBottomMarginRect flexible:NO];	
		}
		else
		{
			// draw bottom struct disabled
			[wBottomMarginTextField setStringValue:@"flexible"];
			[wBottomMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha]];
			[wBottomMarginTextField setSelectable:NO];
			[[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mBottomMarginRect flexible:YES];	
		}
		
		// draw the fill height indicator
		[[NSColor colorWithDeviceRed:62.0/255.0 green:93.0/255.0 blue:154.0/255.0 alpha:anEnabledAlpha] set];
		NSRect aHeightIndicatorRect = NSMakeRect(NSMidX(mCenterRect)-kStrutMarkerSize*.5, NSMinY(mCenterRect)+2, kStrutMarkerSize, mCenterRect.size.height-4);
		if([self isTopStrutEnabled] && [self isBottomStrutEnabled])
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
		if([self isLeftStrutEnabled])
		{
			// draw left strut enabled
			if(mMarginLeft >= 0)
				[wLeftMarginTextField setTextColor:[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha]];
			else
				[wLeftMarginTextField setTextColor:[NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:anEnabledAlpha]];
			[wLeftMarginTextField setIntValue:mMarginLeft];
			[wLeftMarginTextField setEditable:YES];
			[wLeftMarginTextField setSelectable:YES];
			[[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mLeftMarginRect flexible:NO];
		}
		else
		{
			// draw left strut disabled
			[wLeftMarginTextField setStringValue:@"flexible"];
			[wLeftMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha]];
			[wLeftMarginTextField setSelectable:NO];
			[[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mLeftMarginRect flexible:YES];
		}
		
		// Right strut
		if([self isRightStrutEnabled])
		{
			// draw right strut enabled
			[wRightMarginTextField setIntValue:mMarginRight];
			if(mMarginRight >= 0)
				[wRightMarginTextField setTextColor:[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha]];
			else
				[wRightMarginTextField setTextColor:[NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:anEnabledAlpha]];
			[wRightMarginTextField setEditable:YES];
			[wRightMarginTextField setSelectable:YES];
			[[NSColor colorWithDeviceWhite:0 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mRightMarginRect flexible:NO];	
		}
		else
		{
			// draw right strut disabled
			[wRightMarginTextField setStringValue:@"flexible"];
			[wRightMarginTextField setTextColor:[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha]];
			[wRightMarginTextField setSelectable:NO];
			[[NSColor colorWithDeviceWhite:.6 alpha:anEnabledAlpha] set];
			[self drawStrutInRect:mRightMarginRect flexible:YES];	
		}
		
		// draw the fill width indicator
		[[NSColor colorWithDeviceRed:62.0/255.0 green:93.0/255.0 blue:154.0/255.0 alpha:anEnabledAlpha] set];
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



#pragma mark Events 
//=========================================================== 
// - mouseDown:
//=========================================================== 
- (void)mouseDown:(NSEvent*)theEvent
{
	if(mIsEnabled==NO)
		return;
		
	NSPoint aMousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	// Top Strut hit
	if(NSPointInRect(aMousePoint, mTopMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
		if([anInspectedViewArray count] > 0)
		{
			for(id<KTViewLayout> aView in anInspectedViewArray)
			{
				KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];

				// check if it's enabled
			
				// enabled
				if([self isTopStrutEnabled])
				{
					// if the bottom isn't set - we'll put it in proportional mode
					if(mVerticalPositionType==KTVerticalPositionStickTop)
					{
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionProportional];
						if(NSHeight([[aView parent]frame])!=0)
						{
							CGFloat aLeftOverHeight = [[aView parent] frame].size.height - [aView frame].size.height;
							if(aLeftOverHeight==0)
								aLeftOverHeight = 1;
							CGFloat aPercentage = [aView frame].origin.y/aLeftOverHeight;
							[aViewLayoutManager setVerticalPositionPercentage:aPercentage];
						}
					}
					else // bottom is set, so set it to 'stick' to the bottom margin
					{
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionStickBottom];
						[aViewLayoutManager setMarginTop:0];
						CGFloat aBottomMargin = [aView frame].origin.y;
						[aViewLayoutManager setMarginBottom:aBottomMargin];
						[aViewLayoutManager setHeightType:KTSizeAbsolute];
					}
				}
				else // disabled 
				{						
					// if the bottom strut is enabled, set view to maintain margins and fill its height
					if(	[self isBottomStrutEnabled])
					{
						CGFloat aTopMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
						CGFloat aBottomMargin = [aView frame].origin.y;
						[aViewLayoutManager setMarginTop:aTopMargin];
						[aViewLayoutManager setMarginBottom:aBottomMargin];
						[aViewLayoutManager setHeightType:KTSizeFill];
					}
					else // otherwise, set it to stick to the top margin
					{
						CGFloat aTopMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
						[aViewLayoutManager setMarginTop:aTopMargin];
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionStickTop];
					}
				}
			}
			[self setNeedsDisplay:YES];
			return;
		}
	}
	// Bottom strut hit
	else if(NSPointInRect(aMousePoint, mBottomMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
			
		if([anInspectedViewArray count] > 0)
		{
			for(id<KTViewLayout> aView in anInspectedViewArray)
			{
				KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
				
				// check if the strut is enabled
				if([self isBottomStrutEnabled])
				{
					// disable the bottom strut
					
					// if the top strut is enabled, set the view to stick to the top margin
					if([self isTopStrutEnabled])
					{
						CGFloat aTopMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
						[aViewLayoutManager setMarginTop:aTopMargin];
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionStickTop];
						[aViewLayoutManager setMarginBottom:0];
						[aViewLayoutManager setHeightType:KTSizeAbsolute];
					}
					else //otherwise we'll set both margins flexible
					{
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionProportional];
						if(NSHeight([[aView parent]frame])!=0)
						{
							CGFloat aLeftOverHeight = [[aView parent] frame].size.height - [aView frame].size.height;
							if(aLeftOverHeight==0)
								aLeftOverHeight = 1;
							CGFloat aPercentage = [aView frame].origin.y/aLeftOverHeight;
							[aViewLayoutManager setVerticalPositionPercentage:aPercentage];
						}
					}
				}
				else // bottom strut is disabled
				{
					// enable it
					
					// if the top strut is enabled
					if([self isTopStrutEnabled])
					{
						// set both margins and fill height
						CGFloat aTopMargin = [[aView parent] frame].size.height - ([aView frame].origin.y+[aView frame].size.height);
						CGFloat aBottomMargin = [aView frame].origin.y;
						[aViewLayoutManager setMarginTop:aTopMargin];
						[aViewLayoutManager setMarginBottom:aBottomMargin];
						[aViewLayoutManager setHeightType:KTSizeFill];
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionAbsolute];
					}
					else // set bottom margin and reset the height type 
					{
						CGFloat aBottomMargin = [aView frame].origin.y;
						[aViewLayoutManager setMarginBottom:aBottomMargin];
						[aViewLayoutManager setVerticalPositionType:KTVerticalPositionStickBottom];
						[aViewLayoutManager setHeightType:KTSizeAbsolute];
					}
				}
			}
			[self setNeedsDisplay:YES];
			return;
		}
		
	}
	// Left strut hit
	else if(NSPointInRect(aMousePoint, mLeftMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
			
		if([anInspectedViewArray count] > 0)
		{
			for(id<KTViewLayout> aView in anInspectedViewArray)
			{
				KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
				
				// Left strut is enabled
				if([self isLeftStrutEnabled])
				{
					// disable it
					if([self isRightStrutEnabled])
					{
						// if the right strut is enabled
						// set view to stick to the right margin
						[aViewLayoutManager setMarginLeft:0];
						[aViewLayoutManager setWidthType:KTSizeAbsolute];
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionStickRight];
					}
					else
					{
						// set both margins to be flexible
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionProportional];
						if(NSWidth([[aView parent]frame])!=0)
						{
							CGFloat aLeftOverWidth = NSWidth([[aView parent]frame]) - NSWidth([aView frame]);
							if(aLeftOverWidth==0)
								aLeftOverWidth = 1;
							CGFloat aPercentage = [aView frame].origin.x/aLeftOverWidth;
							[aViewLayoutManager setHorizontalPositionPercentage:aPercentage];
							[aViewLayoutManager setWidthType:KTSizeAbsolute];
						}
					}
				}
				else // left strut isn't enabled
				{
					// enable it
					
					// if right strut is enabled
					if([self isRightStrutEnabled])
					{
						// set view left & right margins and fill width
						KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];
						CGFloat aRightMargin = [[aView parent] frame].size.width - ([aView frame].origin.x+[aView frame].size.width);
						CGFloat aLeftMargin = [aView frame].origin.x;
						[aViewLayoutManager setMarginRight:aRightMargin];
						[aViewLayoutManager setMarginLeft:aLeftMargin];
						[aViewLayoutManager setWidthType:KTSizeFill];
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionAbsolute];
					}
					else
					{
						// just the left strut enabled
						// set view to stick to the left
						CGFloat aLeftMargin = [aView frame].origin.x;
						[aViewLayoutManager setMarginLeft:aLeftMargin];
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionStickLeft];
						[aViewLayoutManager setWidthType:KTSizeAbsolute];
					}	
				}
			}
			[self setNeedsDisplay:YES];
			return;
		}
	}
	// Right strut hit
	else if(NSPointInRect(aMousePoint, mRightMarginRect))
	{
		NSArray *	anInspectedViewArray = nil;
		if([wDelegate respondsToSelector:@selector(inspectedViews)])
			anInspectedViewArray = [wDelegate inspectedViews];
		if([anInspectedViewArray count] > 0)
		{
			for(id<KTViewLayout> aView in anInspectedViewArray)
			{
				KTLayoutManager * aViewLayoutManager = [aView viewLayoutManager];

				// the right struct is enabled
				if([self isRightStrutEnabled])
				{
					// disable it
					
					if([self isLeftStrutEnabled])
					{
						// if the left strut is enabled
						// set to stick left
						CGFloat aLeftMargin = [aView frame].origin.x;
						[aViewLayoutManager setMarginLeft:aLeftMargin];
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionStickLeft];
						[aViewLayoutManager setWidthType:KTSizeAbsolute];
					}
					else
					{
						// set margins flexible
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionProportional];
						if(NSWidth([[aView parent]frame])!=0)
						{
							CGFloat aLeftOverWidth = NSWidth([[aView parent]frame]) - NSWidth([aView frame]);
							if(aLeftOverWidth==0)
								aLeftOverWidth = 1;
							CGFloat aPercentage = [aView frame].origin.x/aLeftOverWidth;
							[aViewLayoutManager setHorizontalPositionPercentage:aPercentage];
							[aViewLayoutManager setWidthType:KTSizeAbsolute];
						}
					}
				}
				// the right strut is disabled
				else
				{
					// enable it
					if([self isLeftStrutEnabled])
					{
						// if the left strut is also enabled, fill width
						CGFloat aRightMargin = [[aView parent] frame].size.width - ([aView frame].origin.x+[aView frame].size.width);
						CGFloat aLeftMargin = [aView frame].origin.x;
						[aViewLayoutManager setMarginRight:aRightMargin];
						[aViewLayoutManager setMarginLeft:aLeftMargin];
						[aViewLayoutManager setWidthType:KTSizeFill];
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionAbsolute];
					}
					else
					{	
						// stick to the right
						CGFloat aRightMargin = [[aView parent] frame].size.width - ([aView frame].origin.x+[aView frame].size.width);
						[aViewLayoutManager setMarginRight:aRightMargin];
						[aViewLayoutManager setHorizontalPositionType:KTHorizontalPositionStickRight];
						[aViewLayoutManager setWidthType:KTSizeAbsolute];
					}
				}
			}
		}
		[self setNeedsDisplay:YES];
		return;
	}
}

//=========================================================== 
// - acceptsFirstResponder
//=========================================================== 
- (BOOL)acceptsFirstResponder
{
	return YES;
}

//=========================================================== 
// - becomeFirstResponder
//=========================================================== 
- (void)becomeFirstResponder
{
	[self setNeedsDisplay:YES];
}



- (IBAction)setTopMargin:(id)theSender
{
	NSArray *	anInspectedViewArray = nil;
	if([wDelegate respondsToSelector:@selector(inspectedViews)])
		anInspectedViewArray = [wDelegate inspectedViews];
	if([anInspectedViewArray count] > 0)
	{
		for(id<KTViewLayout> aView in anInspectedViewArray)
		{
			[[aView viewLayoutManager] setMarginTop:[theSender floatValue]];
		}
	}
}

- (IBAction)setRightMargin:(id)theSender
{}

- (IBAction)setBottomMargin:(id)theSender
{}

-(IBAction)setLeftMargin:(id)theSender
{}

#pragma mark -
#pragma mark Private
//=========================================================== 
// - isTopStrutEnabled
//=========================================================== 
- (BOOL)isTopStrutEnabled
{
	BOOL aReturnValue = NO;
	if(		mHeightType == KTSizeFill
		||	mVerticalPositionType == KTVerticalPositionStickTop)
			aReturnValue = YES;

	return aReturnValue;
}

//=========================================================== 
// - isBottomStrutEnabled
//=========================================================== 
- (BOOL)isBottomStrutEnabled
{
	BOOL aReturnValue = NO;
	if(		mHeightType == KTSizeFill
		||	mVerticalPositionType == KTVerticalPositionStickBottom
		||	(	mVerticalPositionType == KTVerticalPositionAbsolute
			&&	mHeightType != KTSizeFill) )
		aReturnValue = YES;

	return aReturnValue;
}

//=========================================================== 
// - isRightStrutEnabled
//=========================================================== 
- (BOOL)isRightStrutEnabled
{
	BOOL aReturnValue = NO;
	if(		mWidthType == KTSizeFill
		||	mHorizontalPositionType == KTHorizontalPositionStickRight)
		aReturnValue = YES;
	
	return aReturnValue;
}

//=========================================================== 
// - isLeftStrutEnabled
//=========================================================== 
- (BOOL)isLeftStrutEnabled
{
	BOOL aReturnValue = NO;
	if(		mWidthType == KTSizeFill
		||	mHorizontalPositionType == KTHorizontalPositionStickLeft
		||	(	mHorizontalPositionType == KTHorizontalPositionAbsolute
			&&	mWidthType != KTSizeFill) )
		aReturnValue = YES;
		
	return aReturnValue;
}

//=========================================================== 
// - drawStrutInRect:
//=========================================================== 
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
//		[wRightMarginTextField setFocusRingType:NSFocusRingTypeNone];
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
//		[wBottomMarginTextField setFocusRingType:NSFocusRingTypeNone];
		[self addSubview:wBottomMarginTextField];
		[wBottomMarginTextField release];
	}
	if(wTopMarginTextField==nil)
	{
		wTopMarginTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(mTopMarginRect.origin.x+mTopMarginRect.size.width+.5, mTopMarginRect.origin.y+mTopMarginRect.size.height*.5-8, 60, 16)];
		[wTopMarginTextField setFormatter:[[[NSNumberFormatter alloc] init] autorelease]];
		[wTopMarginTextField setAlignment:NSLeftTextAlignment];
		[wTopMarginTextField setBordered:NO];
		[wTopMarginTextField setBezeled:NO];
		[wTopMarginTextField setDrawsBackground:NO];
//		[wTopMarginTextField setFocusRingType:NSFocusRingTypeNone];
		[wTopMarginTextField setTarget:self];
		[wTopMarginTextField setAction:@selector(setTopMargin:)];
		[wTopMarginTextField setEditable:YES];
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
//		[wLeftMarginTextField setFocusRingType:NSFocusRingTypeNone];
		[self addSubview:wLeftMarginTextField];
		[wLeftMarginTextField release];
	}
	
}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
	NSLog(@"hmmm...");
}

@end
