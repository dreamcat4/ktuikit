//
//  TestAppController.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TestAppController.h"
#import "TestAppWindowController.h"

@implementation TestAppController
- (void)awakeFromNib
{
	mWindowController = [[TestAppWindowController alloc] initWithWindowNibName:@"TestAppWindow"];
	[[mWindowController window] center];
}

- (void)dealloc
{
	[mWindowController release];
	[super dealloc];
}
@end
