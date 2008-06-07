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
#define kKTLayoutManagerHorizontalPositionTypeKey @"hosPosition"
#define kKTLayoutManagerVerticalPositionTypeKey @"vertPosition"

//To Do: finish these constants

@implementation KTLayoutManager

- (id)initWithView:(id<KTViewLayout>)theView
{
	if(![super init])
		return nil;
	wView = theView;
	mMarginTop = mMarginRight = mMarginBottom = mMarginLeft = 0;
	mMaxWidth = mMinWidth = mMaxHeight = mMinHeight = 0;
	mWidthPercentage = mHeightPercentage = 1;
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{	
	[theCoder encodeInt:mWidthType forKey:kKTLayoutManagerWidthTypeKey];
	[theCoder encodeInt:mHeightType forKey:kKTLayoutManagerHeightTypeKey];
	[theCoder encodeInt:mHorizontalPositionType forKey:kKTLayoutManagerHorizontalPositionTypeKey];
	[theCoder encodeInt:mVerticalPositionType forKey:kKTLayoutManagerVerticalPositionTypeKey];
	[theCoder encodeFloat:mMarginTop forKey:@"sMarginTop"];
	[theCoder encodeFloat:mMarginRight forKey:@"sMarginRight"];
	[theCoder encodeFloat:mMarginBottom forKey:@"sMarginBottom"];
	[theCoder encodeFloat:mMarginLeft forKey:@"sMarginLeft"];
	[theCoder encodeFloat:mWidthPercentage forKey:@"sWidthPercentage"];
	[theCoder encodeFloat:mHeightPercentage forKey:@"sHeightPercentage"];
	[theCoder encodeFloat:mMinWidth forKey:@"sMinWidth"];
	[theCoder encodeFloat:mMaxWidth forKey:@"sMaxWidth"];
	[theCoder encodeFloat:mMinHeight forKey:@"sMinHeight"];
	[theCoder encodeFloat:mMaxHeight forKey:@"sMaxHeight"];

}

//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
	if (![super init])
		return nil;
		
	[self setWidthType:[theCoder decodeIntForKey:kKTLayoutManagerWidthTypeKey]];
	[self setHeightType:[theCoder decodeIntForKey:kKTLayoutManagerHeightTypeKey]];
	[self setHorizontalPositionType:[theCoder decodeIntForKey:kKTLayoutManagerHorizontalPositionTypeKey]];
	[self setVerticalPositionType:[theCoder decodeIntForKey:kKTLayoutManagerVerticalPositionTypeKey]];
	[self setMarginTop:[theCoder decodeFloatForKey:@"sMarginTop"]];
	[self setMarginRight:[theCoder decodeFloatForKey:@"sMarginRight"]];
	[self setMarginBottom:[theCoder decodeFloatForKey:@"sMarginBottom"]];
	[self setMarginLeft:[theCoder decodeFloatForKey:@"sMarginLeft"]];
	[self setWidthPercentage:[theCoder decodeFloatForKey:@"sWidthPercentage"]];
	[self setHeightPercentage:[theCoder decodeFloatForKey:@"sHeightPercentage"]];
	[self setMinWidth:[theCoder decodeFloatForKey:@"sMinWidth"]];
	[self setMaxWidth:[theCoder decodeFloatForKey:@"sMaxWidth"]];
	[self setMinHeight:[theCoder decodeFloatForKey:@"sMinHeight"]];
	[self setMaxHeight:[theCoder decodeFloatForKey:@"sMaxHeight"]];
	
	return self;
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
			aCurrentViewFrame.size.width = aSuperviewFrame.size.width - (mMarginLeft + mMarginRight);
		break;
		
		case KTSizePercentage:
			aCurrentViewFrame.size.width = aSuperviewFrame.size.width*mWidthPercentage - (mMarginLeft + mMarginRight);
		break;
	}
	
	// clip width
	if(mMaxWidth > 0)
	{
		if(aCurrentViewFrame.size.width > mMaxWidth)
			aCurrentViewFrame.size.width = mMaxWidth;
	}
	if(mMinWidth > 0)
	{
		if(aCurrentViewFrame.size.width < mMinWidth)
			aCurrentViewFrame.size.width = mMinWidth;
	}
	
	//----------------------------------------------------------------------------------------
	// HEIGHT
	//----------------------------------------------------------------------------------------
	switch(mHeightType)
	{
		case KTSizeFill:
			aCurrentViewFrame.size.height = aSuperviewFrame.size.height - (mMarginTop + mMarginBottom);
		break;
		
		case KTSizePercentage:
			aCurrentViewFrame.size.height = aSuperviewFrame.size.height*mHeightPercentage - (mMarginTop + mMarginBottom);
		break;
	}
	
	// clip height
	if(mMaxHeight > 0)
	{
		if(aCurrentViewFrame.size.height > mMaxHeight)
			aCurrentViewFrame.size.height = mMaxHeight;
	}
	if(mMinHeight > 0)
	{
		if(aCurrentViewFrame.size.height < mMinHeight)
			aCurrentViewFrame.size.height = mMinHeight;
	}
	

	//----------------------------------------------------------------------------------------
	// HORIZONTAL POSITION
	//----------------------------------------------------------------------------------------
	switch(mHorizontalPositionType)
	{
		case KTHorizontalPositionAbsolute:
			if(		mMarginLeft > 0
				&&	aCurrentViewFrame.origin.x < mMarginLeft)
				aCurrentViewFrame.origin.x = mMarginLeft;
		break;
		
		case KTHorizontalPositionKeepCentered:
			aCurrentViewFrame.origin.x = aSuperviewFrame.size.width*.5 - aCurrentViewFrame.size.width*.5;
		break;
		
		case KTHorizontalPositionStickLeft:
			aCurrentViewFrame.origin.x = mMarginLeft;
		break;
		
		case KTHorizontalPositionStickRight:
			aCurrentViewFrame.origin.x = aSuperviewFrame.size.width - aCurrentViewFrame.size.width - mMarginRight;
		break;
		
		case KTHorizontalPositionFloatRight:
		{
			// position ourself at the right of the superview
			aCurrentViewFrame.origin.x = aSuperviewFrame.size.width - aCurrentViewFrame.size.width- mMarginRight;
				
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
						if(		aCurrentViewFrame.origin.y <= aSiblingFrame.origin.y+aSiblingFrame.size.height
							&&	aCurrentViewFrame.origin.y+aCurrentViewFrame.size.height >= aSiblingFrame.origin.y )
						{
							// if the width is being filled, we need to adjust it to account for the sibling's position in the superview
							if(	mWidthType == KTSizeFill)
								aCurrentViewFrame.size.width-=(aSiblingFrame.size.width+[[aSibling viewLayoutManager] marginLeft]+[[aSibling viewLayoutManager] marginRight]);
							
							aCurrentViewFrame.origin.x = aSiblingFrame.origin.x - [[aSibling viewLayoutManager] marginLeft] - mMarginRight - aCurrentViewFrame.size.width;
							
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
						if(		aCurrentViewFrame.origin.y <= aSiblingFrame.origin.y+aSiblingFrame.size.height
							&&	aCurrentViewFrame.origin.y+aCurrentViewFrame.size.height >= aSiblingFrame.origin.y )
						{
							aCurrentViewFrame.origin.x = [aSibling frame].origin.x + [aSibling frame].size.width + [[aSibling viewLayoutManager] marginRight] + mMarginLeft;
							// if the width if being filled, we need to adjust it to account for our position change
							if(mWidthType == KTSizeFill)
								aCurrentViewFrame.size.width-=(aCurrentViewFrame.origin.x - mMarginLeft);
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
				&&	aCurrentViewFrame.origin.y < mMarginBottom)
				aCurrentViewFrame.origin.y = mMarginBottom;
		break;
		
		case KTVerticalPositionKeepCentered:
			aCurrentViewFrame.origin.y = aSuperviewFrame.size.height*.5 - aCurrentViewFrame.size.height*.5;
		break;
		
		case KTVerticalPositionStickTop:
			aCurrentViewFrame.origin.y = aSuperviewFrame.size.height - aCurrentViewFrame.size.height - mMarginTop;
		break;
		
		case KTVerticalPositionStickBottom:
			aCurrentViewFrame.origin.y = mMarginBottom;
		break;
		
		case KTVerticalPositionFloatUp:
		{
			// position ourself at the top of the superview
			aCurrentViewFrame.origin.y = aSuperviewFrame.size.height - aCurrentViewFrame.size.height - mMarginTop;
				
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
						if(		aCurrentViewFrame.origin.x+aCurrentViewFrame.size.width >= aSiblingFrame.origin.x
							&&	aCurrentViewFrame.origin.x <= aSiblingFrame.origin.x+aSiblingFrame.size.width )
						{							
							// if the hieght if being filled, we need to adjust it to account for the sibling's position in the superview
							if(	mHeightType == KTSizeFill)
								aCurrentViewFrame.size.height-=aSuperviewFrame.size.height-aSiblingFrame.origin.y -[[aSibling viewLayoutManager] marginBottom];
								
							aCurrentViewFrame.origin.y = aSiblingFrame.origin.y -[[aSibling viewLayoutManager] marginBottom] - aCurrentViewFrame.size.height - mMarginTop;
							
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
						if(		aCurrentViewFrame.origin.x <= aSiblingFrame.origin.x+aSiblingFrame.size.width
							&&	aCurrentViewFrame.origin.x+aCurrentViewFrame.size.width >= aSiblingFrame.origin.x )
						{
							aCurrentViewFrame.origin.y = [aSibling frame].origin.y +  [aSibling frame].size.height + mMarginBottom;
							// if the hieght if being filled, we need to adjust it to account for our position change
							if(	mHeightType == KTSizeFill)
								aCurrentViewFrame.size.height-=aCurrentViewFrame.origin.y;
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
#pragma mark CONFIGURATION
#pragma mark  

#pragma mark Types

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setWidthType:(KTSizeType)theType
{
	mWidthType = theType;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (KTSizeType)widthType
{
	return mWidthType;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setHeightType:(KTSizeType)theType
{
	mHeightType = theType;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (KTSizeType)heightType
{
	return mHeightType;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setHorizontalPositionType:(KTHorizontalPositionType)thePositionType
{
	mHorizontalPositionType = thePositionType;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (KTHorizontalPositionType)horizontalPositionType
{
	return mHorizontalPositionType;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setVerticalPositionType:(KTVerticalPositionType)thePositionType
{
	mVerticalPositionType = thePositionType;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (KTVerticalPositionType)verticalPositionType
{
	return mVerticalPositionType;
}


#pragma mark  
#pragma mark Values
//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMargin:(float)theMargin
{
	mMarginTop = theMargin;
	mMarginRight = theMargin;
	mMarginBottom = theMargin;
	mMarginLeft = theMargin;
}

//=========================================================== 
// - setWidthType:
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

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMarginTop:(float)theMargin
{
	mMarginTop = theMargin;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)marginTop
{
	return mMarginTop;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMarginRight:(float)theMargin
{
	mMarginRight = theMargin;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)marginRight
{
	return mMarginRight;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMarginBottom:(float)theMargin
{
	mMarginBottom = theMargin;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)marginBottom
{
	return mMarginBottom;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMarginLeft:(float)theMargin
{
	mMarginLeft = theMargin;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)marginLeft
{
	return mMarginLeft;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setHeightPercentage:(float)thePercentage
{
	mHeightPercentage = thePercentage;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)heightPercentage
{
	return mHeightPercentage;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setWidthPercentage:(float)thePercentage
{
	mWidthPercentage = thePercentage;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)widthPercentage
{
	return mWidthPercentage;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMinWidth:(float)theWidth
{
	mMinWidth = theWidth;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)minWidth
{
	return mMinWidth;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMaxWidth:(float)theWidth
{
	mMaxWidth = theWidth;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)maxWidth
{
	return mMaxWidth;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMinHeight:(float)theHeight
{
	mMinHeight = theHeight;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)minHeight
{
	return mMinHeight;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (void)setMaxHeight:(float)theHeight
{
	mMaxHeight = theHeight;
}

//=========================================================== 
// - setWidthType:
//=========================================================== 
- (float)maxHeight
{
	return mMaxHeight;
}

@end
