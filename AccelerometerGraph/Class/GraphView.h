
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"

@class GraphViewSegment;
@class GraphTextView;

@interface GraphView : UIView {
    
	NSMutableArray *segments;
	GraphViewSegment *current;
	GraphTextView *text;
}

- (void)addX:(UIAccelerationValue)x y:(UIAccelerationValue)y z:(UIAccelerationValue)z;

@end
