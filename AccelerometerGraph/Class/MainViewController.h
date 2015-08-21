

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
@class GraphView;


@interface MainViewController : UIViewController<UIAccelerometerDelegate>
{
	GraphView *accelerationView;
	GraphView *gravityView;
    GraphView *userAccelerationView;
    GraphView *devView;
    
	UIBarButtonItem *pause;
	BOOL isPaused, useAdaptive;
    CMMotionManager *motionManager;
}

@property(nonatomic, retain) IBOutlet GraphView *accelerationView;
@property(nonatomic, retain) IBOutlet GraphView *gravityView;
@property(nonatomic, retain) IBOutlet GraphView *userAccelerationView;
@property(nonatomic, retain) IBOutlet GraphView *devView;

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

@property(nonatomic, retain) IBOutlet UIBarButtonItem *pause;
@property (strong, nonatomic)  CMMotionManager *motionManager;


-(IBAction)pauseOrResume:(id)sender;


@end