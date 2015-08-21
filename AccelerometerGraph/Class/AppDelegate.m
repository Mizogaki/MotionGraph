
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
