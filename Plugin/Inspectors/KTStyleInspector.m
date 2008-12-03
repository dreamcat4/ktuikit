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
#import "KTColorWell.h"

@interface KTStyleInspector (Private)

- (void)setBackgroundControlsEnabled:(BOOL)theBool;
- (void)setBorderControlsEnabled:(BOOL)theBool;
- (BOOL)isColor:(NSColor*)theFirstColor equalTo:(NSColor*)theSecondColor;
- (BOOL)isGradient:(NSGradient*)theFirstGradient equalTo:(NSGradient*)theSencondGradient;

@end

@implementation KTStyleInspector

- (NSString *)viewNibName {
    return @"KTStyleInspector";
}

+ (BOOL)supportsMultipleObjectInspection
{
	return YES;
}

- (void)awakeFromNib
{
	[oBackgroundGradientPicker setTarget:self];
	[oBackgroundGradientPicker setAction:@selector(setBackgroundGradient:)];
}


- (void)refresh 
{	
	NSArray * anInspectedViewList = [self inspectedObjects];
	int		  aViewCount = [anInspectedViewList count];
	
	if(aViewCount==0)
		return;
		
		
	BOOL aFoundMultipleValuesForDrawsBackground = NO;
	BOOL aFoundMultipleValuesForBackgroundStyle = NO;
	BOOL aFoundMultipleValuesForBackgroundColor = NO;
	BOOL aFoundMultipleValuesForBackgroundGradient = NO;
	
//	BOOL aFoundMultipleValuesForDrawsBorders = NO;
//	BOOL aFoundMultipleValuesForTopBorderColor = NO;
//	BOOL aFoundMultipleValuesForTopBorderWidth = NO;
	
	
	// inspect the first view
	
	// background color
	KTStyleManager *	aFirstViewStyleManager = [[anInspectedViewList objectAtIndex:0] styleManager];
	NSColor *			aFirstViewBackgroundColor = [aFirstViewStyleManager backgroundColor];
	NSGradient *		aFirstViewBackgroundGradient = [aFirstViewStyleManager backgroundGradient];
	BOOL				aFirstViewDrawsBackground = ((aFirstViewBackgroundColor!=[NSColor clearColor] && aFirstViewBackgroundColor!=nil)
															|| aFirstViewBackgroundGradient!=nil);
	BOOL				aFirstViewBackgroundStyle = (aFirstViewBackgroundGradient==nil);
	
	int i;
	for(i = 1; i < aViewCount; i++)
	{
		KTStyleManager *	aStyleManager = [[anInspectedViewList objectAtIndex:i] styleManager];
		NSColor *			aCompareViewBackgroundColor = [aStyleManager backgroundColor];
		NSGradient *		aCompareViewGradient = [aStyleManager backgroundGradient];
		BOOL				aCompareViewDrawsBackground = ((aCompareViewBackgroundColor!=[NSColor clearColor] && aCompareViewBackgroundColor!=nil)
															|| aCompareViewGradient!=nil);
		BOOL				aCompareViewBackgroundStyle = (aCompareViewGradient==nil);
		
		if(aFirstViewDrawsBackground!=aCompareViewDrawsBackground)
			aFoundMultipleValuesForDrawsBackground = YES;
		if([self isColor:aFirstViewBackgroundColor equalTo:aCompareViewBackgroundColor] == NO)
			aFoundMultipleValuesForBackgroundColor = YES;
		if([self isGradient:aFirstViewBackgroundGradient equalTo:aCompareViewGradient] == NO)
			aFoundMultipleValuesForBackgroundGradient = YES;	
		if(aFirstViewBackgroundStyle!=aCompareViewBackgroundStyle)
			aFoundMultipleValuesForBackgroundStyle = YES;
			
//		// do we still need to compare?
//		if(		aFoundMultipleValuesForDrawsBackground
//			&&	aFoundMultipleValuesForBackgroundColor
//			&&	aFoundMultipleValuesForBackgroundGradient)
//			break;
	}
	
	
			
					
	//----------------------------------------------------------------------------------------
	// Background Colors
	//----------------------------------------------------------------------------------------									
	if(aFoundMultipleValuesForDrawsBackground) // some selected views draw background, some do not
	{
		// mixed state
		[oDrawBackgroundCheckBox setState:NSMixedState];
	
		// controls disabled in this case, i guess...
		[oBackgroundOptionsRadioButton deselectAllCells];
		[oBackgroundOptionsRadioButton setEnabled:NO];
		[oBackgroundColorWell setColor:[NSColor clearColor]];
		[oBackgroundGradientPicker setGradientValue:nil];
		[oBackgroundColorWell setEnabled:NO];
		[oBackgroundGradientPicker setIsEnabled:NO];
	}
	else
	{
		[oDrawBackgroundCheckBox setState:aFirstViewDrawsBackground];
		if(aFirstViewDrawsBackground==NO) // none of the selected views draw background, disable the controls
		{
			[oBackgroundOptionsRadioButton selectCellAtRow:0 column:0];
			[oBackgroundOptionsRadioButton setEnabled:NO];
			[oBackgroundColorWell setColor:[NSColor clearColor]];
			[oBackgroundGradientPicker setGradientValue:nil];
			[oBackgroundColorWell setEnabled:NO];
			[oBackgroundGradientPicker setIsEnabled:NO];
		}
		else // all the views draw background, but the values themselves can be mixed
		{
			// do they have the same background style?
			if(aFoundMultipleValuesForBackgroundStyle==NO)
			{
				// they have the same style
				
				if(aFirstViewBackgroundStyle==1)
				{
					// they all draw solid color
					NSColor * aColorToDisplay = nil;
					
					// check if the color is the same
					if(aFoundMultipleValuesForBackgroundColor)
						aColorToDisplay = [NSColor clearColor];
					else
						aColorToDisplay = aFirstViewBackgroundColor;
						
					// enable the radio button,set to solid color			
					[oBackgroundOptionsRadioButton setEnabled:YES];
					[oBackgroundOptionsRadioButton selectCellAtRow:0 column:0];
					// set the colorWell to the view's color
					[oBackgroundColorWell setEnabled:YES];
					[oBackgroundColorWell setColor:aColorToDisplay];
					// disable the gradient picker & clear its value
					[oBackgroundGradientPicker setIsEnabled:NO];
					[oBackgroundGradientPicker setGradientValue:nil];
				}
				else
				{
					// they all draw gradient
					NSGradient * aGradientToDisplay = nil;
					if(aFoundMultipleValuesForBackgroundGradient==NO)
						aGradientToDisplay = aFirstViewBackgroundGradient;
					
					// enable the radio button,set to gradient			
					[oBackgroundOptionsRadioButton setEnabled:YES];
					[oBackgroundOptionsRadioButton selectCellAtRow:1 column:0];
					// enable the gradient picker and set its value to the view's gradient
					[oBackgroundGradientPicker setIsEnabled:YES];
					[oBackgroundGradientPicker setGradientValue:aGradientToDisplay];
					// clear the color well and disable it
					[oBackgroundColorWell setColor:[NSColor clearColor]];
					[oBackgroundColorWell setEnabled:NO];
				}
			}
			else // the selected views have different background styles - some solid color, some gradient
			{
				// enable the radio button, but no selection
				[oBackgroundOptionsRadioButton setEnabled:YES];
				[oBackgroundOptionsRadioButton deselectAllCells];
				[oBackgroundColorWell setColor:[NSColor clearColor]];
				[oBackgroundGradientPicker setGradientValue:nil];
				[oBackgroundColorWell setEnabled:NO];
				[oBackgroundGradientPicker setIsEnabled:NO];
			}
		}
	}	
			
	//----------------------------------------------------------------------------------------
	// Border Colors and Widths
	//----------------------------------------------------------------------------------------
	
	
	
	[super refresh];
}


