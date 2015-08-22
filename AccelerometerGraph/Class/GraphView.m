//
//  GraphViewSegment + GraphTextView + GraphView
//  MotionGraph
//
//  Created by Mizogaki Masahito on 3/19/15.
//  Copyright (c) 2015 Mizogaki Masahito. All rights reserved.
//

#import "GraphView.h"

#pragma mark - Quartz Helpers

void DrawGraphGridlines(CGContextRef context, CGFloat x, CGFloat width)
{
    for(CGFloat y = -48.5; y <= 48.5; y += 16.0)
    {
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, x + width, y);
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite:0.758 alpha:1.000] CGColor]);
    CGContextStrokePath(context);
}

#pragma mark - GraphViewSegment

@interface GraphViewSegment : NSObject {
    
    CALayer *layer;
    UIAccelerationValue xhistory[33];
    UIAccelerationValue yhistory[33];
    UIAccelerationValue zhistory[33];
    int index;
}

@property(nonatomic, readonly) CALayer *layer;

@end

@implementation GraphViewSegment

@synthesize layer;

- (instancetype)init {
    
    self = [super init];
    if(self != nil) {
        layer = [[CALayer alloc] init];
        layer.delegate = self;
        layer.bounds = CGRectMake(0.0, -56.0, 32.0, 112.0);
        layer.opaque = YES;
        index = 33;
    }
    return self;
}



- (void)reset {
    
    memset(xhistory, 0, sizeof(xhistory));
    memset(yhistory, 0, sizeof(yhistory));
    memset(zhistory, 0, sizeof(zhistory));
    index = 33;
    [layer setNeedsDisplay];
}

- (BOOL)isFull {

    return index == 0;
}

- (BOOL)isVisibleInRect:(CGRect)r {
    
    return CGRectIntersectsRect(r, layer.frame);
}

- (BOOL)addX:(UIAccelerationValue)x y:(UIAccelerationValue)y z:(UIAccelerationValue)z {
    
    if(index > 0) {

        --index;
        xhistory[index] = x;
        yhistory[index] = y;
        zhistory[index] = z;
        [layer setNeedsDisplay];
    }
    return index == 0;
}

- (void)drawLayer:(CALayer*)l inContext:(CGContextRef)context {

    CGContextSetFillColorWithColor(context,[[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, layer.bounds);
    DrawGraphGridlines(context, 0.0, 32.0);
    
    CGPoint lines[64];
    
    // X Line
    for(int i = 0; i < 32; ++i) {
        
        lines[i*2].x = i;
        lines[i*2].y = -xhistory[i] * 16.0;
        lines[i*2+1].x = i + 1;
        lines[i*2+1].y = -xhistory[i+1] * 16.0;
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1.000 green:0.148 blue:0.270 alpha:1.000] CGColor]);
    CGContextStrokeLineSegments(context, lines, 64);
    
    // Y Line
    for(int i = 0; i < 32; ++i) {
        
        lines[i*2].y = -yhistory[i] * 16.0;
        lines[i*2+1].y = -yhistory[i+1] * 16.0;
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.267 green:1.000 blue:0.521 alpha:1.000] CGColor]);
    CGContextStrokeLineSegments(context, lines, 64);
    
    // Z Line
    for(int i = 0; i < 32; ++i) {
        
        lines[i*2].y = -zhistory[i] * 16.0;
        lines[i*2+1].y = -zhistory[i+1] * 16.0;
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.114 green:0.702 blue:1.000 alpha:1.000] CGColor]);
    CGContextStrokeLineSegments(context, lines, 64);
}

- (id)actionForLayer:(CALayer *)layer forKey :(NSString *)key {
    
    return [NSNull null];
}

@end

#pragma mark - GraphTextView

@interface GraphTextView : UIView

@end

@implementation GraphTextView

