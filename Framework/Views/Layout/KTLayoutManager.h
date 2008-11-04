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
	KTHorizontalPositionFloatLeft,
	KTHorizontalPositionFloatRight
	
}KTHorizontalPositionType;


typedef enum
{

	KTVerticalPositionAbsolute = 0,
	KTVerticalPositionStickTop,
	KTVerticalPositionStickBottom,
	KTVerticalPositionKeepCentered,
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
	
	CGFloat						mWidthPercentage;
	CGFloat						mHeightPercentage;
	
	CGFloat						mMarginLeft;
	CGFloat						mMarginRight;
	CGFloat						mMarginTop;
	CGFloat						mMarginBottom;
	
	CGFloat						mMinWidth;
	CGFloat						mMaxWidth;
	CGFloat						mMinHeight;
	CGFloat						mMaxHeight;
}

@property(readwrite,assign) KTSizeType heightType;
@property(readwrite,assign) KTSizeType widthType;
@property(readwrite,assign) KTHorizontalPositionType horizontalPositionType;
@property(readwrite,assign) KTVerticalPositionType verticalPositionType;
@property(readwrite,assign) CGFloat marginTop;
@property(readwrite,assign) CGFloat marginBottom;
@property(readwrite,assign) CGFloat marginLeft;
@property(readwrite,assign) CGFloat marginRight;
@property(readwrite,assign) CGFloat heightPercentage;
@property(readwrite,assign) CGFloat widthPercentage;
@property(readwrite,assign) CGFloat minWidth;
@property(readwrite,assign) CGFloat maxWidth;
@property(readwrite,assign) CGFloat minHeight;
@property(readwrite,assign) CGFloat maxHeight;
@property(readwrite,assign) id <KTViewLayout> view;

- (id)initWithView:(id<KTViewLayout>)theView;
- (void)setMargin:(float)theMargin;
- (void)setMarginTop:(float)theTopMargin 
			   right:(float)theRightMargin 
			  bottom:(float)theBottomMargin 
				left:(float)theLeftMargin;
				
- (void)refreshLayout;

@end
