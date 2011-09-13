//
//  ViewController.h
//  KVCTest
//
//  Created by Brandon Alexander on 9/11/11.
//  Copyright (c) 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelObject;
@interface ViewController : UIViewController

- (IBAction)swizzleMethod:(id)sender;
- (IBAction)outputSwizzler:(id)sender;
- (IBAction)crashMe:(id)sender;
- (IBAction)kvo:(id)sender;
- (IBAction)kvc:(id)sender;

@end
