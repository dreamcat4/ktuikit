//
//  KTViewInspector.m
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTViewInspector.h"
#import <KTUIKitFramework/KTView.h>

@implementation KTViewInspector

- (NSString *)viewNibName 
{
    return @"KTViewInspector";
}

+ (BOOL)supportsMultipleObjectInspection
{
	return NO;
}

- (void)setHorizontalSelection:(int)theTag
{
	mHorizontalSelection = theTag;
}

- (void)setVerticalSelection:(int)theTag
{
	mVerticalSelection = theTag;
}

- (int)horizontalSelection
{
	return mHorizontalSelection;
}

- (int)verticalSelection
{
	return mVerticalSelection;
}

- (void)refresh 
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	//int i;
//	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *			anInspectedView = [anInspectedObjectsList objectAtIndex:0];
		KTLayoutManager *	aViewLayoutManager = [anInspectedView viewLayoutManager];
		NSRect				aViewFrame = [anInspectedView frame];
		NSRect				aSuperviewFrame = [[anInspectedView superview] frame];
		
		
		// Color & Label
		[oBackgroundColor setColor:[anInspectedView backgroundColor]];
		[oLabel setStringValue:[anInspectedView label]];
		
		// Layout
		
		// FRAME
		[oWidth setFloatValue:aViewFrame.size.width];
		[oHeight setFloatValue:aViewFrame.size.height];
		[oXPosition setFloatValue:aViewFrame.origin.x];
		[oYPosition setFloatValue:aViewFrame.origin.y];
		
		if([[anInspectedView superview] isKindOfClass:[KTView class]])
		{
		
			[oVPosType setEnabled:YES];
			[oHPosType setEnabled:YES];
			// HORIZONTAL BEHAVIOR
			if(		[aViewLayoutManager horizontalPositionType] == KTHorizontalPositionStickLeft
				||	[aViewLayoutManager horizontalPositionType] == KTHorizontalPositionAbsolute )
			{
				float aLeftMargin = aViewFrame.origin.x;
				[aViewLayoutManager setMarginLeft:aLeftMargin];
				[oRightMargin setStringValue:@"flexible"];
				[aViewLayoutManager setMarginRight:0];
				[oLeftMargin setFloatValue:aLeftMargin];
				[self setHorizontalSelection:0];
			}
			else if([aViewLayoutManager horizontalPositionType] == KTHorizontalPositionStickRight)
			{
				float aRightMargin = aSuperviewFrame.size.width - (aViewFrame.origin.x + aViewFrame.size.width);
				[aViewLayoutManager setMarginRight:aRightMargin];
				[oRightMargin setFloatValue:aRightMargin];
				[aViewLayoutManager setMarginLeft:0];
				[oLeftMargin setStringValue:@"flexible"];
				[self setHorizontalSelection:1];
			}
			else if([aViewLayoutManager horizontalPositionType] == KTHorizontalPositionKeepCentered)
			{
				[oRightMargin setStringValue:@"flexible"];
				[oLeftMargin setStringValue:@"flexible"];
				[self setHorizontalSelection:3];
			}
			
			if([aViewLayoutManager widthType] == KTSizeFill)
			{
				float aRightMargin = aSuperviewFrame.size.width - (aViewFrame.origin.x + aViewFrame.size.width);
				float aLeftMargin = aViewFrame.origin.x;
				[aViewLayoutManager setMarginRight:aRightMargin];
				[aViewLayoutManager setMarginLeft:aLeftMargin];
				[oRightMargin setFloatValue:aRightMargin];
				[oLeftMargin setFloatValue:aLeftMargin];
				[self setHorizontalSelection:2];
			}
			
			// VERTICAL  BEHAVIOR
			if(		[aViewLayoutManager verticalPositionType] == KTVerticalPositionAbsolute
				||	[aViewLayoutManager verticalPositionType] == KTVerticalPositionStickBottom )
			{
				float aBottomMargin = aViewFrame.origin.y;
				[aViewLayoutManager setMarginBottom:aBottomMargin];
				[oTopMargin setStringValue:@"flexible"];
				[oBottomMargin setFloatValue:aBottomMargin];
				[self setVerticalSelection:0];
			}
			else if([aViewLayoutManager verticalPositionType] == KTVerticalPositionStickTop)
			{
				float aTopMargin = [[anInspectedView superview] frame].size.height - [anInspectedView frame].origin.y - [anInspectedView frame].size.height;
				[aViewLayoutManager setMarginTop:aTopMargin];
				[oTopMargin setFloatValue:aTopMargin];
				[oBottomMargin setStringValue:@"flexible"];
				[self setVerticalSelection:1];
			}
			else if([aViewLayoutManager verticalPositionType] == KTVerticalPositionKeepCentered)
			{
				[oTopMargin setStringValue:@"flexible"];
				[oBottomMargin setStringValue:@"flexible"];
				[self setVerticalSelection:3];
			}
			
			if([aViewLayoutManager heightType] == KTSizeFill)
			{
				float aTopMargin = [[anInspectedView superview] frame].size.height - [anInspectedView frame].origin.y - [anInspectedView frame].size.height;
				float aBottomMargin = aViewFrame.origin.y;
				[aViewLayoutManager setMarginTop:aTopMargin];
				[aViewLayoutManager setMarginBottom:aBottomMargin];
				[oTopMargin setFloatValue:aTopMargin];
				[oBottomMargin setFloatValue:aBottomMargin];
				[self setVerticalSelection:2];
			}
		}
		else
		{
			[oVPosType setEnabled:NO];
			[oHPosType setEnabled:NO];
			[oTopMargin setStringValue:@"flexible"];
			[oBottomMargin setFloatValue:0];
			[oLeftMargin setFloatValue:0];
			[oRightMargin setStringValue:@"flexible"];
		}	
	}
	[super refresh];
}


