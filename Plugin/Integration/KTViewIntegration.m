//
//  KTViewIntegration.m
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

// Import your framework view and your inspector 
 #import <KTUIKitFramework/KTView.h>
 #import "KTViewInspector.h"

@implementation KTView ( KTView )
//=========================================================== 
// - ibPopulateKeyPaths:
//=========================================================== 
- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths 
{
    [super ibPopulateKeyPaths:keyPaths];
	// Remove the comments and replace "MyFirstProperty" and "MySecondProperty" 
	// in the following line with a list of your view's KVC-compliant properties.
    [[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects:/* @"MyFirstProperty", @"MySecondProperty",*/ nil]];
}

//=========================================================== 
// - ibPopulateAttributeInspectorClasses:
//=========================================================== 
- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes 
{
    [super ibPopulateAttributeInspectorClasses:classes];
    [classes addObject:[KTViewInspector class]];
}

//=========================================================== 
// - drawRect:
//=========================================================== 
- (void)drawRect:(NSRect)theRect
{
	if([self backgroundColor] == [NSColor clearColor])
		[[NSColor colorWithDeviceWhite:.7 alpha:.5]set];
	else
		[[self backgroundColor] set];
	[NSBezierPath fillRect:[self bounds]];
	if([[self superview]class] == [KTView class])
	{
		[[NSColor whiteColor] set];
		[NSBezierPath setDefaultLineWidth:3];
		[NSBezierPath strokeRect:[self bounds]];
	}
}

//=========================================================== 
// - ibDesignableContentView
//=========================================================== 
- (NSView*)ibDesignableContentView
{
	return self;
}
@end
