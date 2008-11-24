//
//  GradientPickerViewController.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GradientPickerViewController.h"


@implementation GradientPickerViewController
+(GradientPickerViewController*)viewControllerWithWindowController:(XSWindowController*)theWindowController
{
	return [[[GradientPickerViewController alloc] initWithNibName:@"GradientPickerTestView" bundle:nil windowController:theWindowController] autorelease];
}

- (void)loadView
{
	[super loadView];
	[[oGradientPicker viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionKeepCentered];
	[self setViewGradientValue:oGradientPicker];
}

- (IBAction)setViewGradientValue:(id)theSender
{
	[[oGradientView styleManager] setBackgroundGradient:[theSender gradientValue] angle:-90];
	[oGradientView setNeedsDisplay:YES];
}

@end
