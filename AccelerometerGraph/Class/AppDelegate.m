//
//  AppDelegate.m
//  MotionGraph
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window, viewController;

-(void)applicationDidFinishLaunching:(UIApplication*)application {
    
	[window addSubview:viewController.view];
}

-(void)dealloc {
    
    [window release];
	[viewController release];
    [super dealloc];
}

@end