#pragma mark - drowRectText - ()
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, self.bounds);
    CGContextTranslateCTM(context, 0.0, 56.0);
    DrawGraphGridlines(context, 26.0, 6.0);
    
    UIFont *systemFont = [UIFont systemFontOfSize:8.0];
    [[UIColor colorWithWhite:0.593 alpha:1.000] set];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping ;
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    [@"+3.0" drawInRect:CGRectMake(2.0, -56.0, 24.0, 16.0) withAttributes:@{NSFontAttributeName:systemFont,NSParagraphStyleAttributeName:paragraphStyle}];
    [@"+2.0" drawInRect:CGRectMake(2.0, -40.0, 24.0, 16.0) withAttributes:@{NSFontAttributeName:systemFont,NSParagraphStyleAttributeName:paragraphStyle}];
    [@"+1.0" drawInRect:CGRectMake(2.0, -24.0, 24.0, 16.0) withAttributes:@{NSFontAttributeName:systemFont,NSParagraphStyleAttributeName:paragraphStyle}];
    [@" 0.0" drawInRect:CGRectMake(2.0,  -8.0, 24.0, 16.0) withAttributes:@{NSFontAttributeName:systemFont,NSParagraphStyleAttributeName:paragraphStyle}];
    [@"-1.0" drawInRect:CGRectMake(2.0,   8.0, 24.0, 16.0) withAttributes:@{NSFontAttributeName:systemFont,NSParagraphStyleAttributeName:paragraphStyle}];
    [@"-2.0" drawInRect:CGRectMake(2.0,  24.0, 24.0, 16.0) withAttributes:@{NSFontAttributeName:systemFont,NSParagraphStyleAttributeName:paragraphStyle}];
    [@"-3.0" drawInRect:CGRectMake(2.0,  40.0, 24.0, 16.0) withAttributes:@{NSFontAttributeName:systemFont,NSParagraphStyleAttributeName:paragraphStyle}];
}

@end

#pragma mark - GraphView

@interface GraphView()

@property(nonatomic, strong) NSMutableArray *segments;
@property(nonatomic, weak) GraphViewSegment *current;
@property(nonatomic) GraphTextView *text;

@end

@implementation GraphView

@synthesize segments;
@synthesize current;
@synthesize text;


#pragma mark - initWithCoder - ()
- (instancetype)initWithCoder:(NSCoder*)decoder {
    
    self = [super initWithCoder:decoder];
    if(self != nil) {
        
        [self commonInit];
    }
    return self;
}


#pragma mark - commonInit - ()
- (void)commonInit {

    text = [[GraphTextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 112.0)];
    [self addSubview:text];
    
    segments = [[NSMutableArray alloc] init];
    current = [self addSegment];
}


#pragma mark - addXLine - YLine - ZLine - ()
- (void)addXLine:(UIAccelerationValue)x YLine:(UIAccelerationValue)y ZLine:(UIAccelerationValue)z {

    if([current addX:x y:y z:z]) {
        
        [self recycleSegment];
        [current addX:x y:y z:z];
    }

    for(GraphViewSegment * s in segments) {
        
        CGPoint position = s.layer.position;
        position.x += 1.0;
        s.layer.position = position;
    }
}


#pragma mark - addSegment - ()
- (GraphViewSegment*)addSegment {
    
    GraphViewSegment * segment = [[GraphViewSegment alloc] init];
    [segments insertObject:segment atIndex:0];
    
    [self.layer insertSublayer:segment.layer below:text.layer];
    segment.layer.position = CGPointMake(14.0, 56.0);
    return segment;
}


#pragma mark - recycleSegment - ()
- (void)recycleSegment {
    
    GraphViewSegment * last = [segments lastObject];
    if([last isVisibleInRect:self.layer.bounds]) {
        
        current = [self addSegment];
    }else{

        [last reset];
        last.layer.position = CGPointMake(14.0, 56.0);

        [segments insertObject:last atIndex:0];
        [segments removeLastObject];
        current = last;
    }
}


#pragma mark - The graph view itself exists only to draw the background and gridlines.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGContextTranslateCTM(context, 0.0, 56.0);
    DrawGraphGridlines(context, 0.0, self.bounds.size.width);
}


#pragma mark - Return an up-to-date value for the graph.
- (NSString *)accessibilityValue {
    
    if (segments.count == 0) {
        return nil;
    }
    
    GraphViewSegment *graphViewSegment = segments[0];
    return [graphViewSegment accessibilityValue];
}

@end
