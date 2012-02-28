//
//  DataProcessor.m
//  XLabBLExperiment
//
//  Created by ucberkeley on 2/21/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import "DataProcessor.h"


@implementation DataProcessor

@synthesize delegate;
@synthesize managedObjectContext;
@synthesize currentExpID;
@synthesize currentSessionID;

- (void)getExperiments {
    //set the managed object for core data if its not already set
    if (managedObjectContext == nil) { 
        managedObjectContext = [(XLabBLExperimentAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    
    NSLog(@"[DP] getting BL experiments");
    //retrieve BL experiments
    NSString *responseString = [[NSString alloc] init];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
    [request setURL:[NSURL URLWithString:@"http://ec2-107-20-49-145.compute-1.amazonaws.com/xlab/api/budget/"]];  
    NSURLResponse *trackingResponseResponse;
	NSError *trackingResponseError;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&trackingResponseResponse error:&trackingResponseError];
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    responseString = @"1,Apples or Oranges,Bongo Burger,37.8756,-122.26014,100,0,0.500000,apples,pounds,10.0,5.0,oranges,pounds,10.0,5.0,session_parser,1,1,line_parser,1,7.64079593374,7.58672084523,y,line_parser,2,9.87029881927,5.48480127736,y,line_parser,3,9.5661605926,5.48258755892,y,session_parser,2,1,line_parser,1,7.32346432598,5.18468615909,y,line_parser,2,5.75733675485,7.15576106733,y,line_parser,3,9.79165318927,8.39501839437,y,session_parser,3,1,line_parser,1,8.76279183393,5.12620507915,y,line_parser,2,9.19746983464,9.03749859372,y,line_parser,3,7.26269292476,9.72043068541,y,\n3,Risk/Reward,Caffe Strada,37.8692,-122.2547,100,1,0.500000,,dollars,100.0,50.0,,dollars,100.0,50.0,session_parser,1,1,line_parser,1,73.606823608,64.3398057222,y,line_parser,2,70.5110583621,55.9175627895,y,line_parser,3,59.0713242452,99.9885236597,y,session_parser,2,0,line_parser,1,70.1252987124,68.7264527864,y,line_parser,2,84.5820538995,51.2101890345,y,line_parser,3,56.5000891385,54.9220178812,y,session_parser,3,0,line_parser,1,76.3824563332,61.8374918251,y,line_parser,2,77.0862918963,53.054412673,y,line_parser,3,92.3161335287,76.6183202663,y,";
    NSArray *expArray = [responseString componentsSeparatedByString:@",\n"];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];    
    for (int i = 0; i < [expArray count]; i++) {
        //split array
        NSArray *singleExpArray = [[expArray objectAtIndex:i] componentsSeparatedByString:@","];
        currentExpID = [[formatter numberFromString:[singleExpArray objectAtIndex:0]] intValue];
        //reconstruct string to split array again
        NSArray *sessionArray = [[expArray objectAtIndex:i] componentsSeparatedByString:@",session_parser,"];
        //session part
        if ([self saveExperimentBL:singleExpArray]) {
            for (int j = 1; j < [sessionArray count]; j++) {
                NSArray *lineArray = [[sessionArray objectAtIndex:j] componentsSeparatedByString:@",line_parser,"];
                NSArray *tempSession = [[lineArray objectAtIndex:0] componentsSeparatedByString:@","];
                currentSessionID = [[formatter numberFromString:[tempSession objectAtIndex:0]] intValue];
                [self saveSession:tempSession];
                for (int k = 1; k < [lineArray count]; k++) {
                    NSArray *singleLine = [[lineArray objectAtIndex:k] componentsSeparatedByString:@","];
                    [self saveLine:singleLine];
                }
            }
        }
    }
    //retrieve TQ experiments
	NSLog(@"[DP] getting TQ experiments");
    [request setURL:[NSURL URLWithString:@"http://ec2-107-20-49-145.compute-1.amazonaws.com/xlab/api/text/"]];  
	responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&trackingResponseResponse error:&trackingResponseError];
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSArray *expTQArray = [responseString componentsSeparatedByString:@",\n"]; 
    for (int m = 0; m < [expTQArray count]; m++) {
        NSArray *singleTQ = [[expTQArray objectAtIndex:m] componentsSeparatedByString:@","];
        [self saveExperimentTQ:singleTQ];
    }
    [formatter release];
    [delegate finishedProcessing];
}

