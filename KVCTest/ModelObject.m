//
//  ModelObject.m
//  KVCTest
//
//  Created by Brandon Alexander on 9/11/11.
//  Copyright (c) 2011 While This, Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "ModelObject.h"

@interface ModelObject()
@property (retain, nonatomic) NSMutableArray *superKeys;
@end

@implementation ModelObject
@synthesize superKeys;
@synthesize simpleObject;

-(id) init {
	self = [super init];
	if(self) {
		superKeys = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(NSUInteger) countOfSuperKey {
	NSLog(@"countOfSuperKey");
	return [superKeys count];
}

- (void) insertObject:(id) obj inSuperKeyAtIndex:(NSUInteger) index {
	NSLog(@"insertObject:inSuperKeyAtIndex:");
	[superKeys insertObject:obj atIndex:index];
}

- (void) removeObjectFromSuperKeyAtIndex:(NSUInteger)index {
	NSLog(@"removeObjectFromSuperKeyAtIndex:");
	[superKeys removeObjectAtIndex:index];
}

- (id) objectInSuperKeyAtIndex:(NSUInteger) index {
	NSLog(@"objectInSuperKeyAtIndex:");
	return [superKeys objectAtIndex:index];
}

- (NSString *) description {
	return @"Hello";
}

+(BOOL) resolveInstanceMethod:(SEL)sel {
	NSLog(@"resolveInstanceMethod: %@", NSStringFromSelector(sel));
	
	return [super resolveInstanceMethod:sel];
}

-(id) forwardingTargetForSelector:(SEL)aSelector {
	NSLog(@"forwardingTargetForSelector: %@", NSStringFromSelector(aSelector));
	return [super forwardingTargetForSelector:aSelector];
}



@end