#pragma mark -
#pragma mark Background related actions

- (IBAction)setDrawsBackground:(id)theSender
{
	if([theSender intValue]==1)
	{
		[oBackgroundOptionsRadioButton setEnabled:YES];
		[self setBackgroundOption:oBackgroundOptionsRadioButton];	
	}
	else
	{
		// no, don't draw Background
		// disable the controls
		[oBackgroundOptionsRadioButton setEnabled:NO];
		[oBackgroundColorWell setEnabled:NO];
		[oBackgroundColorWell setColor:[NSColor clearColor]];
		[oBackgroundGradientPicker setIsEnabled:NO];
		[oBackgroundGradientPicker setGradientValue:nil];
		
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
- (IBAction)setBackgroundOption:(id)theSender
{
	if([theSender selectedRow]==0)
	{
		[oBackgroundColorWell setEnabled:YES];
		if([oBackgroundColorWell color]==[NSColor clearColor])
			[oBackgroundColorWell setColor:[NSColor redColor]];
		[self setBackgroundColor:oBackgroundColorWell];
		[oBackgroundGradientPicker setGradientValue:nil];
		[oBackgroundGradientPicker setIsEnabled:NO];	
	}
	else if([theSender selectedRow]==1)
	{
		[oBackgroundGradientPicker setIsEnabled:YES];
		[self setBackgroundGradient:oBackgroundGradientPicker];
		[oBackgroundColorWell setEnabled:NO];
		[oBackgroundColorWell setColor:[NSColor clearColor]];
	}
}

- (IBAction)setBackgroundColor:(id)theSender
{
	for(KTView * aView in [self inspectedObjects])
	{
		KTStyleManager * aStyleManager = [aView styleManager];
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
		[aView setNeedsDisplay:YES];
	}
}


#pragma mark -
#pragma mark Border related actions
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
	[oTopBorderWidthTextField setEnabled:theBool];
	[oTopBorderColorWell setEnabled:theBool];
	[oRightBorderWidthTextField setEnabled:theBool];
	[oRightBorderColorWell setEnabled:theBool];
	[oBottomBorderWidthTextField setEnabled:theBool];
	[oBottomBorderColorWell setEnabled:theBool];
	[oLeftBorderWidthTextField setEnabled:theBool];
	[oLeftBorderColorWell setEnabled:theBool];
}

- (IBAction)setBorderWidth:(id)theSender
{
	NSInteger aSelectedSide = [theSender tag];
	switch (aSelectedSide)
	{
		case 0:
		// All sides
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidth:[oLeftBorderWidthTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 1:
		// Top
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthTop:[oTopBorderWidthTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 2:
		// Right
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthRight:[oRightBorderWidthTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 3:
		// Bottom
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthBottom:[oBottomBorderWidthTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 4:
		// Left
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderWidthLeft:[oLeftBorderWidthTextField intValue]];
			[aView setNeedsDisplay:YES];
		}
		break;
	}
}


- (IBAction)setBorderColor:(id)theSender
{
	// which side is selected
	NSInteger aSelectedSide = [theSender tag];
	switch (aSelectedSide)
	{
		case 0:
		// All sides
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColor:[oLeftBorderColorWell color]];
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 1:
		// Top
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorTop:[oTopBorderColorWell color]];
			if([oTopBorderWidthTextField intValue]==0)
			{
				[oTopBorderWidthTextField setIntValue:1];
				[self setBorderWidth:oTopBorderWidthTextField];
			}
			if([[oTopBorderColorWell color] alphaComponent]==0)
			{
				[oTopBorderWidthTextField setIntValue:0];
				[self setBorderWidth:oTopBorderWidthTextField];
			}
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 2:
		// Right
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorRight:[oRightBorderColorWell color]];
			if([oRightBorderWidthTextField intValue]==0)
			{
				[oRightBorderWidthTextField setIntValue:1];
				[self setBorderWidth:oRightBorderWidthTextField];
			}
			if([[oRightBorderColorWell color] alphaComponent]==0)
			{
				[oRightBorderWidthTextField setIntValue:0];
				[self setBorderWidth:oRightBorderWidthTextField];
			}
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 3:
		// Bottom
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorBottom:[oBottomBorderColorWell color]];
			if([oBottomBorderWidthTextField intValue]==0)
			{
				[oBottomBorderWidthTextField setIntValue:1];
				[self setBorderWidth:oBottomBorderWidthTextField];
			}
			if([[oBottomBorderColorWell color] alphaComponent]==0)
			{
				[oBottomBorderWidthTextField setIntValue:0];
				[self setBorderWidth:oBottomBorderWidthTextField];
			}
			[aView setNeedsDisplay:YES];
		}
		break;
		
		case 4:
		// Left
		for(KTView * aView in [self inspectedObjects])
		{
			KTStyleManager * aStyleManager = [aView styleManager];
			[aStyleManager setBorderColorLeft:[oLeftBorderColorWell color]];
			if([oLeftBorderWidthTextField intValue]==0)
			{
				[oLeftBorderWidthTextField setIntValue:1];
				[self setBorderWidth:oLeftBorderWidthTextField];
			}
			if([[oLeftBorderColorWell color] alphaComponent]==0)
			{
				[oLeftBorderWidthTextField setIntValue:0];
				[self setBorderWidth:oLeftBorderWidthTextField];
			}
			[aView setNeedsDisplay:YES];
		}
		break;
	}
}

