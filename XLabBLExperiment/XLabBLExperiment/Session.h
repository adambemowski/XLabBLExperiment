//
//  Session.h
//  XLabBLExperiment
//
//  Created by ucberkeley on 2/21/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Session : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * expID;
@property (nonatomic, retain) NSNumber * sessionID;
@property (nonatomic, retain) NSNumber * line_chosen;
@property (nonatomic, retain) NSNumber * sentResponse;

@end
