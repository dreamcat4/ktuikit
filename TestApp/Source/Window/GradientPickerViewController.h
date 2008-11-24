//
//  GradientPickerViewController.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KTUIKitFramework/KTUIKit.h>

@interface GradientPickerViewController : XSViewController 
{
	IBOutlet KTGradientPicker *			oGradientPicker;
	IBOutlet KTView *					oGradientView;
}

- (IBAction)setViewGradientValue:(id)theSender;
@end
