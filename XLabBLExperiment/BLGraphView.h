//
//  BLGraphView.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 1/8/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"


@interface BLGraphView : UIView {
    
    float xint;
    float yint;
    float xcenter;
    float ycenter;
    
}

@property(nonatomic,assign) float xint;
@property(nonatomic,assign) float yint;
@property(nonatomic,assign) float xcenter;
@property(nonatomic,assign) float ycenter;

- (void) refresh;

@end
