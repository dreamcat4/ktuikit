//
//  KTLayoutManagerInspector.m
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTLayoutManagerInspector.h"
#import "KTLayoutManagerControl.h"
#import <KTUIKitFramework/KTLayoutManager.h>
#import <KTUIKitFramework/KTViewLayout.h>

@implementation KTLayoutManagerInspector

- (NSString *)viewNibName 
{
    return @"KTLayoutManagerInspector";
}

+ (BOOL)supportsMultipleObjectInspection
{
	return YES;
}


- (void)refresh 
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	[oLayoutControl setNeedsDisplay:YES];
	
	for(id<KTViewLayout> anInspectedView in anInspectedObjectsList)
	{
		id <KTViewLayout>		anInspectedView = [anInspectedObjectsList objectAtIndex:0];
		NSRect					aViewFrame = [anInspectedView frame];
								
		// FRAME
		[oWidth setFloatValue:aViewFrame.size.width];
		[oHeight setFloatValue:aViewFrame.size.height];
		[oXPosition setFloatValue:aViewFrame.origin.x];
		[oYPosition setFloatValue:aViewFrame.origin.y];
		
		if(		[anInspectedView parent]!=nil
			&&	[[anInspectedView parent] isKindOfClass:[NSSplitView class]]==NO)
		{
			[oWidth setEnabled:YES];
			[oHeight setEnabled:YES];
			[oXPosition setEnabled:YES];
			[oYPosition setEnabled:YES];
			[oLayoutControl setIsEnabled:YES];
		}
		else
		{
			[oWidth setEnabled:NO];
			[oHeight setEnabled:NO];
			[oXPosition setEnabled:NO];
			[oYPosition setEnabled:NO];
			[oLayoutControl setIsEnabled:NO];
		}
	}
	[super refresh];
}


#pragma mark -
#pragma mark KTView Configuration

- (IBAction)setXPosition:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.origin.x = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}
- (IBAction)setYPosition:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.origin.y = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}

- (IBAction)setWidth:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.size.width = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}

- (IBAction)setHeight:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.size.height = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}

- (IBAction)fillCurrentWidth:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aNewFrame = [anInspectedView frame];
		aNewFrame.origin.x = 0;
		aNewFrame.size.width = NSWidth([[anInspectedView parent]frame]);
		[anInspectedView setFrame:aNewFrame];
	}
}

- (IBAction)fillCurrentHeight:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aNewFrame = [anInspectedView frame];
		aNewFrame.origin.y = 0;
		aNewFrame.size.height = NSHeight([[anInspectedView parent]frame]);
		[anInspectedView setFrame:aNewFrame];
	}
}

- (IBAction)setKeepCenteredHorizontally:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionKeepCentered];
		[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
		[[[anInspectedView parent] viewLayoutManager] refreshLayout];
	}
}

- (IBAction)setKeepCenteredVertically:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		[[anInspectedView viewLayoutManager] setVerticalPositionType:KTHorizontalPositionKeepCentered];
		[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
		[[[anInspectedView parent] viewLayoutManager] refreshLayout];
	}
}


- (BOOL)control:(NSControl *)theControl textView:(NSTextView *)theTextView  doCommandBySelector:(SEL)theCommandSelector
{
	if(theCommandSelector==@selector(moveUp:))
	{
		for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
		{
			NSRect aCurrentViewFrame = [anInspectedView frame];
			if(theControl==oXPosition)
				aCurrentViewFrame.origin.x++;
			else if(theControl==oYPosition)
				aCurrentViewFrame.origin.y++;
			else if(theControl==oWidth)
				aCurrentViewFrame.size.width++;
			else if(theControl==oHeight)
				aCurrentViewFrame.size.height++;
			[anInspectedView setFrame:aCurrentViewFrame];
		}
		return YES;
	}
	else if(theCommandSelector==@selector(moveDown:))
	{
		for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
		{
			NSRect aCurrentViewFrame = [anInspectedView frame];
			if(theControl==oXPosition)
				aCurrentViewFrame.origin.x--;
			else if(theControl==oYPosition)
				aCurrentViewFrame.origin.y--;
			else if(theControl==oWidth)
				aCurrentViewFrame.size.width--;
			else if(theControl==oHeight)
				aCurrentViewFrame.size.height--;
			[anInspectedView setFrame:aCurrentViewFrame];
		}
		return YES;
	}
	else
		return NO;
}


- (NSArray*)inspectedViews
{
	return [self inspectedObjects];
}

@end