- (BOOL)saveExperimentBL:(NSArray *)expBLArray{
    //return no if expBL doesn't hold enough object (in case I messed up the parsing code)
    if ([expBLArray count] < 16) {
        return NO;
    }
    // also return NO if currentID matches and ID already saved, return yes and save experiment in core data otherwise
    
    //SEARCH CORE DATA using predicate
    //setup the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];	
    // define the entity to use
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExperimentBL" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	//setpredicate to search for current experiment ID
    NSPredicate *p = [NSPredicate predicateWithFormat:@"ID == %i",currentExpID];
    [fetchRequest setPredicate:p];
    
	NSError *theError;
	NSMutableArray *pollResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&theError] mutableCopy];
    if (!pollResults) {
        //serious error restart the app
        NSLog(@"encountered a serious error please restart the app!");
    }
    [fetchRequest release];
    
    if ([pollResults count] == 0) {
        //save to core data
        //step 1 - create pollData object
        ExperimentBL *newExperiment = (ExperimentBL *)[NSEntityDescription insertNewObjectForEntityForName:@"ExperimentBL" inManagedObjectContext:managedObjectContext];
        //step 2 - set the properties
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [newExperiment setID:[formatter numberFromString:[expBLArray objectAtIndex:0]]];
        [newExperiment setTitle:[expBLArray objectAtIndex:1]];
        [newExperiment setLocation:[expBLArray objectAtIndex:2]];
        [newExperiment setLat:[formatter numberFromString:[expBLArray objectAtIndex:3]]];
        [newExperiment setLon:[formatter numberFromString:[expBLArray objectAtIndex:4]]];
        [newExperiment setRadius:[formatter numberFromString:[expBLArray objectAtIndex:5]]];
        [newExperiment setProbabilistic:[formatter numberFromString:[expBLArray objectAtIndex:6]]];
        [newExperiment setProb_x:[formatter numberFromString:[expBLArray objectAtIndex:7]]];
        [newExperiment setX_label:[expBLArray objectAtIndex:8]];
        [newExperiment setX_units:[expBLArray objectAtIndex:9]];
        [newExperiment setX_max:[formatter numberFromString:[expBLArray objectAtIndex:10]]];
        [newExperiment setX_min:[formatter numberFromString:[expBLArray objectAtIndex:11]]];
        [newExperiment setY_label:[expBLArray objectAtIndex:12]];
        [newExperiment setY_units:[expBLArray objectAtIndex:13]];
        [newExperiment setY_max:[formatter numberFromString:[expBLArray objectAtIndex:14]]];
        [newExperiment setY_min:[formatter numberFromString:[expBLArray objectAtIndex:15]]];
        [newExperiment setSentResponse:[NSNumber numberWithBool:NO]];
        [formatter release];
        //step 3 - save data
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
            exit(-1);
        }
        return YES;
    }
    else {
        return NO;
    }
    
    return NO;
}

- (BOOL)saveExperimentTQ:(NSArray *)expTQArray{
    //return no if linearray doesn't hold enough objects to keep app from crashing
    if ([expTQArray count] < 6) {
        return NO;
    }
    
    // also return NO if currentID matches and ID already saved, return yes and save experiment in core data otherwise
    
    //SEARCH CORE DATA using predicate
    //setup the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];	
    // define the entity to use
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExperimentTQ" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	//setpredicate to search for current experiment ID
    NSNumberFormatter * formatter1 = [[NSNumberFormatter alloc] init];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"ID == %@",[formatter1 numberFromString:[expTQArray objectAtIndex:0]]];
    [formatter1 release];
    [fetchRequest setPredicate:p];
    
	NSError *theError;
	NSMutableArray *pollResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&theError] mutableCopy];
    if (!pollResults) {
        //serious error restart the app
        NSLog(@"encountered a serious error please restart the app!");
    }
    [fetchRequest release];
    
    if ([pollResults count] == 0) {
        //save to core data
        //step 1 - create pollData object
        ExperimentTQ *newexpTQ = (ExperimentTQ *)[NSEntityDescription insertNewObjectForEntityForName:@"ExperimentTQ" inManagedObjectContext:managedObjectContext];
        //step 2 - set the properties
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [newexpTQ setID:[formatter numberFromString:[expTQArray objectAtIndex:0]]];
        [newexpTQ setLocation:[expTQArray objectAtIndex:1]];
        [newexpTQ setLat:[formatter numberFromString:[expTQArray objectAtIndex:2]]];
        [newexpTQ setLon:[formatter numberFromString:[expTQArray objectAtIndex:3]]];
        [newexpTQ setRadius:[formatter numberFromString:[expTQArray objectAtIndex:4]]];
        [newexpTQ setTitle:[expTQArray objectAtIndex:5]];
        [newexpTQ setAnswer:@""];
        [newexpTQ setSentResponse:[NSNumber numberWithBool:NO]];
        [formatter release];
        //step 3 - save data
        NSLog(@"TQ saved: %@ , %@", newexpTQ.ID, newexpTQ.title);
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
            exit(-1);
        }
        return YES;
    }
    else { 
        return NO;
    }
    
}

- (BOOL)saveLine:(NSArray *)lineArray{
    //return no if linearray doesn't hold enough objects to keep app from crashing
    if ([lineArray count] < 4) {
        return NO;
    }
    
    //save to core data
    //step 1 - create pollData object
    Line *newLine = (Line *)[NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:managedObjectContext];
    //step 2 - set the properties
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [newLine setExpId:[NSNumber numberWithInt:currentExpID]];
    [newLine setSessionID:[NSNumber numberWithInt:currentSessionID]];
    [newLine setLineID:[formatter numberFromString:[lineArray objectAtIndex:0]]];
    [newLine setX_int:[formatter numberFromString:[lineArray objectAtIndex:1]]];
    [newLine setY_int:[formatter numberFromString:[lineArray objectAtIndex:2]]];
    [newLine setWinner:[lineArray objectAtIndex:3]];
    [newLine setSentResponse:0];
    [formatter release];
    //step 3 - save data
    NSLog(@"saved line - id:%@ xint:%@ yint:%@ winner:%@", newLine.lineID, newLine.x_int, newLine.y_int, newLine.winner);
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    return YES;
}

- (BOOL)saveSession:(NSArray *)sessionArray{
    //return no if sessionArray doesn't hold enough objects to keep app from crashing
    if ([sessionArray count] < 2) {
        return NO;
    }
    
    //save to core data
    //step 1 - create pollData object
    Session *newSession = (Session *)[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:managedObjectContext];
    //step 2 - set the properties
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [newSession setSessionID:[formatter numberFromString:[sessionArray objectAtIndex:0]]];
    [newSession setLine_chosen:[formatter numberFromString:[sessionArray objectAtIndex:1]]];
    [newSession setSentResponse:0];
    [formatter release];
    //step 3 - save data
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    return YES;
}

@end
