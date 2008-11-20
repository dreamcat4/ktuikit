//
//  KTLayoutManagerInspector.m
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTLayoutManagerInspector.h"
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
		//KTLayoutManager *		aViewLayoutManager = [anInspectedView viewLayoutManager];
		NSRect					aViewFrame = [anInspectedView frame];
		//NSRect					aSuperviewFrame = [[anInspectedView parent] frame];
				
		// FRAME
		[oWidth setFloatValue:aViewFrame.size.width];
		[oHeight setFloatValue:aViewFrame.size.height];
		[oXPosition setFloatValue:aViewFrame.origin.x];
		[oYPosition setFloatValue:aViewFrame.origin.y];
		
		
		if([anInspectedView parent]!=nil)
		{

			[oWidth setEnabled:YES];
			[oHeight setEnabled:YES];
			[oXPosition setEnabled:YES];
			[oYPosition setEnabled:YES];
		}
		else
		{
			[oXPosition setEnabled:NO];
			[oYPosition setEnabled:NO];
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

//- (IBAction)setHPosType:(id)theSender
//{
//	
//	// 0 - maintain left margin
//	// 1 - maintain right margin 
//	// 2 - maintain left and right margins
//	// 3 - keep centered horizonally
//	
//	NSArray *	anInspectedObjectsList = [self inspectedObjects];
//	int aTag = [theSender selectedTag];
//	//int i;
//	//for(i = 0; i < [anInspectedObjectsList count]; i++)
//	{
//		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:0];
//		
//		if(aTag == 0)
//		{
//			float aLeftMargin = [anInspectedView frame].origin.x;
//			[oLeftMargin setFloatValue:aLeftMargin];
//			[oRightMargin setStringValue:@"flexible"];
//			
//			[[anInspectedView viewLayoutManager] setMarginLeft:aLeftMargin];
//			[[anInspectedView viewLayoutManager] setMarginRight:0];
//			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionStickLeft];
//		}
//		else if(aTag == 1)
//		{	
//			float aRightMargin = [[anInspectedView parent] frame].size.width - ([anInspectedView frame].origin.x+[anInspectedView frame].size.width);
//			
//			[oRightMargin setFloatValue:aRightMargin];
//			[oLeftMargin setStringValue:@"flexible"];
//			
//			[[anInspectedView viewLayoutManager] setMarginRight:aRightMargin];
//			[[anInspectedView viewLayoutManager] setMarginLeft:0];
//			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionStickRight];
//		}
//		else if(aTag == 2)
//		{
//			float aRightMargin = [[anInspectedView parent] frame].size.width - ([anInspectedView frame].origin.x+[anInspectedView frame].size.width);
//			[oRightMargin setFloatValue:aRightMargin];
//			[[anInspectedView viewLayoutManager] setMarginRight:aRightMargin];
//			
//			float aLeftMargin = [anInspectedView frame].origin.x;
//			[oLeftMargin setFloatValue:aLeftMargin];
//			[[anInspectedView viewLayoutManager] setMarginLeft:aLeftMargin];
//			
//			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionAbsolute];
//			[[anInspectedView viewLayoutManager] setWidthType:KTSizeFill];
//		}
//		
//		else if(aTag == 3)
//		{
//			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionKeepCentered];
//			[[anInspectedView viewLayoutManager] setWidthType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setMarginRight:0];
//			[[anInspectedView viewLayoutManager] setMarginLeft:0];
//			
//			[oRightMargin setStringValue:@"flexible"];
//			[oLeftMargin setStringValue:@"flexible"];
//		}
//	}
//}
//- (IBAction)setVPosType:(id)theSender
//{
//	// 0 - maintain bottom margin
//	// 1 - maintain top margin 
//	// 2 - maintain top and bottom margins
//	// 3 - center vertically in superview
//	
//	int aTag = [theSender selectedTag];
//	NSArray *	anInspectedObjectsList = [self inspectedObjects];
//	int i;
//	for(i = 0; i < [anInspectedObjectsList count]; i++)
//	{
//		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
//		if(aTag == 0)
//		{
//			float aBottomMargin = [anInspectedView frame].origin.y;
//			[oBottomMargin setFloatValue:aBottomMargin];
//			[oTopMargin setStringValue:@"flexible"];
//			
//			[[anInspectedView viewLayoutManager] setMarginBottom:aBottomMargin];
//			[[anInspectedView viewLayoutManager] setMarginTop:0];
//			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionStickBottom];
//			
//		}
//		else if(aTag == 1)
//		{	
//			float aTopMargin = [[anInspectedView parent] frame].size.height - [anInspectedView frame].origin.y - [anInspectedView frame].size.height;
//			[oTopMargin setFloatValue:aTopMargin];
//			[oBottomMargin setStringValue:@"flexible"];
//			[[anInspectedView viewLayoutManager] setMarginTop:aTopMargin];
//			[[anInspectedView viewLayoutManager] setMarginBottom:0];
//			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionStickTop];
//		}
//		else if(aTag == 2)
//		{
//			float aBottomMargin = [anInspectedView frame].origin.y;
//			[oBottomMargin setFloatValue:aBottomMargin];
//			[[anInspectedView viewLayoutManager] setMarginBottom:aBottomMargin];
//			
//			float aTopMargin = [[anInspectedView parent] frame].size.height - [anInspectedView frame].origin.y - [anInspectedView frame].size.height;
//			[oTopMargin setFloatValue:aTopMargin];
//			[[anInspectedView viewLayoutManager] setMarginTop:aTopMargin];
//			
//			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionAbsolute];
//			[[anInspectedView viewLayoutManager] setHeightType:KTSizeFill];
//		}
//		else if(aTag == 3)
//		{
//			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setVerticalPositionType:KTVerticalPositionKeepCentered];
//			[[anInspectedView viewLayoutManager] setHeightType:KTSizeAbsolute];
//			[[anInspectedView viewLayoutManager] setMarginTop:0];
//			[[anInspectedView viewLayoutManager] setMarginBottom:0];
//			
//			[oRightMargin setStringValue:@"flexible"];
//			[oLeftMargin setStringValue:@"flexible"];
//		}
//	}
//}


- (NSArray*)inspectedViews
{
	return [self inspectedObjects];
}

@end
