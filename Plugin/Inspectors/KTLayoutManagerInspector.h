//
//  KTViewInspector.h
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

@class KTLayoutManagerControl;

@interface KTLayoutManagerInspector : IBInspector 
{
	IBOutlet NSTextField *		oLabel;
	
	// Frame
	IBOutlet NSTextField *		oXPosition;
	IBOutlet NSTextField *		oYPosition;
	IBOutlet NSTextField *		oWidth;
	IBOutlet NSTextField *		oHeight;

	// Autoresizing
	IBOutlet KTLayoutManagerControl *		oLayoutControl;
}

- (IBAction)setXPosition:(id)theSender;
- (IBAction)setYPosition:(id)theSender;
- (IBAction)setWidth:(id)theSender;
- (IBAction)setHeight:(id)theSender;

- (IBAction)fillCurrentWidth:(id)theSender;
- (IBAction)fillCurrentHeight:(id)theSender;
- (IBAction)setKeepCenteredHorizontally:(id)theSender;
- (IBAction)setKeepCenteredVertically:(id)theSender;

@end
