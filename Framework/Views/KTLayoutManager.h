//
//  KTLayoutManager.h
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

typedef enum
{
	KTSizeAbsolute = 0,
	KTSizeFill,
	KTSizePercentage,

} KTSizeType;


typedef enum
{
	KTHorizontalPositionAbsolute = 0,
	KTHorizontalPositionStickLeft,
	KTHorizontalPositionStickRight,
	KTHorizontalPositionKeepCentered,
	KTHorizontalPositionKeepProportions,
	KTHorizontalPositionFloatLeft,
	KTHorizontalPositionFloatRight
	
}KTHorizontalPositionType;


typedef enum
{

	KTVerticalPositionAbsolute = 0,
	KTVerticalPositionStickTop,
	KTVerticalPositionStickBottom,
	KTVerticalPositionKeepCentered,
	KTVerticalPositionKeepProportions,
	KTVerticalPositionFloatUp,
	KTVerticalPositionFloatDown
	
}KTVerticalPositionType;



#import <Cocoa/Cocoa.h>
#import "KTViewProtocol.h"


@interface KTLayoutManager : NSObject
{
	id<KTViewLayout>			wView;
	
	KTSizeType					mWidthType;
	KTSizeType					mHeightType;
	KTHorizontalPositionType	mHorizontalPositionType;
	KTVerticalPositionType		mVerticalPositionType;
	
	float						mWidthPercentage;
	float						mHeightPercentage;
	
	float						mMarginLeft;
	float						mMarginRight;
	float						mMarginTop;
	float						mMarginBottom;
	
	float						mMinWidth;
	float						mMaxWidth;
	float						mMinHeight;
	float						mMaxHeight;
}

- (id)initWithView:(id<KTViewLayout>)theView;
- (void)setView:(id<KTViewLayout>)theView;

- (void)refreshLayout;

- (void)setWidthType:(KTSizeType)theType;
- (KTSizeType)widthType;
- (void)setHeightType:(KTSizeType)theType;
- (KTSizeType)heightType;
- (void)setHorizontalPositionType:(KTHorizontalPositionType)thePositionType;
- (KTHorizontalPositionType)horizontalPositionType;
- (void)setVerticalPositionType:(KTVerticalPositionType)thePositionType;
- (KTVerticalPositionType)verticalPositionType;

- (void)setMargin:(float)theMargin;
- (void)setMarginTop:(float)theTopMargin 
			   right:(float)theRightMargin 
			  bottom:(float)theBottomMargin 
				left:(float)theLeftMargin;
- (void)setMarginTop:(float)theMargin;
- (float)marginTop;
- (void)setMarginRight:(float)theMargin;
- (float)marginRight;
- (void)setMarginBottom:(float)theMargin;
- (float)marginBottom;
- (void)setMarginLeft:(float)theMargin;
- (float)marginLeft;

- (void)setHeightPercentage:(float)thePercentage;
- (float)heightPercentage;
- (void)setWidthPercentage:(float)thePercentage;
- (float)widthPercentage;
- (void)setMinWidth:(float)theWidth;
- (void)setMaxWidth:(float)theWidth;
- (void)setMinHeight:(float)theHeight;
- (void)setMaxHeight:(float)theHeight;
- (float)minWidth;
- (float)maxWidth;
- (float)minHeight;
- (float)maxHeight;


@end
