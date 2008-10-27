//
//  KTLayoutManager.m
//  KTUIKit
//
//  Created by Cathy Shive on 05/20/2008.
//
// Copyright (c) Cathy Shive
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "KTUIKit" by Cathy Shive" will do.

#import "KTLayoutManager.h"

#define kKTLayoutManagerWidthTypeKey @"widthType"
#define kKTLayoutManagerHeightTypeKey @"heightType"
#define kKTLayoutManagerHorizontalPositionTypeKey @"horizontalPositionType"
#define kKTLayoutManagerVerticalPositionTypeKey @"verticalPositionType"
#define kKTLayoutManagerMarginTopKey @"marginTop"
#define kKTLayoutManagerMarginRightKey @"marginRight"
#define kKTLayoutManagerMarginBottomKey @"marginBottom"
#define kKTLayoutManagerMarginLeftKey @"marginLeft"
#define kKTLayoutManagerWidthPercentageKey @"widthPercentage"
#define kKTLayoutManagerHeightPercentageKey @"heightPercentage"
#define kKTLayoutManagerMinWidthKey @"minWidth"
#define kKTLayoutManagerMaxWidthKey @"maxWidth"
#define kKTLayoutManagerMinHeightKey @"minHeight"
#define kKTLayoutManagerMaxHeightKey @"maxHeight"

@interface KTLayoutManager (Private)

- (NSArray*)keysForCoding;

@end

@implementation KTLayoutManager

@synthesize widthType = mWidthType;
@synthesize heightType = mHeightType;
@synthesize horizontalPositionType = mHorizontalPositionType;
@synthesize verticalPositionType = mVerticalPositionType;
@synthesize marginTop = mMarginTop;
@synthesize marginRight = mMarginRight;
@synthesize marginBottom = mMarginBottom;
@synthesize marginLeft = mMarginLeft;
@synthesize widthPercentage = mWidthPercentage;
@synthesize heightPercentage = mHeightPercentage;
@synthesize minWidth = mMinWidth;
@synthesize maxWidth = mMaxWidth;
@synthesize minHeight = mMinHeight;
@synthesize maxHeight = mMaxHeight;
@synthesize view = wView;

//=========================================================== 
// - init
//=========================================================== 
- (id)init
{
	return [self initWithView:nil];
}

//=========================================================== 
// - initWithView:
//=========================================================== 
- (id)initWithView:(id<KTViewLayout>)theView
{
	if(![super init])
		return nil;
	wView = theView;
	mWidthPercentage = mHeightPercentage = 1.0;
	return self;
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
	return [NSArray arrayWithObjects:kKTLayoutManagerWidthTypeKey,kKTLayoutManagerHeightTypeKey,kKTLayoutManagerHorizontalPositionTypeKey,kKTLayoutManagerVerticalPositionTypeKey,kKTLayoutManagerMarginTopKey,kKTLayoutManagerMarginRightKey,kKTLayoutManagerMarginBottomKey,kKTLayoutManagerMarginLeftKey,kKTLayoutManagerWidthPercentageKey,kKTLayoutManagerHeightPercentageKey,kKTLayoutManagerMinWidthKey,kKTLayoutManagerMaxWidthKey,kKTLayoutManagerMinHeightKey,kKTLayoutManagerMaxHeightKey,nil];
}

//=========================================================== 
// - setNilValueForKey:
//=========================================================== 
- (void)setNilValueForKey:(NSString *)key;
{
	if ([key isEqualToString:kKTLayoutManagerWidthTypeKey])
		[self setWidthType:KTSizeAbsolute];
	else if ([key isEqualToString:kKTLayoutManagerHeightTypeKey])
		[self setHeightType:KTSizeAbsolute];
	else if ([key isEqualToString:kKTLayoutManagerHorizontalPositionTypeKey])
		[self setHorizontalPositionType:KTHorizontalPositionAbsolute];
	else if ([key isEqualToString:kKTLayoutManagerVerticalPositionTypeKey])
		[self setVerticalPositionType:KTVerticalPositionAbsolute];
	else if ([key isEqualToString:kKTLayoutManagerMarginTopKey])
		[self setMarginTop:0.0];
	else if ([key isEqualToString:kKTLayoutManagerMarginRightKey])
		[self setMarginRight:0.0];
	else if ([key isEqualToString:kKTLayoutManagerMarginBottomKey])
		[self setMarginBottom:0.0];
	else if ([key isEqualToString:kKTLayoutManagerMarginLeftKey])
		[self setMarginLeft:0.0];
	else if ([key isEqualToString:kKTLayoutManagerWidthPercentageKey])
		[self setWidthPercentage:1.0];
	else if ([key isEqualToString:kKTLayoutManagerHeightPercentageKey])
		[self setHeightPercentage:1.0];
	else if ([key isEqualToString:kKTLayoutManagerMinWidthKey])
		[self setMinWidth:0.0];
	else if ([key isEqualToString:kKTLayoutManagerMaxWidthKey])
		[self setMaxWidth:0.0];
	else if ([key isEqualToString:kKTLayoutManagerMinHeightKey])
		[self setMinHeight:0.0];
	else if ([key isEqualToString:kKTLayoutManagerMaxHeightKey])
		[self setMaxHeight:0.0];
	else
		[super setNilValueForKey:key];
}



