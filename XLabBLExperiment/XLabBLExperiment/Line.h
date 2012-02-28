//
//  Line.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 2/21/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Line : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * expId;
@property (nonatomic, retain) NSNumber * sessionID;
@property (nonatomic, retain) NSNumber * lineID;
@property (nonatomic, retain) NSNumber * x_int;
@property (nonatomic, retain) NSNumber * y_int;
@property (nonatomic, retain) NSString * winner;
@property (nonatomic, retain) NSNumber * sentResponse;

@end
