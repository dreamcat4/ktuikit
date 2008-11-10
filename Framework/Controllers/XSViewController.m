//
//  XSViewController.m
//  View Controllers
//
//  Created by Jonathan Dann and Cathy Shive on 14/04/2008.
//
// Copyright (c) 2008 Jonathan Dann and Cathy Shive
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
// For example, "Contains "View Conrtollers" by Jonathan Dann and Cathy Shive" will do.


/*
	(Cathy 11/10/08) NOTE:
	I've made the following changes that need to be documented:
	• When a child is removed, its view is removed from its superview and it is sent a "removeObservations" message
	• Added 'removeChild:(XSViewController*)theChild' method to remove specific subcontrollers
	• Added 'loadNibNamed' and 'releaseNibObjects' to support loading more than one nib per view controller.  These take care
	of releasing the top level nib objects for those nib files. Users have to unbind any bindings in those nibs in the view
	controller's removeObservations method.
	• Added class method, 'viewControllerWithWindowController'
	• I'm considering overriding 'view' and 'setView:' so that the view controller only deals with KTViews.
*/


#import "XSViewController.h"
#import "XSWindowController.h"

#pragma mark Private API

@interface XSViewController (Private)
// This method is made private so users of the class can't (easily) set the children array whenever they want, they must use the indexed accessors provided. If this was public then our methods that mantain the responder chain and pass the represented object and window controller to the children would be subverted. Alternatively the setter could set all the required variables on the objects in the newChildren array, but the API then becomes a little clunkier.
- (void)setChildren:(NSMutableArray *)newChildren;
- (void)releaseNibObjects;
@end

@implementation XSViewController (Private)
- (void)setChildren:(NSMutableArray *)newChildren;
{
	if (_children == newChildren)
		return;
	NSMutableArray *newChildrenCopy = [newChildren mutableCopy];
	[_children release];
	_children = newChildrenCopy;
}

- (void)releaseNibObjects
{
	int i;
	for( i = 0; i < [_topLevelNibObjects count]; i++)
	{
		[[_topLevelNibObjects objectAtIndex:i] release];
	}
	[_topLevelNibObjects release];
}

@end
 
#pragma mark -
#pragma mark Public API

@implementation XSViewController
+ (id)viewControllerWithWindowController:(XSWindowController*)theWindowController
{
	return [[[self alloc] initWithNibName:nil bundle:nil windowController:theWindowController] autorelease];
}

#pragma mark Accessors

@synthesize parent = _parent;
@synthesize windowController = _windowController;
@synthesize children = _children;
//- (NSView<KTViewLayout>*)view
//{
//	return (NSView<KTViewLayout>*)[super view];
//}
//- (void)setView:(NSView<KTViewLayout>*)theView
//{
//	[super setView:theView];
//}
#pragma mark Designated Initialiser

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle windowController:(XSWindowController *)windowController;
{
	if (![super initWithNibName:name bundle:bundle])
		return nil;
	self.windowController = windowController; // non-retained to avoid retain cycles
	self.children = [NSMutableArray array]; // set up a blank mutable array
	_topLevelNibObjects = [[NSMutableArray alloc] init];
	return self;
}

// ---------------------------------
// This is the NSViewController's designated initialiser, which we override to call our own. Any subclasses that call this will then set up our intance variables properly.
// ---------------------------------
- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle;
{
	[NSException raise:@"XSViewControllerException" format:[NSString stringWithFormat:@"An instance of an XSViewController concrete subclass was initialized using the NSViewController method -initWithNibName:bundle: all view controllers in the enusing tree will have no reference to an XSWindowController object and cannot be automatically added to the responder chain"]];
	return nil;
}

- (void)dealloc;
{
	// NSLog(@"%@ dealloc", self);
	[self releaseNibObjects];
	[self.children release];
	[super dealloc];
}

#pragma mark Indexed Accessors

- (NSUInteger)countOfChildren;
{
	return [self.children count];
}

- (XSViewController *)objectInChildrenAtIndex:(NSUInteger)index;
{
	return [self.children objectAtIndex:index];
}

