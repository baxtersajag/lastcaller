//
//  Records.h
//  lastcalled
//
//  Created by David Geijer on 26/05/14.
//  Copyright (c) 2014 Witch Craft International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Records : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;

@end
