//
//  KTViewControl.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTView.h"

@interface KTViewControl : KTView 
{
	BOOL					mIsEnabled;
	id						wTarget;
	SEL						wAction;
}

- (IBAction)setTarget:(id)theTarget;
- (IBAction)setAction:(SEL)theAction;
- (IBAction)setEnabled:(BOOL)theBool;
- (void)performAction;

@end