#pragma mark -
#pragma mark KTView Configuration

- (IBAction)setLabel:(id)theSender
{
	NSString *	aLabel = [theSender stringValue];
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[anInspectedView setLabel:aLabel];
	}
}

- (IBAction)setXPosition:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect		aCurrentViewFrame = [anInspectedView frame];
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
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect		aCurrentViewFrame = [anInspectedView frame];
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
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect		aCurrentViewFrame = [anInspectedView frame];
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
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect		aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.size.height = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}

- (IBAction)setHPosType:(id)theSender
{
	
	// 0 - maintain left margin
	// 1 - maintain right margin 
	// 2 - maintain left and right margins
	// 3 - keep centered horizonally
	
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int aTag = [theSender selectedTag];
	//int i;
	//for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:0];
		if(![[anInspectedView superview] isKindOfClass:[KTView class]])
			return;
		
		if(aTag == 0)
		{
			float aLeftMargin = [anInspectedView frame].origin.x;
			[oLeftMargin setFloatValue:aLeftMargin];
			[oRightMargin setStringValue:@"flexible"];
			
			[[anInspectedView viewLayoutManager] setMarginLeft:aLeftMargin];
			[[anInspectedView viewLayoutManager] setMarginRight:0];
			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionStickLeft];
		}
		else if(aTag == 1)
		{	
			float aRightMargin = [[anInspectedView superview] frame].size.width - ([anInspectedView frame].origin.x+[anInspectedView frame].size.width);
			
			[oRightMargin setFloatValue:aRightMargin];
			[oLeftMargin setStringValue:@"flexible"];
			
			[[anInspectedView viewLayoutManager] setMarginRight:aRightMargin];
			[[anInspectedView viewLayoutManager] setMarginLeft:0];
			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionStickRight];
		}
		else if(aTag == 2)
		{
			float aRightMargin = [[anInspectedView superview] frame].size.width - ([anInspectedView frame].origin.x+[anInspectedView frame].size.width);
			[oRightMargin setFloatValue:aRightMargin];
			[[anInspectedView viewLayoutManager] setMarginRight:aRightMargin];
			
			float aLeftMargin = [anInspectedView frame].origin.x;
			[oLeftMargin setFloatValue:aLeftMargin];
			
			[[anInspectedView viewLayoutManager] setMarginLeft:aLeftMargin];
			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionAbsolute];
			[[anInspectedView viewLayoutManager] setWidthType:KTSizeFill];
		}
		else if(aTag == 3)
		{
			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionKeepCentered];
			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setMarginRight:0];
			[[anInspectedView viewLayoutManager] setMarginLeft:0];
			
			[oRightMargin setStringValue:@"flexible"];
			[oLeftMargin setStringValue:@"flexible"];
		}
	}
}
- (IBAction)setVPosType:(id)theSender
{
	// 0 - maintain bottom margin
	// 1 - maintain top margin 
	// 2 - maintain top and bottom margins
	// 3 - center vertically in superview
	
	int aTag = [theSender selectedTag];
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		if(aTag == 0)
		{
			float aBottomMargin = [anInspectedView frame].origin.y;
			[oBottomMargin setFloatValue:aBottomMargin];
			[oTopMargin setStringValue:@"flexible"];
			
			[[anInspectedView viewLayoutManager] setMarginBottom:aBottomMargin];
			[[anInspectedView viewLayoutManager] setMarginTop:0];
			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionStickBottom];
			
		}
		else if(aTag == 1)
		{	
			float aTopMargin = [[anInspectedView superview] frame].size.height - [anInspectedView frame].origin.y - [anInspectedView frame].size.height;
			[oTopMargin setFloatValue:aTopMargin];
			[oBottomMargin setStringValue:@"flexible"];
			[[anInspectedView viewLayoutManager] setMarginTop:aTopMargin];
			[[anInspectedView viewLayoutManager] setMarginBottom:0];
			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionStickTop];
		}
		else if(aTag == 2)
		{
			float aBottomMargin = [anInspectedView frame].origin.y;
			[oBottomMargin setFloatValue:aBottomMargin];
			[[anInspectedView viewLayoutManager] setMarginBottom:aBottomMargin];
			
			float aTopMargin = [[anInspectedView superview] frame].size.height - [anInspectedView frame].origin.y - [anInspectedView frame].size.height;
			[oTopMargin setFloatValue:aTopMargin];
			[[anInspectedView viewLayoutManager] setMarginTop:aTopMargin];
			
			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionAbsolute];
			[[anInspectedView viewLayoutManager] setHeightType:KTSizeFill];
		}
		else if(aTag == 3)
		{
			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionKeepCentered];
			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
			[[anInspectedView viewLayoutManager] setMarginTop:0];
			[[anInspectedView viewLayoutManager] setMarginBottom:0];
			
			[oRightMargin setStringValue:@"flexible"];
			[oLeftMargin setStringValue:@"flexible"];
		}
	}
}

- (IBAction)setBackgroundColor:(id)theSender
{
	NSColor *	aBackgroundColor = [theSender color];
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[anInspectedView setBackgroundColor:aBackgroundColor];
		[anInspectedView setNeedsDisplay:YES];
	}
}


/*

- (IBAction)setTopMargin:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setMarginTop:[theSender floatValue]];
	}
}

- (IBAction)setRightMargin:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setMarginRight:[theSender floatValue]];
	}
}
- (IBAction)setBottomMargin:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setMarginBottom:[theSender floatValue]];
	}
}
- (IBAction)setLeftMargin:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setMarginLeft:[theSender floatValue]];
		
	}
}

- (IBAction)setWidthType:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setWidthType:[theSender selectedTag]];
	}
}

- (IBAction)setWidthPercentage:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setWidthPercentage:[theSender floatValue]];
	}
}

- (IBAction)setHeightType:(id)theSender
{
	int aTag = [theSender selectedTag];
	
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setHeightType:aTag];
	}
}


- (IBAction)setHeightPercentage:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		KTView *	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		[[anInspectedView viewLayoutManager] setHeightPercentage:[theSender floatValue]];
	}
}
*/


@end
