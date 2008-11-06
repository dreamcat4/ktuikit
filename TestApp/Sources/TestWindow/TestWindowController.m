//
//  TestWindowController.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TestWindowController.h"
#import <KTUIKitFramework/KTUIKit.h>
#import "KTUIKitFramework/KTGradientPicker.h"

@implementation TestWindowController
- (void)windowDidLoad
{
	KTView * aTestWindowContentView = [[[KTView alloc] initWithFrame:[[self window] frame]] autorelease];
	[aTestWindowContentView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[[self window] setContentView:aTestWindowContentView];
	KTGradientPicker * aGradientPicker = [[[KTGradientPicker alloc] initWithFrame:NSMakeRect(0, 0, 200, 40)]autorelease];
	[[aGradientPicker viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionKeepCentered];
	[aGradientPicker setTarget:self];
	[aGradientPicker setAction:@selector(setGradientForTestView:)];
	[[[self window] contentView] addSubview:aGradientPicker];
	
	
	wTestView = [[[KTView alloc] initWithFrame:NSZeroRect] autorelease];
	[[wTestView viewLayoutManager] setWidthType:KTSizeFill];
	[[wTestView viewLayoutManager] setHeightType:KTSizeFill];
	[[wTestView viewLayoutManager] setMarginBottom:50];
	[[wTestView styleManager] setBackgroundColor:[NSColor colorWithDeviceWhite:.5 alpha:1]];
	[[[self window] contentView] addSubview:wTestView];
	
	[[[[self window] contentView] viewLayoutManager] refreshLayout];
}

- (void)setGradientForTestView:(id)theSender
{
	[[wTestView styleManager] setBackgroundGradient:[theSender gradientValue] angle:-90];
	[wTestView setNeedsDisplay:YES];
}


@end
