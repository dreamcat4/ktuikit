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
 #import "KTLayoutManagerInspector.h"
// #import "KTViewInspector.h"
 #import "KTStyleInspector.h"
 #import "KTGradientPicker.h"
@implementation KTView ( KTViewIntegration )
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
	if([self isKindOfClass:[KTGradientPicker class]]==NO)
		[classes addObject:[KTStyleInspector class]];
    [classes addObject:[KTLayoutManagerInspector class]];
}

//=========================================================== 
// - drawInContext:
//=========================================================== 
- (void)drawInContext:(CGContextRef)theContext
{
	if(		[[self styleManager] backgroundColor] == [NSColor clearColor] 
		&&	[[self styleManager] backgroundGradient] == nil)
	{
		[[NSColor colorWithDeviceRed:103.0/255.0 green:154.0/255.0 blue:255.0/255.0 alpha:.4] set];
		[NSBezierPath fillRect:[self bounds]];
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
