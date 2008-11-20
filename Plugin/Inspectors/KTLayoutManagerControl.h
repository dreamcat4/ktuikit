//
//  KTLayoutManagerUI.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KTUIKitFramework/KTViewControl.h>

@protocol KTLayoutManagerControlDelegate
- (NSArray*)inspectedViews;	
@end

@interface KTLayoutManagerControl : KTView 
{
	id							wDelegate;
	
	NSTextField *				wTopMarginTextField;
	NSTextField *				wRightMarginTextField;
	NSTextField *				wBottomMarginTextField;
	NSTextField *				wLeftMarginTextField;
	
	NSRect						mCenterRect;
	NSRect						mTopMarginRect;
	NSRect						mRightMarginRect;
	NSRect						mBottomMarginRect;
	NSRect						mLeftMarginRect;
	NSRect						mCenterHorizontalRect;
	NSRect						mCenterVerticalRect;
	
	CGFloat						mMarginTop;
	CGFloat						mMarginRight;
	CGFloat						mMarginBottom;
	CGFloat						mMarginLeft;
	
	KTHorizontalPositionType	mHorizontalPositionType;
	KTVerticalPositionType		mVerticalPositionType;
	KTSizeType					mWidthType;
	KTSizeType					mHeightType;
}
@property (readwrite,assign) id delegate;

@end
