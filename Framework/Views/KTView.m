//
//  KTView.m
//  KTUIKit
//
//  Created by Cathy Shive on 05/20/2008.
//
// Copyright (c) Cathy Shive
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "KTUIKit" by Cathy Shive" will do.

#import "KTView.h"

@interface KTView (Private)
@end

@implementation KTView

//=========================================================== 
// - initWithFrame:
//=========================================================== 
- (id)initWithFrame:(NSRect)theFrame
{
	if(![super initWithFrame:theFrame])
		return nil;
	
	// Layout
	KTLayoutManager * aLayoutManger = [[[KTLayoutManager alloc] initWithView:self] autorelease];
	[self setViewLayoutManager:aLayoutManger];
	[self setAutoresizesSubviews:NO];
	
	// For Debugging
	[self setLabel:@"KTView"];
	[self setBorderColor:[NSColor clearColor]];
	[self setBackgroundColor:[NSColor clearColor]];
	
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{	
	[super encodeWithCoder:theCoder];
	
	[theCoder encodeObject:[self viewLayoutManager] forKey:@"layoutManager"];
	[theCoder encodeObject:[self label] forKey:@"label"];
	[theCoder encodeObject:[self backgroundColor] forKey:@"backgroundColor"];
}

//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
	if (![super initWithCoder:theCoder])
		return nil;
		
	[self setAutoresizesSubviews:NO];
	KTLayoutManager * aLayoutManager = [theCoder decodeObjectForKey:@"layoutManager"];
	[aLayoutManager setView:self];
	[self setViewLayoutManager:aLayoutManager];
	[self setLabel:[theCoder decodeObjectForKey:@"label"]];
	[self setBackgroundColor:[theCoder decodeObjectForKey:@"backgroundColor"]];
	[self setBorderColor:[NSColor clearColor]];
	[self setAutoresizesSubviews:NO];
	[self setAutoresizingMask:NSViewNotSizable];
	return self;
}

//=========================================================== 
// - dealloc
//=========================================================== 
- (void)dealloc
{	
	// NSLog(@"%@ dealloc", [self label]);
	[mLayoutManager release];
	[mLabel release];
	[mBorderColor release];
	[super dealloc];
}


#pragma mark -
#pragma mark Drawing
//=========================================================== 
// - drawRect:
//=========================================================== 
- (void)drawRect:(NSRect)theRect
{	
	NSRect aViewBounds = [self bounds];
	[[self backgroundColor]  set];
	[NSBezierPath fillRect:aViewBounds];
	[[self borderColor] set];
	[NSBezierPath strokeRect:aViewBounds];
}


#pragma mark -
#pragma mark Layout protocol
//=========================================================== 
// - setViewLayoutManager:
//===========================================================
- (void)setViewLayoutManager:(KTLayoutManager*)theLayoutManager
{
	if(mLayoutManager != theLayoutManager)
	{
		[mLayoutManager release];
		mLayoutManager = [theLayoutManager retain];
	}
}

//=========================================================== 
// - viewLayoutManager
//===========================================================
- (KTLayoutManager*)viewLayoutManager
{
	return mLayoutManager;
}

//=========================================================== 
// - setFrame:
//===========================================================
- (void)setFrame:(NSRect)theFrame
{
	[super setFrame:theFrame];
	
	NSArray * aSubviewList = [self children];
	int aSubviewCount = [aSubviewList count];
	int i;
	for(i = 0; i < aSubviewCount; i++)
	{
		NSView * aSubview = [aSubviewList objectAtIndex:i];
		
		// if the subview conforms to the layout protocol, tell its layout
		// manager to refresh its layout
		if( [aSubview conformsToProtocol:@protocol(KTViewLayout)] )
		{
			[[(KTView*)aSubview viewLayoutManager] refreshLayout];
		}
	}
}

//=========================================================== 
// - frame
//===========================================================
- (NSRect)frame
{
	return [super frame];
}

//=========================================================== 
// - parent
//===========================================================
- (id<KTViewLayout>)parent
{
	return (id<KTViewLayout>)[super superview];
}

//=========================================================== 
// - children
//===========================================================
- (NSArray*)children
{
	return [super subviews];
}

//=========================================================== 
// - addSubview:
//===========================================================
- (void)addSubview:(NSView*)theView
{
	[super addSubview:theView];
	if(		[theView conformsToProtocol:@protocol(KTViewLayout)] == NO
		&&	[theView autoresizingMask] != NSViewNotSizable)
		[self setAutoresizesSubviews:YES];
}

#pragma mark -
#pragma mark KTView protocol
//=========================================================== 
// - setLabel:
//===========================================================
- (void)setLabel:(NSString*)theLabel
{
	if(mLabel != theLabel)
	{
		[mLabel release];
		mLabel = [[NSString alloc] initWithString:theLabel];
	}
}

//=========================================================== 
// - label
//===========================================================
- (NSString*)label
{
	return mLabel;
}


#pragma mark Temporary styles
// all styles will be kept in a style manager similar
// to the layout manager

//=========================================================== 
// - setBorderColor:
//===========================================================
- (void)setBorderColor:(NSColor*)theColor
{
	if(mBorderColor != theColor)
	{
		[mBorderColor release];
		mBorderColor = [theColor retain];
	}
}

//=========================================================== 
// - borderColor
//===========================================================
- (NSColor *)borderColor
{
	return mBorderColor;
}

//=========================================================== 
// - setBackgroundColor:
//===========================================================
- (void)setBackgroundColor:(NSColor*)theColor
{
	if(mBackgroundColor != theColor)
	{
		[mBackgroundColor release];
		mBackgroundColor = [theColor retain];
	}
}

//=========================================================== 
// - backgroundColor
//===========================================================
- (NSColor *)backgroundColor
{
	return mBackgroundColor;
}


@end
