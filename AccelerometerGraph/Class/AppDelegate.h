//
//  AppDelegate.h
//  MotionGraph
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

@interface AppDelegate : NSObject<UIApplicationDelegate> {
    
    UIWindow *window;
	UIViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UIViewController *viewController;

@end