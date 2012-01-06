//
//  MainViewController.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 12/26/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "FlipsideViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, CLLocationManagerDelegate> {
    
    IBOutlet UIButton *getExperimentButton;

}

@property(nonatomic,retain) IBOutlet UIButton *getExperimentButton;

- (IBAction)showInfo:(id)sender;
- (IBAction)pressedExpButton;

@end
