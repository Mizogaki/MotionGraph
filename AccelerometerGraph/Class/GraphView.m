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
    // Need 33 values to fill 32 pixel width.
    UIAccelerationValue xhistory[33];
    UIAccelerationValue yhistory[33];
    UIAccelerationValue zhistory[33];
    int index;
}

@property(nonatomic, readonly) CALayer *layer;

@end

@implementation GraphViewSegment

@synthesize layer;

-(id)init
{
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

-(void)dealloc
{
    [layer release];
    [super dealloc];
}

-(void)reset
{
    // Clear out our components and reset the index to 33 to start filling values again...
    memset(xhistory, 0, sizeof(xhistory));
    memset(yhistory, 0, sizeof(yhistory));
    memset(zhistory, 0, sizeof(zhistory));
    index = 33;
    // Inform Core Animation that we need to redraw this layer.
    [layer setNeedsDisplay];
}

-(BOOL)isFull
{
    // Simple, this segment is full if there are no more space in the history.
    return index == 0;
}

-(BOOL)isVisibleInRect:(CGRect)r
{
    // Just check if there is an intersection between the layer's frame and the given rect.
    return CGRectIntersectsRect(r, layer.frame);
}

-(BOOL)addX:(UIAccelerationValue)x y:(UIAccelerationValue)y z:(UIAccelerationValue)z
{
    // If this segment is not full, then we add a new acceleration value to the history.
    if(index > 0)
    {
        // First decrement, both to get to a zero-based index and to flag one fewer position left
        --index;
        xhistory[index] = x;
        yhistory[index] = y;
        zhistory[index] = z;
        // And inform Core Animation to redraw the layer.
        [layer setNeedsDisplay];
    }
    // And return if we are now full or not (really just avoids needing to call isFull after adding a value).
    return index == 0;
}

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    // Fill in the background
    CGContextSetFillColorWithColor(context,[[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, layer.bounds);
    
    // Draw the grid lines
    DrawGraphGridlines(context, 0.0, 32.0);
    
    // Draw the graph
    CGPoint lines[64];
    int i;
    
    // X Line
    for(i = 0; i < 32; ++i)
    {
        lines[i*2].x = i;
        lines[i*2].y = -xhistory[i] * 16.0;
        lines[i*2+1].x = i + 1;
        lines[i*2+1].y = -xhistory[i+1] * 16.0;
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1.000 green:0.148 blue:0.270 alpha:1.000] CGColor]);
    CGContextStrokeLineSegments(context, lines, 64);
    
    // Y Line
    for(i = 0; i < 32; ++i)
    {
        lines[i*2].y = -yhistory[i] * 16.0;
        lines[i*2+1].y = -yhistory[i+1] * 16.0;
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.267 green:1.000 blue:0.521 alpha:1.000] CGColor]);
    CGContextStrokeLineSegments(context, lines, 64);
    
    // Z Line
    for(i = 0; i < 32; ++i)
    {
        lines[i*2].y = -zhistory[i] * 16.0;
        lines[i*2+1].y = -zhistory[i+1] * 16.0;
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.114 green:0.702 blue:1.000 alpha:1.000] CGColor]);
    CGContextStrokeLineSegments(context, lines, 64);
}

-(id)actionForLayer:(CALayer *)layer forKey :(NSString *)key
{
    // We disable all actions for the layer, so no content cross fades, no implicit animation on moves, etc.
    return [NSNull null];
}

@end

#pragma mark - GraphTextView

@interface GraphTextView : UIView
{
}

@end

