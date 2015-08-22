//
//  GraphView.h
//  MotionGraph
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"

@class GraphViewSegment;
@class GraphTextView;

@interface GraphView : UIView {
    
	NSMutableArray *segments;
	GraphViewSegment *__weak current;
	GraphTextView *text;
}

- (void)addXLine:(UIAccelerationValue)x YLine:(UIAccelerationValue)y ZLine:(UIAccelerationValue)z;

@end
