//
//  KTGradientPicker.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTGradientPicker.h"

#define kStopControlSize 12
#define kGradientRectHeight 15
#define kStopYOffset 4

@interface KTGradientPicker (Private)
- (void)makeNewStopAtLocation:(CGFloat)theLocation;
- (void)removeStopAtIndex:(NSInteger)theIndex;
- (void)moveStopAtIndex:(NSInteger)theIndex toLocation:(CGFloat)theLocation;
- (NSRect)gradientRect;
- (NSRect)rectForStopAtLocation:(CGFloat)theLocation;
@end

@implementation KTGradientPicker

@synthesize gradientValue = mGradientValue;

#pragma mark -
#pragma mark House Keeping
//=========================================================== 
// - initWithFrame:
//=========================================================== 
- (id)initWithFrame:(NSRect)theFrame
{
	if(![super initWithFrame:theFrame])
		return nil;
		
	mGradientValue = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] endingColor:[NSColor blackColor]];
	return self;
}

//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
	if (![super initWithCoder:theCoder])
		return nil;
	NSGradient * aGradientValue = [theCoder decodeObjectForKey:@"gradientValue"];
	if(aGradientValue == nil)
		aGradientValue = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] endingColor:[NSColor blackColor]];
	[self setGradientValue:aGradientValue];
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{	
	[super encodeWithCoder:theCoder];
	[theCoder encodeObject:[self gradientValue] forKey:@"gradientValue"];
}

//=========================================================== 
// - dealloc
//=========================================================== 
- (void)dealloc
{
	[mGradientValue release];
	[super dealloc];
}



#pragma mark -
#pragma mark Drawing
- (void)drawInContext:(CGContextRef)theContext
{	
	NSRect aGradientRect = [self gradientRect];	
	[mGradientValue drawInRect:aGradientRect angle:0];
	[[NSColor colorWithDeviceWhite:.6 alpha:1] set];
	[NSBezierPath strokeRect:aGradientRect];
	
	
	// stops
	NSInteger aNumberOfStops = [mGradientValue numberOfColorStops];
	NSInteger i;
	for(i = 0; i < aNumberOfStops; i++)
	{
		float		anInset = 2;
		NSRect		aStopRect;
		NSColor *	aStopColor = nil;	
		CGFloat		aLocation = 0;
		
		[mGradientValue getColor:&aStopColor location:&aLocation atIndex:i];
		aStopRect = [self rectForStopAtLocation:aLocation];
		[[NSColor colorWithDeviceWhite:.4 alpha:1] set];
		
		
		[aStopColor set];
		[NSBezierPath fillRect:NSInsetRect(aStopRect, anInset, anInset)];
		
		
		NSColor * aHighlightColor = nil;
		if(i==mActiveColorStop)
		{
			aHighlightColor = [NSColor greenColor];
		}
		else
			aHighlightColor = [NSColor colorWithDeviceWhite:.4 alpha:1];
			
		
		[aHighlightColor set];
		[NSBezierPath strokeRect:aStopRect];
		[NSBezierPath strokeRect:NSInsetRect(aStopRect, anInset, anInset)];
		CGFloat aLocationX = aGradientRect.origin.x+aGradientRect.size.width*aLocation;
		[NSBezierPath strokeLineFromPoint:NSMakePoint(aStopRect.origin.x+aStopRect.size.width*.5, aStopRect.origin.y+aStopRect.size.height)
								  toPoint:NSMakePoint(aStopRect.origin.x+aStopRect.size.width*.5, aStopRect.origin.y+aStopRect.size.height+aGradientRect.size.height+10)];
		[NSBezierPath fillRect:NSMakeRect(aLocationX-2.5, aGradientRect.origin.y+aGradientRect.size.height, 5, 5)];
	}	
}



#pragma mark -
#pragma mark Events
- (BOOL)acceptsFirstResponder
{
	return YES;
}


- (void)mouseDown:(NSEvent*)theEvent
{
	if(mIsEnabled==NO)
		return;
		
	NSPoint aMousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil]; 
	
	NSRect aGradientRect = [self gradientRect];

	
	// check gradient rect
	if(NSPointInRect(aMousePoint, aGradientRect))
	{
		// gotta convert the point so that it's in the gradient rect
		float aNewStopLocation = ((aMousePoint.x-.5-aGradientRect.origin.x)/aGradientRect.size.width);
		[self makeNewStopAtLocation:aNewStopLocation];
		return;
	}
	
	// stops
	NSInteger aNumberOfStops = [mGradientValue numberOfColorStops];
	NSInteger i;
	for(i = 0; i < aNumberOfStops; i++)
	{
		NSRect		aStopRect;
		NSColor *	aStopColor = nil;	
		CGFloat		aLocation = 0;
		[mGradientValue getColor:&aStopColor location:&aLocation atIndex:i];
		aStopRect = [self rectForStopAtLocation:aLocation];
		
		if(NSPointInRect(aMousePoint, aStopRect))
		{
			mActiveColorStop = i;
			
			if([theEvent clickCount]==2)
			{
				// throw up a color panel
				NSColorPanel * aColorPanel = [NSColorPanel sharedColorPanel];
				[aColorPanel setColor:aStopColor];
				// [aColorPanel setTarget:self];
				[aColorPanel orderFront:self];
			}
			[self setNeedsDisplay:YES];
			return;
		}
	}
	
	// didn't click on anything
	mActiveColorStop = NSNotFound;
	[self setNeedsDisplay:YES];
}



