//
//  KTStyleInspector.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTStyleInspector.h"
#import "KTView.h"
#import "KTStyleManager.h"
#import "KTGradientPicker.h"

@interface KTStyleInspector (Private)

- (void)setBackgroundControlsEnabled:(BOOL)theBool;
- (void)setBorderControlsEnabled:(BOOL)theBool;

@end

@implementation KTStyleInspector

- (NSString *)viewNibName {
    return @"KTStyleInspector";
}

+ (BOOL)supportsMultipleObjectInspection
{
	return YES;
}

- (void)refresh 
{
	// Synchronize your inspector's content view with the currently selected objects
	
	NSArray * anInspectedViewList = [self inspectedObjects];
	int		  aViewCount = [anInspectedViewList count];
	
	if(aViewCount > 1)
	{
		// multiple values
		
		// background color
		BOOL		aColorsAreDifferent = NO;
		NSColor *	aFirstViewColor = [[[anInspectedViewList objectAtIndex:0] styleManager] backgroundColor];
		
		int i;
		for(i = 1; i < aViewCount; i++)
		{
			NSColor * aCompareColor = [[[anInspectedViewList objectAtIndex:i] styleManager] backgroundColor];
			if([aFirstViewColor isEqualTo:aCompareColor] == NO)
			{
				aColorsAreDifferent = YES;
				break;
			}
		}
		if(aColorsAreDifferent)
			[oBackgroundColorWell setColor:[NSColor clearColor]];
		else
			[oBackgroundColorWell setColor:aFirstViewColor];
			
			
//		// borders
//		
//		// top
//		aFirstViewColor = [[[anInspectedViewList objectAtIndex:0] styleManager] borderColorTop];
//		
//		for(i = 1; i < aViewCount; i++)
//		{
//			NSColor * aCompareColor = [[[anInspectedViewList objectAtIndex:i] styleManager] borderColorTop];
//			if([aFirstViewColor isEqualTo:aCompareColor] == NO)
//			{
//				aColorsAreDifferent = YES;
//				break;
//			}
//		}
//		if(aColorsAreDifferent)
//			[oBorderColorTopColorWell setColor:[NSColor clearColor]];
//		else
//			[oBorderColorTopColorWell setColor:aFirstViewColor];
//			
//			
//		// right
//		aFirstViewColor = [[[anInspectedViewList objectAtIndex:0] styleManager] borderColorRight];
//		
//		for(i = 1; i < aViewCount; i++)
//		{
//			NSColor * aCompareColor = [[[anInspectedViewList objectAtIndex:i] styleManager] borderColorRight];
//			if([aFirstViewColor isEqualTo:aCompareColor] == NO)
//			{
//				aColorsAreDifferent = YES;
//				break;
//			}
//		}
//		if(aColorsAreDifferent)
//			[oBorderColorRightColorWell setColor:[NSColor clearColor]];
//		else
//			[oBorderColorRightColorWell setColor:aFirstViewColor];
//			
//		// bottom
//		aFirstViewColor = [[[anInspectedViewList objectAtIndex:0] styleManager] borderColorBottom];
//		
//		for(i = 1; i < aViewCount; i++)
//		{
//			NSColor * aCompareColor = [[[anInspectedViewList objectAtIndex:i] styleManager] borderColorBottom];
//			if([aFirstViewColor isEqualTo:aCompareColor] == NO)
//			{
//				aColorsAreDifferent = YES;
//				break;
//			}
//		}
//		if(aColorsAreDifferent)
//			[oBorderColorBottomColorWell setColor:[NSColor clearColor]];
//		else
//			[oBorderColorBottomColorWell setColor:aFirstViewColor];
//			
//			
//		// left
//		aFirstViewColor = [[[anInspectedViewList objectAtIndex:0] styleManager] borderColorLeft];
//
//		for(i = 1; i < aViewCount; i++)
//		{
//			NSColor * aCompareColor = [[[anInspectedViewList objectAtIndex:i] styleManager] borderColorLeft];
//			if([aFirstViewColor isEqualTo:aCompareColor] == NO)
//			{
//				aColorsAreDifferent = YES;
//				break;
//			}
//		}
//		if(aColorsAreDifferent)
//			[oBorderColorLeftColorWell setColor:[NSColor clearColor]];
//		else
//			[oBorderColorLeftColorWell setColor:aFirstViewColor];
//			
//
	}
	else if([anInspectedViewList count]==1)
	{
		KTStyleManager * anInspectedStyleManager = [[anInspectedViewList objectAtIndex:0] styleManager];
		[oBackgroundColorWell setColor:[anInspectedStyleManager backgroundColor]];
		if([anInspectedStyleManager backgroundGradient]!=nil)
			[oBackgroundGradientPicker setGradientValue:[anInspectedStyleManager backgroundGradient]];
//		[oBorderColorTopColorWell setColor:[anInspectedStyleManager borderColorTop]];
//		[oBorderColorRightColorWell setColor:[anInspectedStyleManager borderColorRight]];
//		[oBorderColorBottomColorWell setColor:[anInspectedStyleManager borderColorBottom]];
//		[oBorderColorLeftColorWell setColor:[anInspectedStyleManager borderColorLeft]];
	}
	
	
	//
	
	[super refresh];
}


