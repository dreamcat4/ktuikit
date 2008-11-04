//
//  KTStyleInspector.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

@class KTGradientPicker;

@interface KTStyleInspector : IBInspector 
{
	// Background
	IBOutlet NSButton *				oDrawBackgroundCheckBox;
	IBOutlet NSMatrix *				oBackgroundOptionsRadioButton;
	IBOutlet NSColorWell *			oBackgroundColorWell;
	IBOutlet KTGradientPicker *		oBackgroundGradientPicker;
	
	// Borders
	IBOutlet NSButton *				oDrawBordersCheckBox;
	IBOutlet NSPopUpButton *		oTargetBorderPopUpButton;
	IBOutlet NSTextField *			oBorderWithTextField;
	IBOutlet NSStepper *			oBorderWidthStepper;
	IBOutlet NSColorWell *			oBorderColorWell;
}

- (IBAction)setDrawsBackground:(id)theSender;
- (IBAction)setBackgroundColor:(id)theSender;
- (IBAction)setBackgroundGradient:(id)theSender;

- (IBAction)setDrawsBorders:(id)theSender;
- (IBAction)setBorderWidth:(id)theSender;
- (IBAction)setBorderColor:(id)theSender;

@end
