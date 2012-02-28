//
//  ExperimentBL.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 2/26/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExperimentBL : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * ID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSNumber * probabilistic;
@property (nonatomic, retain) NSNumber * prob_x;
@property (nonatomic, retain) NSString * x_label;
@property (nonatomic, retain) NSString * x_units;
@property (nonatomic, retain) NSNumber * x_max;
@property (nonatomic, retain) NSNumber * x_min;
@property (nonatomic, retain) NSString * y_label;
@property (nonatomic, retain) NSString * y_units;
@property (nonatomic, retain) NSNumber * y_max;
@property (nonatomic, retain) NSNumber * y_min;
@property (nonatomic, retain) NSNumber * sentResponse;
@property (nonatomic, retain) NSString * location;

@end