- (IBAction)setDrawsBackground:(id)theSender
{
	if([theSender intValue]==1)
	{
		[self setBackgroundControlsEnabled:YES];
	}
	else
	{
		// no, don't draw Background
		// disable the controls
		[self setBackgroundControlsEnabled:NO];
		
		// set values for selected objects to nothing
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBackgroundGradient:nil angle:0];
			[aStyleManager setBackgroundColor:[NSColor clearColor]];
			[aView setNeedsDisplay:YES];
		}
	}
}

- (void)setBackgroundControlsEnabled:(BOOL)theBool
{
	[oBackgroundOptionsRadioButton setEnabled:theBool];
	[oBackgroundColorWell setEnabled:theBool];
	[oBackgroundGradientPicker setEnabled:theBool];
}


- (IBAction)setBackgroundColor:(id)theSender
{
	for(KTView * aView in [self inspectedObjects])
	{
		KTStyleManager * aStyleManager = [aView styleManager];
		[aStyleManager setBackgroundGradient:nil angle:0];
		[aStyleManager setBackgroundColor:[theSender color]];
		[aView setNeedsDisplay:YES];
	}
}

- (IBAction)setBackgroundGradient:(id)theSender
{
	for(KTView * aView in [self inspectedObjects])
	{
		KTStyleManager * aStyleManager = [aView styleManager];
		[aStyleManager setBackgroundGradient:[theSender gradientValue] angle:-90];
		[aStyleManager setBackgroundColor:[NSColor clearColor]];
		[aView setNeedsDisplay:YES];
	}
}


- (IBAction)setDrawsBorders:(id)theSender
{
	if([theSender intValue]==1)
	{
		// yes, draw borders enable controls
		[self setBorderControlsEnabled:YES];
	}
	else
	{
		// no, don't draw borders
		// disable controls
		[self setBorderControlsEnabled:NO];
		// clear values for selected views
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidth:0];
			[aStyleManager setBorderColor:[NSColor clearColor]];
			[aView setNeedsDisplay:YES];
		}
	}
}

- (void)setBorderControlsEnabled:(BOOL)theBool
{
	[oTargetBorderPopUpButton setEnabled:theBool];
	[oBorderWithTextField setEnabled:theBool];
	[oBorderWidthStepper setEnabled:theBool];
	[oBorderColorWell setEnabled:theBool];
}

- (IBAction)setBorderWidth:(id)theSender
{
	// which side is selected
	NSInteger aSelectedSide = [[oTargetBorderPopUpButton selectedItem] tag];
	switch (aSelectedSide)
	{
		case 0:
		// All sides
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidth:[oBorderWithTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 1:
		// Top
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthTop:[oBorderWithTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 2:
		// Right
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthRight:[oBorderWithTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 3:
		// Bottom
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthBottom:[oBorderWithTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 4:
		// Left
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthLeft:[oBorderWithTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
	}
}


- (IBAction)setBorderColor:(id)theSender
{
	// which side is selected
	NSInteger aSelectedSide = [[oTargetBorderPopUpButton selectedItem] tag];
	switch (aSelectedSide)
	{
		case 0:
		// All sides
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColor:[theSender color]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 1:
		// Top
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorTop:[theSender color]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 2:
		// Right
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorRight:[theSender color]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 3:
		// Bottom
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorBottom:[theSender color]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 4:
		// Left
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorLeft:[theSender color]];
			[aView setNeedsDisplay:YES];
		}
		break;
	}
}



@end



