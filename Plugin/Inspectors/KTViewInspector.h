//
//  KTViewInspector.h
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

@interface KTViewInspector : IBInspector 
{
	IBOutlet NSTextField *		oLabel;
	
	// Frame
	IBOutlet NSTextField *		oXPosition;
	IBOutlet NSTextField *		oYPosition;
	IBOutlet NSTextField *		oWidth;
	IBOutlet NSTextField *		oHeight;
	IBOutlet NSTextField *		oTopMargin;
	IBOutlet NSTextField *		oBottomMargin;
	IBOutlet NSTextField *		oLeftMargin;
	IBOutlet NSTextField *		oRightMargin;
	
	// Autoresizing
	IBOutlet NSPopUpButton *	oHPosType;
	IBOutlet NSPopUpButton *	oVPosType;
	
	// Styles
	IBOutlet NSColorWell *		oBackgroundColor;
	
	int							mHorizontalSelection;
	int							mVerticalSelection;
}

- (void)setHorizontalSelection:(int)theTag;
- (void)setVerticalSelection:(int)theTag;

- (IBAction)setLabel:(id)theSender;

- (IBAction)setXPosition:(id)theSender;
- (IBAction)setYPosition:(id)theSender;
- (IBAction)setWidth:(id)theSender;
- (IBAction)setHeight:(id)theSender;
//- (IBAction)setTopMargin:(id)theSender;
//- (IBAction)setRightMargin:(id)theSender;
//- (IBAction)setBottomMargin:(id)theSender;
//- (IBAction)setLeftMargin:(id)theSender;
//
//- (IBAction)setWidthType:(id)theSender;
//- (IBAction)setWidthPercentage:(id)theSender;
//- (IBAction)setHeightType:(id)theSender;
//- (IBAction)setHeightPercentage:(id)theSender;
- (IBAction)setHPosType:(id)theSender;
- (IBAction)setVPosType:(id)theSender;

- (IBAction)setBackgroundColor:(id)theSender;

@end