//=========================================================== 
// - setView:
//=========================================================== 
- (void)setView:(id<KTViewLayout>)theView
{
	wView = theView;
}


//=========================================================== 
// - refreshLayout
//=========================================================== 
- (void)refreshLayout
{
	NSRect aCurrentViewFrame = [wView frame];
	NSRect aSuperviewFrame = [[wView parent] frame];
	
	//----------------------------------------------------------------------------------------
	// WIDTH
	//----------------------------------------------------------------------------------------
	switch(mWidthType)
	{
		case KTSizeFill:
			aCurrentViewFrame.size.width = NSWidth(aSuperviewFrame) - (mMarginLeft + mMarginRight);
		break;
		
		case KTSizePercentage:
			aCurrentViewFrame.size.width = NSWidth(aSuperviewFrame)*mWidthPercentage - (mMarginLeft + mMarginRight);
		break;
	}
	
	// clip width
	if(mMaxWidth > 0)
	{
		if(NSWidth(aCurrentViewFrame) > mMaxWidth)
			aCurrentViewFrame.size.width = mMaxWidth;
	}
	if(mMinWidth > 0)
	{
		if(NSWidth(aCurrentViewFrame) < mMinWidth)
			aCurrentViewFrame.size.width = mMinWidth;
	}
	
	//----------------------------------------------------------------------------------------
	// HEIGHT
	//----------------------------------------------------------------------------------------
	switch(mHeightType)
	{
		case KTSizeFill:
			aCurrentViewFrame.size.height = NSHeight(aSuperviewFrame) - (mMarginTop + mMarginBottom);
		break;
		
		case KTSizePercentage:
			aCurrentViewFrame.size.height = NSHeight(aSuperviewFrame)*mHeightPercentage - (mMarginTop + mMarginBottom);
		break;
	}
	
	// clip height
	if(mMaxHeight > 0)
	{
		if(NSHeight(aCurrentViewFrame) > mMaxHeight)
			aCurrentViewFrame.size.height = mMaxHeight;
	}
	if(mMinHeight > 0)
	{
		if(NSHeight(aCurrentViewFrame) < mMinHeight)
			aCurrentViewFrame.size.height = mMinHeight;
	}
	

	//----------------------------------------------------------------------------------------
	// HORIZONTAL POSITION
	//----------------------------------------------------------------------------------------
	switch(mHorizontalPositionType)
	{
		case KTHorizontalPositionAbsolute:
			if(		mMarginLeft > 0
				&&	NSMinX(aCurrentViewFrame) < mMarginLeft)
				aCurrentViewFrame.origin.x = mMarginLeft;
		break;
		
		case KTHorizontalPositionKeepCentered:
			aCurrentViewFrame.origin.x = NSWidth(aSuperviewFrame)*.5 - NSWidth(aCurrentViewFrame)*.5;
		break;
		
		case KTHorizontalPositionStickLeft:
			aCurrentViewFrame.origin.x = mMarginLeft;
		break;
		
		case KTHorizontalPositionStickRight:
			aCurrentViewFrame.origin.x = NSWidth(aSuperviewFrame) - NSWidth(aCurrentViewFrame) - mMarginRight;
		break;
		
		case KTHorizontalPositionFloatRight:
		{
			// position ourself at the right of the superview
			aCurrentViewFrame.origin.x = NSWidth(aSuperviewFrame) - NSWidth(aCurrentViewFrame)- mMarginRight;
				
			NSArray * aSiblingList = [[wView parent] children];
			int		  aCurrentViewIndex = [aSiblingList indexOfObject:wView];
			
			// check if we have any sibling views ahead of us
			if(aCurrentViewIndex != 0)
			{
				// we're just interested in the view in the list before 
				// ours that is also floating up and is positioned to the right of us
				// we'll position ourself to the left of it
				int i;
				for(i = aCurrentViewIndex-1; i >= 0; i--)
				{
					id aSibling = [aSiblingList objectAtIndex:i];
					if(		[aSibling conformsToProtocol:@protocol(KTViewLayout)]
						&&	[[aSibling viewLayoutManager] horizontalPositionType] == KTHorizontalPositionFloatRight)
					{
						NSRect aSiblingFrame = [aSibling frame];
						if(		NSMinY(aCurrentViewFrame) <= NSMinY(aSiblingFrame) +NSHeight(aSiblingFrame)
							&&	NSMinY(aCurrentViewFrame) +NSHeight(aCurrentViewFrame) >= NSMinY(aSiblingFrame) )
						{
							// if the width is being filled, we need to adjust it to account for the sibling's position in the superview
							if(	mWidthType == KTSizeFill)
								aCurrentViewFrame.size.width-=(NSWidth(aSiblingFrame)+[[aSibling viewLayoutManager] marginLeft]+[[aSibling viewLayoutManager] marginRight]);
							
							aCurrentViewFrame.origin.x = NSMinX(aSiblingFrame) - [[aSibling viewLayoutManager] marginLeft] - mMarginRight - NSWidth(aCurrentViewFrame);
							
							break;
						}
					}
				}
			}
		}
		break;
		
		case KTHorizontalPositionFloatLeft:
		{
			// position ourself at the left of the superview
			aCurrentViewFrame.origin.x = mMarginLeft;
				
			NSArray * aSiblingList = [[wView parent] children];
			int		  aCurrentViewIndex = [aSiblingList indexOfObject:wView];
			
			// check if we have any sibling views ahead of us
			if(aCurrentViewIndex != 0)
			{
				// we're just interested in the view in the list before 
				// ours that is also floating up, we'll position ourself underneath it
				int i;
				for(i = aCurrentViewIndex-1; i >= 0; i--)
				{
					id aSibling = [aSiblingList objectAtIndex:i];
					if(		[aSibling conformsToProtocol:@protocol(KTViewLayout)]
						&&	[[aSibling viewLayoutManager] horizontalPositionType] == KTHorizontalPositionFloatLeft)
					{
						NSRect aSiblingFrame = [aSibling frame];
						if(		NSMinY(aCurrentViewFrame) <= NSMinY(aSiblingFrame)+NSHeight(aSiblingFrame)
							&&	NSMinY(aCurrentViewFrame)+NSHeight(aCurrentViewFrame) >= NSMinY(aSiblingFrame) )
						{
							aCurrentViewFrame.origin.x = NSMinX([aSibling frame]) + NSWidth([aSibling frame]) + [[aSibling viewLayoutManager] marginRight] + mMarginLeft;
							// if the width if being filled, we need to adjust it to account for our position change
							if(mWidthType == KTSizeFill)
								aCurrentViewFrame.size.width-=(NSMinX(aCurrentViewFrame) - mMarginLeft);
							break;
						}
					}
				}
			}
		}
		break;
		
		default:
		break;

	}
	
	//----------------------------------------------------------------------------------------
	// VERTICAL POSITION
	//----------------------------------------------------------------------------------------
	switch(mVerticalPositionType)
	{
		case KTHorizontalPositionAbsolute:
			if(		mMarginBottom > 0
				&&	NSMinY(aCurrentViewFrame) < mMarginBottom)
				aCurrentViewFrame.origin.y = mMarginBottom;
		break;
		
		case KTVerticalPositionKeepCentered:
			aCurrentViewFrame.origin.y = NSHeight(aSuperviewFrame)*.5 - NSHeight(aCurrentViewFrame)*.5;
		break;
		
		case KTVerticalPositionStickTop:
			aCurrentViewFrame.origin.y = NSHeight(aSuperviewFrame) - NSHeight(aCurrentViewFrame) - mMarginTop;
		break;
		
		case KTVerticalPositionStickBottom:
			aCurrentViewFrame.origin.y = mMarginBottom;
		break;
		
		case KTVerticalPositionFloatUp:
		{
			// position ourself at the top of the superview
			aCurrentViewFrame.origin.y = NSHeight(aSuperviewFrame) - NSHeight(aCurrentViewFrame) - mMarginTop;
				
			NSArray * aSiblingList = [[wView parent] children];
			int		  aCurrentViewIndex = [aSiblingList indexOfObject:wView];
			
			// check if we have any sibling views ahead of us
			if(aCurrentViewIndex != 0)
			{
				// we're just interested in the view in the list before 
				// ours that is also floating up and positioned above us
				// we'll position ourself underneath it
				int i;
				for(i = aCurrentViewIndex-1; i >= 0; i--)
				{
					id aSibling = [aSiblingList objectAtIndex:i];
					if(		[aSibling conformsToProtocol:@protocol(KTViewLayout)]
						&&	[[aSibling viewLayoutManager] verticalPositionType] == KTVerticalPositionFloatUp)
					{
						NSRect aSiblingFrame = [aSibling frame];
						if(		NSMinX(aCurrentViewFrame)+NSWidth(aCurrentViewFrame) >= NSMinX(aSiblingFrame)
							&&	NSMinX(aCurrentViewFrame) <= NSMinX(aSiblingFrame)+NSWidth(aSiblingFrame) )
						{							
							// if the hieght if being filled, we need to adjust it to account for the sibling's position in the superview
							if(	mHeightType == KTSizeFill)
								aCurrentViewFrame.size.height-= NSHeight(aSuperviewFrame)-NSMinY(aSiblingFrame) -[[aSibling viewLayoutManager] marginBottom];
								
							aCurrentViewFrame.origin.y = NSMinY(aSiblingFrame) -[[aSibling viewLayoutManager] marginBottom] - NSHeight(aCurrentViewFrame) - mMarginTop;
							
							break;
						}
					}
				}
			}
		}
		break;
		
		case KTVerticalPositionFloatDown:
		{
			// position ourself at the bottom of the superview
			aCurrentViewFrame.origin.y = mMarginBottom;
				
			NSArray * aSiblingList = [[wView parent] children];
			int		  aCurrentViewIndex = [aSiblingList indexOfObject:wView];
			
			// check if we have any sibling views ahead of us
			if(aCurrentViewIndex != 0)
			{
				// we're just interested in the view in the list before 
				// ours that is also floating up and is positioned below us, we'll position ourself above it
				int i;
				for(i = aCurrentViewIndex-1; i >= 0; i--)
				{
					id aSibling = [aSiblingList objectAtIndex:i];
					if(		[aSibling conformsToProtocol:@protocol(KTViewLayout)]
						&&	[[aSibling viewLayoutManager] verticalPositionType] == KTVerticalPositionFloatDown)
					{
						NSRect aSiblingFrame = [aSibling frame];
						if(		NSMinX(aCurrentViewFrame) <= NSMinX(aSiblingFrame)+NSWidth(aSiblingFrame)
							&&	NSMinX(aCurrentViewFrame)+NSWidth(aCurrentViewFrame) >= NSMinX(aSiblingFrame) )
						{
							aCurrentViewFrame.origin.y = NSMinY([aSibling frame]) +  NSHeight([aSibling frame]) + mMarginBottom;
							// if the hieght if being filled, we need to adjust it to account for our position change
							if(	mHeightType == KTSizeFill)
								aCurrentViewFrame.size.height-=NSMinY(aCurrentViewFrame);
							break;
						}
					}
				}
			}
		}
		break;
		
		default:
		break;
	}
	
	
	//----------------------------------------------------------------------------------------
	// SET THE FRAME
	//----------------------------------------------------------------------------------------	
	[wView setFrame:aCurrentViewFrame];
}

#pragma mark -
#pragma mark EXTRA API FOR CONFIGURATION
//=========================================================== 
// - setMargin:
//=========================================================== 
- (void)setMargin:(float)theMargin
{
	mMarginTop = theMargin;
	mMarginRight = theMargin;
	mMarginBottom = theMargin;
	mMarginLeft = theMargin;
}

//=========================================================== 
// - setMarginTop:right:bottom:left:
//=========================================================== 
- (void)setMarginTop:(float)theTopMargin 
				right:(float)theRightMargin 
				bottom:(float)theBottomMargin 
				left:(float)theLeftMargin
{
	mMarginTop = theTopMargin;
	mMarginRight = theRightMargin;
	mMarginBottom = theBottomMargin;
	mMarginLeft = theLeftMargin;
}



@end
