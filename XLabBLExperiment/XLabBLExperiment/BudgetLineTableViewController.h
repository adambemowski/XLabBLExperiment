//
//  BudgetLineTableViewController.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 1/4/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XLabBLExperimentAppDelegate.h"
#import "ExperimentBL.h"
#import "ExperimentTQ.h"
#import "FlipsideViewController.h"

@protocol BudgetLineTableViewControllerDelegate;

@interface BudgetLineTableViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *expirmentTableView;
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *experimentList;

}

@property (nonatomic,retain) IBOutlet UITableView *expirmentTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *experimentList;

-(void)loadExperiments;

@end
