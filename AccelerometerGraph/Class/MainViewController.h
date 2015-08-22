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

@property (retain, nonatomic) IBOutlet GraphView *accelerationView;
@property (retain, nonatomic) IBOutlet GraphView *gravityView;
@property (retain, nonatomic) IBOutlet GraphView *userAccelerationView;
@property (retain, nonatomic) IBOutlet GraphView *devView;

@property (retain, nonatomic) IBOutlet UILabel *adxLabel;
@property (retain, nonatomic) IBOutlet UILabel *adyLabel;
@property (retain, nonatomic) IBOutlet UILabel *adzLabel;

@property (retain, nonatomic) IBOutlet UILabel *gxLabel;
@property (retain, nonatomic) IBOutlet UILabel *gyLabel;
@property (retain, nonatomic) IBOutlet UILabel *gzLabel;

@property (retain, nonatomic) IBOutlet UILabel *uaxLabel;
@property (retain, nonatomic) IBOutlet UILabel *uayLabel;
@property (retain, nonatomic) IBOutlet UILabel *uazLabel;

@property (retain, nonatomic) IBOutlet UILabel *guaxLabel;
@property (retain, nonatomic) IBOutlet UILabel *guayLabel;
@property (retain, nonatomic) IBOutlet UILabel *guazLabel;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *pause;
@property (strong, nonatomic)  CMMotionManager *motionManager;


-(IBAction)pauseOrResume:(id)sender;


@end