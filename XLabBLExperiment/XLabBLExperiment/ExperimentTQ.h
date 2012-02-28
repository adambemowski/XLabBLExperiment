//
//  ExperimentTQ.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 2/21/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExperimentTQ : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ID;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSNumber * sentResponse;

@end