// ------------------------------------------
// This will add a new XSViewController subclass to the end of the children array.
// ------------------------------------------
- (void)addChild:(XSViewController *)viewController;
{
	[self insertObject:viewController inChildrenAtIndex:[self.children count]];
}

- (void)removeChild:(XSViewController *)viewController;
{
	[[viewController view] removeFromSuperview];
	[viewController removeObservations];
	[self.children removeObject:viewController];
	[self.windowController patchResponderChain];
}

- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index;
{
	XSViewController *	aChildToRemove = [self.children objectAtIndex:index];
	[[aChildToRemove view] removeFromSuperview];
	[aChildToRemove removeObservations];
	[self.children removeObjectAtIndex:index];
	[(XSWindowController *)self.windowController patchResponderChain]; // each time a controller is removed then the repsonder chain needs fixing
}

- (void)insertObject:(XSViewController *)viewController inChildrenAtIndex:(NSUInteger)index;
{
	[self.children insertObject:viewController atIndex:index];
	[viewController setParent:self];
	[self.windowController patchResponderChain];
}

- (void)insertObjects:(NSArray *)viewControllers inChildrenAtIndexes:(NSIndexSet *)indexes;
{
	[self.children insertObjects:viewControllers atIndexes:indexes];
	[viewControllers makeObjectsPerformSelector:@selector(setParent:) withObject:self];
	[self.windowController patchResponderChain]; 
}

- (void)insertObjects:(NSArray *)viewControllers inChildrenAtIndex:(NSUInteger)index;
{
	[self insertObjects:viewControllers inChildrenAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

# pragma mark Utilities

// ------------------------------------------
// This method is not used in the example but does demonstrates an important point of our setup: the root controller in the tree should have parent = nil.  If you'd rather set the parent of the root node to the window controller, this method must be modified to check the class of the parent object.
// ------------------------------------------
- (XSViewController *)rootController;
{
	XSViewController *root = self.parent;
	if (!root) // we are the top of the tree
		return self;
	while (root.parent) // if this is nil then there is no parent, the whole system is based on the idea that the top of the tree has nil parent, not the windowController as its parent.
		root = root.parent;
	return root;
}

// ---------------------------------------
// A top-down tree sorting method.  Recursively calls itself to build up an array of all the nodes in the tree. If one thinks of a file and folder setup, then this would add all the contents of a folder to the array (ad infinitum) to the array before moving on to the next folder at the same level
// ----------------------------------------
- (NSArray *)descendants;
{
	NSMutableArray *array = [NSMutableArray array];
	for (XSViewController *child in self.children) {
		[array addObject:child];
		if ([child countOfChildren] > 0)
			[array addObjectsFromArray:[child descendants]];
	}
	return [[array copy] autorelease]; // return an immutable array
}

// --------------------------------------
// Any manual KVO or bindings that you have set up (other than to the representedObject) should be removed in this method.  It is called by the window controller on in the -windowWillClose: method.  After this the window controller can safely call -dealloc without any warnings that it is being deallocated while observers are still registered.
// --------------------------------------
- (void)removeObservations
{
	[self.children makeObjectsPerformSelector:@selector(removeObservations)];
}

// --------------------------------------
// Load any extra nib files (not loaded through the initializer) using this method.  It will add the nib's objects to a list and they will be released during dealloc
// --------------------------------------
- (BOOL)loadNibNamed:(NSString*)theNibName bundle:(NSBundle*)theBundle
{
	BOOL		aSuccess;
	NSArray *	anObjectList = nil;
	NSNib *		aNib = [[[NSNib alloc] initWithNibNamed:theNibName bundle:theBundle] autorelease];
	aSuccess = [aNib instantiateNibWithOwner:self topLevelObjects:&anObjectList];
	if(aSuccess)
	{
		int i;
		for(i = 0; i < [anObjectList count]; i++)
			[_topLevelNibObjects addObject:[anObjectList objectAtIndex:i]];
	}
	return aSuccess;
}

@end
