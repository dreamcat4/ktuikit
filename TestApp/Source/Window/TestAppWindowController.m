//
//  TestAppWindowController.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TestAppWindowController.h"
#import "GradientPickerViewController.h"

@implementation TestAppWindowController
- (void)windowDidLoad
{
	GradientPickerViewController * aGradientPickerController = [GradientPickerViewController viewControllerWithWindowController:self];
	[self addViewController:aGradientPickerController];
	
	id aGradientPickerView = [aGradientPickerController view];
	[aGradientPickerView setFrame:[[[self window]contentView]frame]];
	[aGradientPickerView setAutoresizingMask:(NSViewWidthSizable|NSViewHeightSizable)];
	[[self window] setContentView:aGradientPickerView];
	[[aGradientPickerView viewLayoutManager] refreshLayout];
}	

@end