@implementation GraphTextView

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Fill in the background
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, self.bounds);
    CGContextTranslateCTM(context, 0.0, 56.0);
    
    // Draw the grid lines
    DrawGraphGridlines(context, 26.0, 6.0);
    
    // Draw the text
    UIFont *systemFont = [UIFont systemFontOfSize:8.0];
    [[UIColor colorWithWhite:0.593 alpha:1.000] set];
    [@"+3.0" drawInRect:CGRectMake(2.0, -56.0, 24.0, 16.0) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    [@"+2.0" drawInRect:CGRectMake(2.0, -40.0, 24.0, 16.0) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    [@"+1.0" drawInRect:CGRectMake(2.0, -24.0, 24.0, 16.0) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    [@" 0.0" drawInRect:CGRectMake(2.0,  -8.0, 24.0, 16.0) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    [@"-1.0" drawInRect:CGRectMake(2.0,   8.0, 24.0, 16.0) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    [@"-2.0" drawInRect:CGRectMake(2.0,  24.0, 24.0, 16.0) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    [@"-3.0" drawInRect:CGRectMake(2.0,  40.0, 24.0, 16.0) withFont:systemFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
}

@end

#pragma mark - GraphView

// Finally the actual GraphView class. This class handles the public interface as well as arranging
// the subviews and sublayers to produce the intended effect.

@interface GraphView()

// Internal accessors
@property(nonatomic, retain) NSMutableArray *segments;
@property(nonatomic, assign) GraphViewSegment *current;
@property(nonatomic, assign) GraphTextView *text;

@end

@implementation GraphView

@synthesize segments, current, text;

// Designated initializer
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        [self commonInit];
    }
    return self;
}

// Designated initializer
-(id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if(self != nil)
    {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    // Create the text view and add it as a subview. We keep a weak reference
    // to that view afterwards for laying out the segment layers.
    text = [[GraphTextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 112.0)];
    [self addSubview:text];
    [text release];
    
    // Create a mutable array to store segments, which is required by -addSegment
    segments = [[NSMutableArray alloc] init];
    
    // Create a new current segment, which is required by -addX:y:z and other methods.
    // This is also a weak reference (we assume that the 'segments' array will keep the strong reference).
    current = [self addSegment];
}

-(void)dealloc
{
    // Since 'text' and 'current' are weak references, we do not release them here.
    // [super dealloc] will take care to release 'text' as a subview, and releasing 'segments' will release 'current'.
    [segments release];
    [super dealloc];
}

-(void)addX:(UIAccelerationValue)x y:(UIAccelerationValue)y z:(UIAccelerationValue)z
{
    // First, add the new acceleration value to the current segment
    if([current addX:x y:y z:z])
    {
        // If after doing that we've filled up the current segment, then we need to
        // determine the next current segment
        [self recycleSegment];
        // And to keep the graph looking continuous, we add the acceleration value to the new segment as well.
        [current addX:x y:y z:z];
    }
    // After adding a new data point, we need to advance the x-position of all the segment layers by 1 to
    // create the illusion that the graph is advancing.
    for(GraphViewSegment * s in segments)
    {
        CGPoint position = s.layer.position;
        position.x += 1.0;
        s.layer.position = position;
    }
}

-(GraphViewSegment*)addSegment {
    
    // Create a new segment and add it to the segments array.
    GraphViewSegment * segment = [[GraphViewSegment alloc] init];
    [segments insertObject:segment atIndex:0];
    [segment release];
    
    // Ensure that newly added segment layers are placed after the text view's layer so that the text view
    // always renders above the segment layer.
    [self.layer insertSublayer:segment.layer below:text.layer];
    // Position it properly (see the comment for kSegmentInitialPosition)
    segment.layer.position = CGPointMake(14.0, 56.0);
    
    return segment;
}

-(void)recycleSegment
{
    /** We start with the last object in the segments array, as it should either be visible onscreen,
     which indicates that we need more segments, or pushed offscreen which makes it eligable for recycling.*/
    
    GraphViewSegment * last = [segments lastObject];
    if([last isVisibleInRect:self.layer.bounds]){
        
        // The last segment is still visible, so create a new segment, which is now the current segment
        current = [self addSegment];
    }else{
        // The last segment is no longer visible, so we reset it in preperation to be recycled.
        [last reset];
        // Position it properly
        last.layer.position = CGPointMake(14.0, 56.0);
        // Move the segment from the last position in the array to the first position in the array
        // as it is now the youngest segment.
        [segments insertObject:last atIndex:0];
        [segments removeLastObject];
        // And make it our current segment
        current = last;
    }
}


#pragma mark - The graph view itself exists only to draw the background and gridlines.
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Fill in the background
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGFloat width = self.bounds.size.width;
    CGContextTranslateCTM(context, 0.0, 56.0);
    
    // Draw the grid lines
    DrawGraphGridlines(context, 0.0, width);
}


#pragma mark - Return an up-to-date value for the graph.
- (NSString *)accessibilityValue {
    
    if (segments.count == 0){
        return nil;
    }
    
    // Let the GraphViewSegment handle its own accessibilityValue;
    GraphViewSegment *graphViewSegment = [segments objectAtIndex:0];
    return [graphViewSegment accessibilityValue];
}

@end
