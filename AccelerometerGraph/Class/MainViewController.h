//
//  MainViewController .h
//  MotionGraph
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class GraphView;

@interface MainViewController : UIViewController<UIAccelerometerDelegate> {
    
	GraphView *accelerationView;
	GraphView *gravityView;
    GraphView *userAccelerationView;
    GraphView *devView;
    
	UIBarButtonItem *pause;
	BOOL isPaused;
    CMMotionManager *motionManager;
}


@property (strong, nonatomic) IBOutlet GraphView *accelerationView;
@property (strong, nonatomic) IBOutlet GraphView *gravityView;
@property (strong, nonatomic) IBOutlet GraphView *userAccelerationView;
@property (strong, nonatomic) IBOutlet GraphView *devView;

@property (strong, nonatomic) IBOutlet UILabel *adxLabel;
@property (strong, nonatomic) IBOutlet UILabel *adyLabel;
@property (strong, nonatomic) IBOutlet UILabel *adzLabel;

@property (strong, nonatomic) IBOutlet UILabel *gxLabel;
@property (strong, nonatomic) IBOutlet UILabel *gyLabel;
@property (strong, nonatomic) IBOutlet UILabel *gzLabel;

@property (strong, nonatomic) IBOutlet UILabel *uaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *uayLabel;
@property (strong, nonatomic) IBOutlet UILabel *uazLabel;

@property (strong, nonatomic) IBOutlet UILabel *guaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *guayLabel;
@property (strong, nonatomic) IBOutlet UILabel *guazLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *pause;
@property (strong, nonatomic)  CMMotionManager *motionManager;


-(IBAction)pauseOrResume:(id)sender;

@end