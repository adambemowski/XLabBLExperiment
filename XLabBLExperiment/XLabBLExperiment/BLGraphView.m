//
//  BLGraphView.m
//  XLabBLExperiment
//
//  Created by ucberkeley on 1/8/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import "BLGraphView.h"


@implementation BLGraphView

@synthesize xint;
@synthesize yint;
@synthesize xcenter;
@synthesize ycenter;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.xint = 10;
        self.yint = 10;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refresh {
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c= UIGraphicsGetCurrentContext();
    //draw y axis
    CGFloat black[4] = {0.0f,0.0f,0.0f,1.0f};
    CGFloat red[4] = {1.0f,0,0,1.0f};
    CGContextSetStrokeColor(c, black);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 50.0f, 10.0f);
    CGContextAddLineToPoint(c, 50.0f, 220.0f);
    CGContextStrokePath(c);
    //daw x axis
    CGContextSetStrokeColor(c, black);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 50.0f, 220.0f);
    CGContextAddLineToPoint(c, 300.0f, 220.0f);
    CGContextStrokePath(c);
    //daw budget line
    CGContextSetStrokeColor(c, black);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 50.0f, yint);
    CGContextAddLineToPoint(c, xint, 220);
    CGContextStrokePath(c);
    //draw circle
    if ((xint != 50) && (yint != 220)) {
        CGContextSetStrokeColor(c, red);
        CGRect circleRect = CGRectMake(xcenter -5, ycenter -5, 10, 10);
        CGContextAddEllipseInRect(c, circleRect);
        CGContextDrawPath(c, kCGPathStroke);
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end
