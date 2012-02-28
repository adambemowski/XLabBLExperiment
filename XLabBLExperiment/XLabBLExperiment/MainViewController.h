//
//  MainViewController.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 12/26/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "FlipsideViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "XLabBLExperimentAppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSONKit.h"
#import "DataProcessor.h"
#import "BudgetLineTableViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, CLLocationManagerDelegate,DataProcessorDelegate> {
    
    UITextField *UsernameField;
	UITextField *PasswordField;
	UITextField *ConfirmPassField;
	UIButton *LoginButton;
	UIButton *CreateAccountButton;
	UILabel *topLael;
	UILabel *ConfirmPassLael;
	UILabel *createConfirmLabel;
    UILabel *versionNumber;
    DataProcessor *dataProcessor;
}

- (void)login;
- (IBAction)beginLogin:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)SendLifeCycle;

@property (nonatomic, retain) IBOutlet UITextField *UsernameField;
@property (nonatomic, retain) IBOutlet UITextField *PasswordField;
@property (nonatomic, retain) IBOutlet UITextField *ConfirmPassField;
@property (nonatomic, retain) IBOutlet UIButton *LoginButton;
@property (nonatomic, retain) IBOutlet UIButton *CreateAccountButton;
@property (nonatomic, retain) IBOutlet UILabel *topLael;
@property (nonatomic, retain) IBOutlet UILabel *ConfirmPassLael;
@property (nonatomic, retain) IBOutlet UILabel *createConfirmLabel;
@property (nonatomic, retain) IBOutlet DataProcessor *dataProcessor;
-(NSString *)md5:(NSString *)str;

@end
