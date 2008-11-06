//
//  TestAppController.m
//  BoxworkGUI
//
//  Created by Cathy Shive on 10/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TestAppController.h"
#import "TestWindowController.h"

@implementation TestAppController
- (void)awakeFromNib
{
	// Make Test Window Controller
	mTestWindowController = [[TestWindowController alloc] initWithWindowNibName:@"TestWindow"];
	[[mTestWindowController window] center];
}

- (void)dealloc
{
	[mTestWindowController release];
	[super dealloc];
}

@end
