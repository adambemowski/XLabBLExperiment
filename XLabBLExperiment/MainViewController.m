//
//  MainViewController.m
//  XLabBLExperiment
//
//  Created by ucberkeley on 12/26/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize getExperimentButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    if((self = [super init])) {
		CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        //for region test
        NSLog(@"start monitoring for region");
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(37.872261, -122.267807);     
        CLRegion *grRegion = [[CLRegion alloc] initCircularRegionWithCenter:coordinates radius:50 identifier:[NSString stringWithFormat:@"grRegion1"]];
        
        [locationManager startMonitoringForRegion:grRegion desiredAccuracy:kCLLocationAccuracyKilometer];
        [locationManager startUpdatingLocation];
        
        [locationManager release];
        
	}
    [super viewDidLoad];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)pressedExpButton {
    NSURLResponse *routeLoaderResponse;
	NSError *routeLoaderError;
    NSData *predictionData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-107-20-49-145.compute-1.amazonaws.com/xlab/api/budget/"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60] returningResponse:&routeLoaderResponse error:&routeLoaderError];
    NSString *returnString = [[[NSString alloc] initWithData:predictionData encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"%@", returnString);
    
    //parser - may add to another file later
    NSUInteger count = 0;
    NSUInteger length = [returnString length];
    NSRange range = NSMakeRange(0, length); 
    while(range.location != NSNotFound)
    {
        range = [returnString rangeOfString: @"session_parser,1" options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    
    //DICTIONARY SETUP TO LOOK LIKE:
    //headDic (dictionary)
    //  experiment# (dictionary)
    //      info on exp (dictionary with strings, NSNumbers)
    //      session# (dictionary)
    //          info (NSNumber, NSNumber)
    //          line# (dictionary with NSNumbers)
    //          line...
    //      session...
    //  exp...
    
    //for the number of experiments
    NSMutableDictionary *headDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *experiment = [NSMutableDictionary dictionary];
    NSMutableDictionary *experimentInfo = [NSMutableDictionary dictionary];
    NSRange rangeComma1 ;
    NSRange rangeComma2 ;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    for (int i = 0; i < count; i++) {
        NSUInteger length = [returnString length];
        //experiment#
        //info on experiment
        NSNumber *idnum;
        NSString *title;
        NSString *place;
        NSNumber *lat;
        NSNumber *lon;
        NSNumber *radius;
        NSNumber *probabilistic; //1 if true, 0 if false
        NSNumber *probX; //probability of getting x
        NSString *xLabel; //x axis label
        NSString *xUnits; //units of x axis
        NSNumber *xMax;
        NSNumber *xMin;
        NSString *yLabel; //y axis label
        NSString *yUnits; //units of y axis
        NSNumber *yMax;
        NSNumber *yMin;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange(0, length-1)];
        idnum = [formatter numberFromString:[returnString substringWithRange:NSMakeRange(0, (rangeComma2.location))]];
        [experimentInfo setObject:idnum forKey:@"idnum"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        title = [returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))];
        [experimentInfo setObject:title forKey:@"title"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        place = [returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))];
        [experimentInfo setObject:place forKey:@"place"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        lat = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:lat forKey:@"lat"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        lon = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:lon forKey:@"lon"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        radius = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:radius forKey:@"radius"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        probabilistic = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:probabilistic forKey:@"probabilistic"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        probX = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:probX forKey:@"probX"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        xLabel = [returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))];
        [experimentInfo setObject:xLabel forKey:@"xLabel"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        xUnits = [returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))];
        rangeComma1 = rangeComma2;
        [experimentInfo setObject:xUnits forKey:@"xUnits"];
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        xMin = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:xMin forKey:@"xMin"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        xMax = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:xMax forKey:@"xMax"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        yLabel = [returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))];
        [experimentInfo setObject:yLabel forKey:@"yLabel"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        yUnits = [returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))];
        [experimentInfo setObject:yUnits forKey:@"yUnits"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        yMin = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:yMin forKey:@"yMin"];
        rangeComma1 = rangeComma2;
        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
        yMax = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
        [experimentInfo setObject:yMax forKey:@"yMax"];
        //add info dictionary to experiment dictionary
        [experiment setObject:[[experimentInfo copy] autorelease] forKey:@"info"];

        //sessions for exp#
        int currentSession = 1;
        int currentLine = 1;
        NSMutableDictionary *session = [NSMutableDictionary dictionary];
        NSMutableDictionary *line = [NSMutableDictionary dictionary];
        BOOL stopSessions = NO;
        BOOL stopLines = NO;
        NSRange rangeComma3;
        NSRange tempRange1;
        NSRange tempRange2;
        while (stopSessions == NO) {
            stopLines = NO;
            currentLine = 1;
            tempRange1 = rangeComma2;
            tempRange2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((tempRange1.location+1), (length-tempRange1.location - 1))];
            NSString *nextsession = [NSString string];
            if (tempRange2.location == NSNotFound) {
                nextsession = nil;
            }
            else {
                rangeComma3 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((tempRange2.location+1), (length-tempRange2.location - 1))];
                nextsession = [returnString substringWithRange:NSMakeRange((tempRange1.location+1), (rangeComma3.location - tempRange1.location - 1))];
            }
            if ([nextsession isEqualToString:[NSString stringWithFormat:@"session_parser,%i",currentSession]]) {
                rangeComma1 = tempRange1;
                rangeComma2 = tempRange2;
                //session info
                NSMutableDictionary *sessionInfo = [NSMutableDictionary dictionary];
                NSNumber *sessionNumber;
                NSNumber *chosenLine;
                rangeComma1 = rangeComma2;
                rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
                sessionNumber = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
                [sessionInfo setObject:sessionNumber forKey:@"sessionNumber"];
                rangeComma1 = rangeComma2;
                rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
                chosenLine = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
                [sessionInfo setObject:chosenLine forKey:@"chosenLine"];
                [session setObject:[[sessionInfo copy] autorelease] forKey:@"sessionInfo"];
                [sessionInfo removeAllObjects];
                //line for session #
                while (stopLines == NO) {
                    tempRange1 = rangeComma2;
                    tempRange2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((tempRange1.location+1), (length-tempRange1.location - 1))];
                    NSString *nextline = [NSString string];
                    if (tempRange2.location == NSNotFound) {
                        nextline = nil;
                    }
                    else {
                        nextline = [returnString substringWithRange:NSMakeRange((tempRange1.location+1), (tempRange2.location - tempRange1.location - 1))];
                    }
                    if ([nextline isEqualToString:@"line_parser"]) {
                        rangeComma1 = tempRange1;
                        rangeComma2 = tempRange2;
                        NSNumber *lineID;
                        NSNumber *xIntercept;
                        NSNumber *yIntercept;
                        NSString *winner;
                        rangeComma1 = rangeComma2;
                        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
                        lineID = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
                        [line setObject:lineID forKey:@"lineID"];
                        rangeComma1 = rangeComma2;
                        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
                        xIntercept = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
                        [line setObject:xIntercept forKey:@"xIntercept"];
                        rangeComma1 = rangeComma2;
                        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
                        yIntercept = [formatter numberFromString:[returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))]];
                        [line setObject:yIntercept forKey:@"yIntercept"];
                        rangeComma1 = rangeComma2;
                        rangeComma2 = [returnString rangeOfString:@"," options:0 range:NSMakeRange((rangeComma1.location+1), (length-rangeComma1.location - 1))];
                        winner = [returnString substringWithRange:NSMakeRange((rangeComma1.location+1), (rangeComma2.location - rangeComma1.location - 1))];
                        [line setObject:winner forKey:@"winner"];
                        [session setObject:[[line copy] autorelease] forKey:[NSString stringWithFormat:@"line%i",currentLine]];
                        [line removeAllObjects];
                        
                        currentLine++;
                    }
                    else {
                        stopLines = YES;
                    }
                }
                [experiment setObject:[[session copy] autorelease] forKey:[NSString stringWithFormat:@"session%i",currentSession]];
                [session removeAllObjects];
                currentSession++ ;
            }
            else {
                stopSessions = YES;
            }
        }
        //clean out dictionaries so they can be re-used
        [headDic setObject:[[experiment copy] autorelease] forKey:[NSString stringWithFormat:@"experiment%i",(i+1)]];
        [experiment removeAllObjects];
        [experimentInfo removeAllObjects];

        //concatenate returnstring
        tempRange1 = rangeComma2;
        if ((i+1) < count) {
            NSString *editedString = [returnString substringWithRange:NSMakeRange((tempRange1.location+2), (length - tempRange1.location - 2))];
            returnString = editedString;
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[headDic copy] autorelease] forKey:@"BudgetLines"];
    NSLog(@"%@", headDic);
    [formatter release];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didupdate to lacation x:%f y:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"enteredregion");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        //[self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
        NSLog(@"error occured in location manager");
    }
}

@end
