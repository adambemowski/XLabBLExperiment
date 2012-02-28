//
//  FlipsideViewController.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 12/26/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BudgetLineTableViewController.h"
#import "BLGraphView.h"
#import "ExperimentBL.h"
#import "Line.h"
#import "Session.h"
#import "XLabBLExperimentAppDelegate.h"
#import <CoreData/CoreData.h>

@class BLGraphView;

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {
    
    IBOutlet BLGraphView *BLG;
    IBOutlet UINavigationItem *topNavBar;
    UIView *graphView;
    IBOutlet UISlider *slider;
    IBOutlet UIButton *submitButton;
    float xLength;
    float yLength;
    int FSexperiment;
    int FSsession;
    int FSline;
    NSString *xUnits;
    NSString *yUnits;
    NSNumber *xIntercept;
    NSNumber *yIntercept;
    IBOutlet UILabel *xAxisLabel;
    IBOutlet UILabel *yAxisLabel;
    Line *line;
    ExperimentBL *experiment;

    NSManagedObjectContext *managedObjectContext;

}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property(nonatomic,retain) IBOutlet BLGraphView *BLG;
@property(nonatomic,retain) IBOutlet UINavigationItem *topNavBar;
@property(nonatomic,retain) UIView *graphView;
@property(nonatomic,retain) IBOutlet UISlider *slider;
@property(nonatomic,retain) IBOutlet UIButton *submitButton;
@property(nonatomic,assign) float xLength;
@property(nonatomic,assign) float yLength;
@property(nonatomic,assign) int FSexperiment;
@property(nonatomic,assign) int FSsession;
@property(nonatomic,assign) int FSline;
@property(nonatomic,retain) NSString *xUnits;
@property(nonatomic,retain) NSString *yUnits;
@property(nonatomic,retain) NSNumber *xIntercept;
@property(nonatomic,retain) NSNumber *yIntercept;
@property(nonatomic,retain) IBOutlet UILabel *xAxisLabel;
@property(nonatomic,retain) IBOutlet UILabel *yAxisLabel;
@property(nonatomic,retain) Line *line;
@property(nonatomic,retain) ExperimentBL *experiment;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)done:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)submitLine:(id)sender;
- (void)showLine;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
