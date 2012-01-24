//
//  FlipsideViewController.m
//  XLabBLExperiment
//
//  Created by ucberkeley on 12/26/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate=_delegate;
@synthesize BLG;
@synthesize topNavBar;
@synthesize graphView;
@synthesize slider;
@synthesize submitButton;
@synthesize xLength;
@synthesize yLength;
@synthesize FSexperiment;
@synthesize FSsession;
@synthesize FSline;
@synthesize xUnits;
@synthesize yUnits;
@synthesize xIntercept;
@synthesize yIntercept;
@synthesize xAxisLabel;
@synthesize yAxisLabel;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)BudgetLineTableViewControllerDidFinish:(BudgetLineTableViewController *)controller
{
    // show slider and submit button
    slider.hidden = NO;
    slider.value = .5;
    submitButton.enabled = YES;
    submitButton.hidden = NO;
    //set up budget lines
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    FSexperiment = [[defaults objectForKey:@"currentExperiment"] intValue];
    FSsession = [[defaults objectForKey:@"currentSession"] intValue];
    FSline = [[defaults objectForKey:@"currentLine"] intValue];
    NSLog(@"[FSVC] setupbudgetline");
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    NSDictionary *headDictionary = [defualts objectForKey:@"BudgetLines"];
    topNavBar.title = [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"title"];
    NSNumber *xMaxFromDic = [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"xMax"];
    NSNumber *yMaxFromDic = [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"yMax"];
    NSNumber *totalMax = MAX(xMaxFromDic, yMaxFromDic);
    xIntercept = [[[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:[NSString stringWithFormat:@"session%i",FSsession]] objectForKey:[NSString stringWithFormat:@"line%i",FSline]] objectForKey:@"xIntercept"];
    yIntercept = [[[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:[NSString stringWithFormat:@"session%i",FSsession]] objectForKey:[NSString stringWithFormat:@"line%i",FSline]] objectForKey:@"yIntercept"];
    xUnits = [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"xUnits"];
    yUnits = [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"yUnits"];
    xLength = [xIntercept floatValue]/[totalMax floatValue]*200;
    yLength = [yIntercept floatValue]/[totalMax floatValue]*200;
    BLG.xint = 50.0f + xLength;
    BLG.yint = 220.0f - yLength;
    BLG.xcenter = (50.0f + xLength*.5);
    BLG.ycenter = (220.0f - yLength*.5);
    NSString *xString = [NSString stringWithFormat:@"%@ : %f", xUnits, [xIntercept floatValue]*slider.value];
    NSString *yString = [NSString stringWithFormat:@"%@ : %f", yUnits, [yIntercept floatValue]*(1-slider.value)];
    xAxisLabel.text = [xString substringToIndex:[xString length] - 4];
    yAxisLabel.text = [yString substringToIndex:[yString length] - 4];
    [BLG setNeedsDisplay];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showTable:(id)sender
{    
    NSUserDefaults *defualts= [NSUserDefaults standardUserDefaults];
    NSDictionary *headDictionary = [defualts objectForKey:@"BudgetLines"];
    if ([headDictionary objectForKey:@"experiment1"] == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No lines found"
                              message:@"go back and load experiments"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        BudgetLineTableViewController *controller = [[BudgetLineTableViewController alloc] initWithNibName:@"BudgetLineTableViewController" bundle:nil];
        controller.delegate = self;
        
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:controller animated:YES];
        
        [controller release];
    }
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *gslider = (UISlider *)sender;
    BLG.xcenter = (50.0f + xLength*gslider.value);
    BLG.ycenter = (220.0f - yLength*(1 - gslider.value));
    NSString *xString = [NSString stringWithFormat:@"%@ : %f", xUnits, [xIntercept floatValue]*gslider.value];
    NSString *yString = [NSString stringWithFormat:@"%@ : %f", yUnits, [yIntercept floatValue]*(1-gslider.value)];
    xAxisLabel.text = [xString substringToIndex:[xString length] - 4];
    yAxisLabel.text = [yString substringToIndex:[yString length] - 4];
    [BLG setNeedsDisplay];
    //NSLog(@"%f",gslider.value); //.1 to.9 values
}

- (IBAction)submitLine:(id)sender {
//    XLAB_API_ENDPOINT_BL = "http://ec2-107-20-49-145.compute-1.amazonaws.com/xlab/api/budget/"
//    
//    Log.d(TAG,Configuration.XLAB_API_ENDPOINT_BL
//          + "?bl_id=" + bl_Id + "&bl_username=" + username
//          + "&bl_lat=" + BackgroundService.getLastLat()
//          + "&bl_lon=" + BackgroundService.getLastLon()
//          + "&bl_x_intercept=" + x_int + "&bl_y_intercept=" + y_int
//          + "&bl_x=" + x_chosen + "&bl_y=" + y_chosen);
    
    //setup URL string to submit BL
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    NSDictionary *headDictionary = [defualts objectForKey:@"BudgetLines"];
    NSString *bl_Id = [NSString stringWithFormat:@"%@", [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"idnum"]];
    NSString *bl_username = @"adamxlabemulator"; //hardcoded for now
    NSString *bl_lat = [NSString stringWithFormat:@"%@", [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"lat"]];
    NSString *bl_lon = [NSString stringWithFormat:@"%@", [[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",FSexperiment]] objectForKey:@"info"] objectForKey:@"lon"]];
    NSString *x_intercept = [NSString stringWithFormat:@"%@", xIntercept];
    NSString *y_intercept = [NSString stringWithFormat:@"%@", yIntercept];
    NSString *currentX = [NSString stringWithFormat:@"%f", [xIntercept floatValue]*slider.value];
    NSString *currentY = [NSString stringWithFormat:@"%f", [yIntercept floatValue]*(1-slider.value)];
    NSString *urlString = [NSString stringWithFormat:@"http://ec2-107-20-49-145.compute-1.amazonaws.com/xlab/api/budget/?bl_id=%@&bl_username=%@&bl_lat=%@&bl_lon=%@&bl_x_intercept=%@&bl_y_intercept=%@&bl_x=%@&bl_y=%@", bl_Id, bl_username, bl_lat, bl_lon, x_intercept, y_intercept, currentX, currentY];
    NSLog(@"[FSVC] url submitted: %@", urlString);
    
    NSURLResponse *routeLoaderResponse;
	NSError *routeLoaderError;
    NSData *predictionData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60] returningResponse:&routeLoaderResponse error:&routeLoaderError];
    NSString *lineReturned = [[[NSString alloc] initWithData:predictionData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"[FSVC] submit line returned: %@", lineReturned);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    slider.hidden = YES;
    topNavBar.title = @"Please Choose Line";
    submitButton.enabled = NO;
    submitButton.hidden = YES;

    yAxisLabel.transform = CGAffineTransformMakeRotation (3.14/2);
    BLG.yint = 220;
    BLG.xint = 50;
    [BLG setNeedsDisplay];
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
