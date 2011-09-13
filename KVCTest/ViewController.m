//
//  ViewController.m
//  KVCTest
//
//  Created by Brandon Alexander on 9/11/11.
//  Copyright (c) 2011 While This, Inc. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"
#import "ModelObject.h"
#import "SwizzleClass.h"

static void PrintDescription(NSString *name, id obj)
{
	NSString *str = [NSString stringWithFormat:
					 @"%@: %@\n\tNSObject class %s\n\tlibobjc class %s",
					 name,
					 obj,
					 class_getName([obj class]),
					 class_getName(obj->isa)];
	printf("%s\n", [str UTF8String]);
}

// Pulled this from: http://mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
static void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL) {
	Method origMethod = class_getInstanceMethod(c, origSEL);
	Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
	
	if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
		class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
	} else {
		method_exchangeImplementations(origMethod, overrideMethod);
	}
}

@interface SwizzleClass(SwizzleCategory) 

- (NSString *) mySwizzledImplementation;

@end

@implementation SwizzleClass(SwizzleCategory)

- (NSString *) mySwizzledImplementation {
	if([NSStringFromSelector(_cmd) isEqualToString:@"mySwizzledImplementation"]) {
		return @"mySwizzledImplementation";
	}
	
	NSString *string = [NSString stringWithFormat:@"I'm in your IMPs, swizzlling your methods\n%@", [self mySwizzledImplementation]];
	
	return string;
}


@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//void viewDidLoadIMP(id self, SEL _cmd)
- (void)viewDidLoad
{	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)kvc:(id)sender {
	NSLog(@"======================================================");
	ModelObject *model = [[ModelObject alloc] init];
	
	NSMutableArray *array = [model mutableArrayValueForKey:@"superKey"];
	NSLog(@"==>Inserting an object");
	//insertObject:inSuperKeyAtIndex:
	[array insertObject:[NSNull null] atIndex:0];
	
	NSLog(@"==>Getting array count");
	//countOfSuperKey
	NSLog(@"Array count: %i", [array count]);
	
	NSLog(@"==>Fetching an object");
	//objectInSuperKeyAtIndex:
	NSLog(@"Object at index 0: %@", [array objectAtIndex:0]);
	
	NSLog(@"==>Removing an object");
	//removeObjectFromSuperKeyAtIndex:
	[array removeObjectAtIndex:0];
	NSLog(@"======================================================");
}




- (IBAction)crashMe:(id)sender {
	NSLog(@"======================================================");
	ModelObject *model = [[ModelObject alloc] init];
	[model performSelector:@selector(someSelectorThatDoesntExist:)];
	NSLog(@"======================================================");
}




- (IBAction)kvo:(id)sender {
	NSLog(@"======================================================");
	ModelObject *model = [[ModelObject alloc] init];
	
	PrintDescription(@"model", model);
	
	[model addObserver:self forKeyPath:@"simpleObject" options:NSKeyValueObservingOptionNew context:NULL];
	
	PrintDescription(@"model", model);
	
	[model setSimpleObject:@"HELLO!"];
	NSLog(@"======================================================");
}

- (void) observeValueForKeyPath:(NSString *)keyPath 
					   ofObject:(id)object 
						 change:(NSDictionary *)change 
						context:(void *)context {
	//Code here...
	NSLog(@"I'm observing a change!!!");
}




- (IBAction)swizzleMethod:(id)sender {	
	MethodSwizzle([SwizzleClass class], @selector(methodToSwizzle), @selector(mySwizzledImplementation));
}




- (IBAction)outputSwizzler:(id)sender {
	NSLog(@"======================================================");
	SwizzleClass *swizzler = [[SwizzleClass alloc] init];
	
	CFTimeInterval startTime = CACurrentMediaTime();
	NSLog(@"methodToSwizzle: %@", [swizzler methodToSwizzle]);
	NSLog(@"mySwizzledImplementation: %@", [swizzler mySwizzledImplementation]);
	
	CFTimeInterval endTime = CACurrentMediaTime();
	CFTimeInterval interval = (endTime - startTime) * 1000;
	NSLog(@"---\nTime taken: %1.0f", interval);
	NSLog(@"======================================================");
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
