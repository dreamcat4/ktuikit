//
//  KTViewControl.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTViewControl.h"

@interface KTViewControl (Private)
@end

@implementation KTViewControl
//=========================================================== 
// - initWithFrame:
//=========================================================== 
- (id)initWithFrame:(NSRect)theFrame
{
	if(![super initWithFrame:theFrame])
		return nil;
	mIsEnabled = YES;	
	return self;
}

//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
	if (![super initWithCoder:theCoder])
		return nil;

	mIsEnabled = YES;
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{	
	[super encodeWithCoder:theCoder];
}

//=========================================================== 
// - setTarget:
//=========================================================== 
- (IBAction)setTarget:(id)theTarget
{
	wTarget = theTarget;
}

//=========================================================== 
// - setAction:
//=========================================================== 
- (IBAction)setAction:(SEL)theAction
{
	wAction = theAction;
}

//=========================================================== 
// - performAction:
//=========================================================== 
- (void)performAction
{
	if([wTarget respondsToSelector:wAction])
		[wTarget performSelector:wAction withObject:self];
}

//=========================================================== 
// - setEnabled:
//=========================================================== 
- (IBAction)setEnabled:(BOOL)theBool
{
	mIsEnabled = theBool;
}
@end
