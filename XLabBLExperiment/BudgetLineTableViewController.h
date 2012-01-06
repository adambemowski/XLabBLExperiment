//
//  BudgetLineTableViewController.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 1/4/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BudgetLineTableViewControllerDelegate;

@interface BudgetLineTableViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *bltableView;
    NSString *currentMode; //experiment, session, line
    NSDictionary *headDictionary;
    int experiment;
    int session;
    int line;
}

@property (nonatomic, assign) id <BudgetLineTableViewControllerDelegate> delegate;    

@property (nonatomic, retain) IBOutlet UITableView *bltableView;
@property (nonatomic, retain) NSString *currentMode;
@property (nonatomic, retain) NSDictionary *headDictionary;
@property (nonatomic, assign) int experiment;
@property (nonatomic, assign) int session;
@property (nonatomic, assign) int line;

@end

@protocol BudgetLineTableViewControllerDelegate
- (void)BudgetLineTableViewControllerDidFinish:(BudgetLineTableViewController *)controller;
@end
