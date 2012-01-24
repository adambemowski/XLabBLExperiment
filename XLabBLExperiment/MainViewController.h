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
    IBOutlet UIActivityIndicatorView *progressIndicator;
    IBOutlet UILabel *progressLabel;
    IBOutlet UIProgressView *loadedAmountIndicator;

}

@property(nonatomic,retain) IBOutlet UIButton *getExperimentButton;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *progressIndicator;
@property(nonatomic,retain) IBOutlet UILabel *progressLabel;
@property(nonatomic,retain) IBOutlet UIProgressView *loadedAmountIndicator;

- (IBAction)showInfo:(id)sender;
- (IBAction)pressedExpButton;

@end
