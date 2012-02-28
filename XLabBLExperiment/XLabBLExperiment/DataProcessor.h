//
//  DataProcessor.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 2/21/12.
//  Copyright 2012 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XLabBLExperimentAppDelegate.h"
#import "Session.h"
#import "Line.h"
#import "ExperimentBL.h"
#import "ExperimentTQ.h"

@protocol DataProcessorDelegate <NSObject>
- (void)finishedProcessing;
@end

@interface DataProcessor : NSObject {
    id <DataProcessorDelegate> delegate;
    NSManagedObjectContext *managedObjectContext;
    int currentExpID;
    int currentSessionID;
}

@property (retain) id delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (assign) int currentExpID;
@property (assign) int currentSessionID;

- (void)getExperiments;
- (BOOL)saveExperimentBL:(NSArray *)expBLArray;
- (BOOL)saveExperimentTQ:(NSArray *)expTQArray;
- (BOOL)saveLine:(NSArray *)lineArray;
- (BOOL)saveSession:(NSArray *)sessionArray;

@end