- (void)mouseDragged:(NSEvent*)theEvent
{
	if(		mActiveColorStop!=NSNotFound 
		&&  mActiveColorStop!=0
		&&	mActiveColorStop!=[mGradientValue numberOfColorStops]-1)
	{
		NSPoint aMousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil]; 
		
		CGFloat aLocationOfActiveStop;
		[mGradientValue getColor:nil location:&aLocationOfActiveStop atIndex:mActiveColorStop];
		if(		mMouseDragState == kKTGradientPickerMouseDragState_NoDrag
			&&	NSPointInRect(aMousePoint, [self rectForStopAtLocation:aLocationOfActiveStop]))
		{
			mMouseDragState = kKTGradientPickerMouseDragState_DraggingColorStop;
			
		}
		else if(mMouseDragState == kKTGradientPickerMouseDragState_DraggingColorStop)
		{
			NSRect aGradientRect = [self gradientRect];
			[self moveStopAtIndex:mActiveColorStop toLocation:((aMousePoint.x-.5-aGradientRect.origin.x)/aGradientRect.size.width)];
		}
	}
}

- (void)mouseUp:(NSEvent*)theEvent
{
	if(mMouseDragState != kKTGradientPickerMouseDragState_NoDrag)
	{
		mMouseDragState = kKTGradientPickerMouseDragState_NoDrag;
		mActiveColorStop = NSNotFound;
	}
	[self setNeedsDisplay:YES];
}



#pragma mark -
#pragma mark Manipulating the gradient
- (void)moveStopAtIndex:(NSInteger)theIndex toLocation:(CGFloat)theLocation
{
	if(		theLocation<=0 
		||	theLocation>=1)
	{
		[self removeStopAtIndex:theIndex];
	}
		
		
	NSInteger			aNumberOfStops = [mGradientValue numberOfColorStops];
	NSMutableArray *	aCurrentColorList = [[[NSMutableArray alloc] init] autorelease];
	CGFloat				aCurrentLocationList[aNumberOfStops];

	// build lists of current stops and locations
	NSInteger i;
	for(i = 0; i < aNumberOfStops; i++)
	{
		NSColor *	aStopColor = nil;	
		CGFloat		aLocation = 0;
		[mGradientValue getColor:&aStopColor location:&aLocation atIndex:i];
		[aCurrentColorList addObject:aStopColor];
		if(i==theIndex)
			aCurrentLocationList[i]=theLocation;
		else
			aCurrentLocationList[i]=aLocation;
	}
	NSGradient * aNewGradient = [[[NSGradient alloc] initWithColors:aCurrentColorList atLocations:aCurrentLocationList colorSpace:[NSColorSpace genericRGBColorSpace]]autorelease];
	[self setGradientValue:aNewGradient];
}

- (void)makeNewStopAtLocation:(CGFloat)theLocation
{
	// we'll go through out color list
	// when we get to a location larger than 'theLocation'
	// we'll insert the new color before it
	NSInteger			aNumberOfStops = [mGradientValue numberOfColorStops];
	NSMutableArray *	aCurrentColorList = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *	aNewColorList = [[[NSMutableArray alloc] init] autorelease];
	CGFloat				aCurrentLocationList[aNumberOfStops];
	CGFloat				aNewLocationList[aNumberOfStops+1];
	BOOL				aFoundSpotForNewStop = NO;
	
	// build lists of current stops and locations
	NSInteger i;
	for(i = 0; i < aNumberOfStops; i++)
	{
		NSColor *	aStopColor = nil;	
		CGFloat		aLocation = 0;
		[mGradientValue getColor:&aStopColor location:&aLocation atIndex:i];
		[aCurrentColorList addObject:aStopColor];
		aCurrentLocationList[i]=aLocation;
	}
	
	// go through the locations and find the spot to insert
	int j = 0;
	for(i = 0; i < aNumberOfStops; i++)
	{
		if(		aFoundSpotForNewStop==NO
			&&	aCurrentLocationList[i]>theLocation)
		{
			aNewLocationList[i]=theLocation;
			mActiveColorStop = i;
			[aNewColorList addObject:[NSColor whiteColor]];
			aFoundSpotForNewStop = YES;
			j++;
		}
		[aNewColorList addObject:[aCurrentColorList objectAtIndex:i]];
		aNewLocationList[i+j]=aCurrentLocationList[i];	
	}
	
	NSGradient * aNewGradient = [[[NSGradient alloc] initWithColors:aNewColorList atLocations:aNewLocationList colorSpace:[NSColorSpace genericRGBColorSpace]]autorelease];
	[self setGradientValue:aNewGradient];
}

