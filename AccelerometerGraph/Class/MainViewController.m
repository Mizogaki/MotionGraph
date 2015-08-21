

#import "MainViewController.h"
#import "GraphView.h"

#define kUpdateFrequency	60.0

@interface MainViewController()

@end

@implementation MainViewController

@synthesize accelerationView;
@synthesize gravityView;
@synthesize userAccelerationView;
@synthesize devView;
@synthesize pause;
@synthesize motionManager;


-(void)viewDidLoad
{
	[super viewDidLoad];
	pause.possibleTitles = [NSSet setWithObjects:@"Pause", @"Resume", nil];
	isPaused = NO;
	useAdaptive = NO;
    [self metodoAcelerometro];
    
    //CMAccelerometerData
	[accelerationView setIsAccessibilityElement:YES];
	[gravityView setIsAccessibilityElement:YES];
    [userAccelerationView setIsAccessibilityElement:YES];
    [devView setIsAccessibilityElement:YES];
    

}
- (void)metodoAcelerometro {
    
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager setDeviceMotionUpdateInterval:1/5000];
  
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isPaused) {

                [accelerationView addX:accelerometerData.acceleration.x y:accelerometerData.acceleration.y z:accelerometerData.acceleration.z];
                self.adxLabel.text = [NSString stringWithFormat:@"%f",accelerometerData.acceleration.x];
                self.adyLabel.text = [NSString stringWithFormat:@"%f",accelerometerData.acceleration.y];
                self.adzLabel.text = [NSString stringWithFormat:@"%f",accelerometerData.acceleration.z];
            }
            
        });
    }];
    
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager setDeviceMotionUpdateInterval:1/5];
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMDeviceMotion *deviceMotionData, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isPaused) {
                
                [gravityView addX:deviceMotionData.gravity.x  y:deviceMotionData.gravity.y z:deviceMotionData.gravity.z];
                [userAccelerationView addX:deviceMotionData.userAcceleration.x  y:deviceMotionData.userAcceleration.y z:deviceMotionData.userAcceleration.z];
                [devView addX:(deviceMotionData.gravity.x + deviceMotionData.userAcceleration.x)
                            y:(deviceMotionData.gravity.y + deviceMotionData.userAcceleration.y)
                            z:(deviceMotionData.gravity.z + deviceMotionData.userAcceleration.z)];
                
                self.gxLabel.text = [NSString stringWithFormat:@"%f",deviceMotionData.gravity.x];
                self.gyLabel.text = [NSString stringWithFormat:@"%f",deviceMotionData.gravity.y];
                self.gzLabel.text = [NSString stringWithFormat:@"%f",deviceMotionData.gravity.z];
                
                self.uaxLabel.text = [NSString stringWithFormat:@"%f",deviceMotionData.userAcceleration.x];
                self.uayLabel.text = [NSString stringWithFormat:@"%f",deviceMotionData.userAcceleration.y];
                self.uazLabel.text = [NSString stringWithFormat:@"%f",deviceMotionData.userAcceleration.z];
                
                self.guaxLabel.text = [NSString stringWithFormat:@"%f",(deviceMotionData.gravity.x + deviceMotionData.userAcceleration.x)];
                self.guayLabel.text = [NSString stringWithFormat:@"%f",(deviceMotionData.gravity.y + deviceMotionData.userAcceleration.y)];
                self.guazLabel.text = [NSString stringWithFormat:@"%f",(deviceMotionData.gravity.z + deviceMotionData.userAcceleration.z)];
                
            }
            
        });
    }];
}

-(void)viewDidUnload {
    
	[super viewDidUnload];
	self.accelerationView = nil;
	self.gravityView = nil;
    self.userAccelerationView = nil;
	self.pause = nil;
}


-(IBAction)pauseOrResume:(id)sender
{
	if(isPaused){
		isPaused = NO;
		pause.title = @"Pause";
	}else{

		isPaused = YES;
		pause.title = @"Resume";
	}
	
	// Inform accessibility clients that the pause/resume button has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

-(void)dealloc {
    
	[accelerationView release];
	[gravityView release];
    [userAccelerationView release];
	[pause release];
    [devView release];
    [_adxLabel release];
    [_adyLabel release];
    [_adzLabel release];
    [_gyLabel release];
	[super dealloc];
}


@end