- (IBAction)setEditAllBorders:(id)theSender
{
	[self setBorderWidth:theSender];
	[self setBorderColor:theSender];
}

- (BOOL)control:(NSControl *)theControl textView:(NSTextView *)theTextView  doCommandBySelector:(SEL)theCommandSelector
{
	if(theCommandSelector==@selector(moveUp:))
	{
		for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
		{
			if(theControl==oTopBorderWidthTextField)
			{
				[oTopBorderWidthTextField setIntValue:[oTopBorderWidthTextField intValue]+1];
				[self setBorderWidth:oTopBorderWidthTextField];
			}
			else if(theControl==oRightBorderWidthTextField)
			{
				[oRightBorderWidthTextField setIntValue:[oRightBorderWidthTextField intValue]+1];
				[self setBorderWidth:oRightBorderWidthTextField];
			}			
			else if(theControl==oBottomBorderWidthTextField)
			{
				[oBottomBorderWidthTextField setIntValue:[oBottomBorderWidthTextField intValue]+1];
				[self setBorderWidth:oBottomBorderWidthTextField];
			}
			else if(theControl==oLeftBorderWidthTextField)
			{
				[oLeftBorderWidthTextField setIntValue:[oLeftBorderWidthTextField intValue]+1];
				[self setBorderWidth:oLeftBorderWidthTextField];
			}		
		}
		return YES;
	}
	else if(theCommandSelector==@selector(moveDown:))
	{
		for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
		{
			if(theControl==oTopBorderWidthTextField)
			{
				[oTopBorderWidthTextField setIntValue:[oTopBorderWidthTextField intValue]-1];
				[self setBorderWidth:oTopBorderWidthTextField];
			}
			else if(theControl==oRightBorderWidthTextField)
			{
				[oRightBorderWidthTextField setIntValue:[oRightBorderWidthTextField intValue]-1];
				[self setBorderWidth:oRightBorderWidthTextField];
			}			
			else if(theControl==oBottomBorderWidthTextField)
			{
				[oBottomBorderWidthTextField setIntValue:[oBottomBorderWidthTextField intValue]-1];
				[self setBorderWidth:oBottomBorderWidthTextField];
			}
			else if(theControl==oLeftBorderWidthTextField)
			{
				[oLeftBorderWidthTextField setIntValue:[oLeftBorderWidthTextField intValue]-1];
			}
		}
		return YES;
	}
	else
		return NO;
}