- (void)removeStopAtIndex:(NSInteger)theIndex
{
	NSLog(@"want to remove index:%d", theIndex);
	
	NSInteger			aNumberOfStops = [mGradientValue numberOfColorStops];
	
	
	if(		theIndex<=0
		||	theIndex>=aNumberOfStops-1)
		return;
		
	
	NSMutableArray *	aColorList = [[[NSMutableArray alloc] init] autorelease];
	CGFloat				aLocationList[aNumberOfStops-1];
	
	// rebuild the list from current gradient, skipping index from argument
	NSInteger i;
	NSInteger j = 0;
	for(i = 0; i < aNumberOfStops; i++)
	{
		NSLog(@"j:%d", j);
		if(i!=theIndex)
		{
			
			NSColor *	aStopColor = nil;	
			CGFloat		aLocation = 0;
			[mGradientValue getColor:&aStopColor location:&aLocation atIndex:i];
			//NSLog(@"adding color:%@ location:%f to new index j:%d from old index i:%d",aStopColor, aLocation, j, i);
			[aColorList addObject:aStopColor];
			aLocationList[j]=aLocation;
			j++;
		}
	}
	
	NSGradient * aNewGradient = [[[NSGradient alloc] initWithColors:aColorList atLocations:aLocationList colorSpace:[NSColorSpace genericRGBColorSpace]]autorelease];
	[self setGradientValue:aNewGradient];
}

- (IBAction)changeColor:(id)theSender
{
	if(mActiveColorStop == NSNotFound)
		return;
		
	// save the current color list and locations
	// get the color from the color panel
	NSInteger			aNumberOfStops = [mGradientValue numberOfColorStops];
	NSMutableArray *	aColorList = [[NSMutableArray alloc] init];
	CGFloat				aLocationList[aNumberOfStops];
	
	NSInteger i;
	for(i = 0; i < aNumberOfStops; i++)
	{
		NSColor *	aStopColor = nil;	
		CGFloat		aLocation = 0;
		
		[mGradientValue getColor:&aStopColor location:&aLocation atIndex:i];
		if(i==mActiveColorStop)
			aStopColor = [[NSColorPanel sharedColorPanel] color];
		[aColorList addObject:aStopColor];
		aLocationList[i]=aLocation;
	}
	
	
	NSGradient * aGradient = [[[NSGradient alloc] initWithColors:aColorList atLocations:aLocationList colorSpace:[NSColorSpace genericRGBColorSpace]]autorelease];
	[self setGradientValue:aGradient];
}

- (void)setGradientValue:(NSGradient*)theGradient
{
	if(mGradientValue!=theGradient)
	{
		[mGradientValue release];
		mGradientValue = [theGradient retain];
		[self performAction];
		[self setNeedsDisplay:YES];
	}
}


#pragma mark -
#pragma mark Drawing/HitTest Rects
- (NSRect)gradientRect
{
	NSRect aViewRect = [self bounds];
	aViewRect.size.width-=2;
	aViewRect.size.height-=2;
	aViewRect.origin.x+=1.5;
	aViewRect.origin.y+=1.5;
	NSRect aGradientRect;
	aGradientRect.origin.x=aViewRect.origin.x+kStopControlSize*.5;
	aGradientRect.origin.y=aViewRect.origin.y+aViewRect.size.height-kGradientRectHeight-kStopYOffset;
	aGradientRect.size.width = aViewRect.size.width-kStopControlSize;
	aGradientRect.size.height = kGradientRectHeight;
	return aGradientRect;
}

- (NSRect)rectForStopAtLocation:(CGFloat)theLocation
{
	NSRect aStopRect;
	NSRect aGradientRect = [self gradientRect];
	aStopRect.size = NSMakeSize(kStopControlSize, kStopControlSize);
	aStopRect.origin.x = aGradientRect.origin.x+aGradientRect.size.width*theLocation;
	aStopRect.origin.x-=kStopControlSize*.5;
	aStopRect.origin.y=aGradientRect.origin.y - kStopControlSize - kStopYOffset;
	
	return aStopRect;
}



@end
