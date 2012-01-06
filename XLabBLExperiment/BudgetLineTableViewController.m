//
//  BudgetLineTableViewController.m
//  XLabBLExperiment
//
//  Created by ucberkeley on 1/4/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import "BudgetLineTableViewController.h"


@implementation BudgetLineTableViewController

@synthesize bltableView;
@synthesize delegate=_delegate;
@synthesize currentMode;
@synthesize headDictionary;
@synthesize experiment;
@synthesize session;
@synthesize line;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    headDictionary = [defualts objectForKey:@"BudgetLines"];
    currentMode = @"experiment";
    NSLog(@"[BLTV] viewdidload");
    [bltableView reloadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    currentMode = @"experiment";
    [bltableView reloadData];
    [super viewDidAppear:animated];
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
    
    NSString *returnstring ;
    if ([currentMode isEqualToString:@"experiment"]) {
        returnstring = @"Experiments";
    }
    if ([currentMode isEqualToString:@"session"]) {
        returnstring = @"Sessions";
    }
    if ([currentMode isEqualToString:@"line"]) {
        returnstring = @"Line";
    }
    return returnstring;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int returnnumber;
    if ([currentMode isEqualToString:@"experiment"]) {
        returnnumber = (int)[headDictionary count];
    }
    if ([currentMode isEqualToString:@"session"]) {
        returnnumber = (int)[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",experiment]] count] - 1;
    }
    if ([currentMode isEqualToString:@"line"]) {
        returnnumber = (int)[[[headDictionary objectForKey:[NSString stringWithFormat:@"experiment%i",experiment]] objectForKey:[NSString stringWithFormat:@"session%i",session]] count] - 1;
    }
    return (NSInteger)returnnumber;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([currentMode isEqualToString:@"experiment"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Experiment%i",indexPath.row+1];
    }
    if ([currentMode isEqualToString:@"session"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Session%i",indexPath.row+1];
    }
    if ([currentMode isEqualToString:@"line"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Line%i",indexPath.row+1];
    }
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([currentMode isEqualToString:@"experiment"]) {
        currentMode = @"session";
        experiment = indexPath.row +1;
    }
    else if ([currentMode isEqualToString:@"session"]) {
        currentMode = @"line";
        session = indexPath.row +1;
    }
    else if ([currentMode isEqualToString:@"line"]) {
        currentMode = @"experiment";
        line = indexPath.row +1;
        NSLog(@"Draw experiment:%i, session:%i, line:%i in the view",experiment,session,line);
        [self.delegate BudgetLineTableViewControllerDidFinish:self];
    }
    [bltableView reloadData];


}

/*
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}
*/

@end