- (BOOL)isColor:(NSColor*)theFirstColor equalTo:(NSColor*)theSecondColor
{
	CGFloat r1, g1, b1, a1;
	CGFloat r2, g2, b2, a2;
	[[theFirstColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
	[[theSecondColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
	if(		r1==r2
		&&	g1==g2
		&&	b1==b2
		&&	a1==a2)
		return YES;
	else
		return NO;
}

- (BOOL)isGradient:(NSGradient*)theFirstGradient equalTo:(NSGradient*)theSecondGradient
{
	NSInteger aNumberOfStops1 = [theFirstGradient numberOfColorStops];
	NSInteger aNumberOfStops2 = [theSecondGradient numberOfColorStops];
	
	if(aNumberOfStops1!=aNumberOfStops2)
		return NO;
	
	int i;
	for(i = 0; i < aNumberOfStops1; i++)
	{
		NSColor *	aStopColor1 = nil;	
		CGFloat		aLocation1 = 0;
		
		NSColor *	aStopColor2 = nil;
		CGFloat		aLocation2 = 0;
		
		[theFirstGradient getColor:&aStopColor1 location:&aLocation1 atIndex:i];
		[theSecondGradient getColor:&aStopColor2 location:&aLocation2 atIndex:i];
		
		if(	(	aLocation1==aLocation2
			&&	[self isColor:aStopColor1 equalTo:aStopColor2]) == NO)
		{
			return NO;
		}
	}
	return YES;
}

@end



