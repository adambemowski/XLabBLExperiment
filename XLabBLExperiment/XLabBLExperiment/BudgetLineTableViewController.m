//
//  BudgetLineTableViewController.m
//  XLabBLExperiment
//
//  Created by ucberkeley on 1/4/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import "BudgetLineTableViewController.h"


@implementation BudgetLineTableViewController

@synthesize expirmentTableView;
@synthesize managedObjectContext;
@synthesize experimentList;

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

- (void)loadExperiments {
    NSLog(@"[TV] retrieving BL experiment from core data");
    //setup the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];	
    // define the entity to use
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExperimentBL" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	//setpredicate to search for current experiment ID
    NSPredicate *p = [NSPredicate predicateWithFormat:@"sentResponse == %@",[NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:p];
    
	NSError *theError;
	NSMutableArray *pollResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&theError] mutableCopy];
    if (!pollResults) {
        //serious error restart the app
        NSLog(@"encountered a serious error please restart the app!");
    }
    //display data in nslog
    for (ExperimentBL *experiment in pollResults) {
        NSMutableArray *tempExp = [NSMutableArray arrayWithObjects:@"BL",experiment.title,experiment.location,experiment.ID, nil];
        [experimentList addObject:[tempExp copy]];
    }
    [fetchRequest release];
    NSLog(@"[TV] retrieving TQ experiment from core data");
    //setup the fetch request
   fetchRequest = [[NSFetchRequest alloc] init];	
    // define the entity to use
	entity = [NSEntityDescription entityForName:@"ExperimentTQ" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	//setpredicate to search for current experiment ID
    p = [NSPredicate predicateWithFormat:@"sentResponse == %@",[NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:p];
    
	pollResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&theError] mutableCopy];
    if (!pollResults) {
        //serious error restart the app
        NSLog(@"encountered a serious error please restart the app!");
    }
    //display data in nslog
    for (ExperimentBL *experiment in pollResults) {
        NSMutableArray *tempExp = [NSMutableArray arrayWithObjects:@"TQ",experiment.title,experiment.location,experiment.ID, nil];
        [experimentList addObject:[tempExp copy]];
    }
    [fetchRequest release];
    [expirmentTableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //set the managed object for core data if its not already set
    if (managedObjectContext == nil) { 
        managedObjectContext = [(XLabBLExperimentAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    experimentList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [experimentList removeAllObjects];
    [self loadExperiments];
    [expirmentTableView reloadData];
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
    return @"XLab";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [experimentList count] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == [experimentList count]) {
        cell.textLabel.text = @"Refresh Experiments";   
        cell.detailTextLabel.text = @"";
        [cell.imageView setImage:[UIImage imageNamed:@"ic_menu_refresh.png"]];
    }
    else {
        cell.textLabel.text = [[experimentList objectAtIndex:indexPath.row] objectAtIndex:1];   
        cell.detailTextLabel.text = [[experimentList objectAtIndex:indexPath.row] objectAtIndex:2];
        if ([[[experimentList objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"BL"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"ic_bl.png"]];
        }
        if ([[[experimentList objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"TQ"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"ic_tq.png"]];
        }
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
    if (indexPath.row == [experimentList count]) {
    }
    else {
        if ([[[experimentList objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"BL"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[experimentList objectAtIndex:indexPath.row] objectAtIndex:3] forKey:@"currentExpID"];
            FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
            
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:controller animated:YES];
            
            [controller release];
        }
        if ([[[experimentList objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"TQ"]) {
            //
        }
    }
}

/*
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}
*/

@end
