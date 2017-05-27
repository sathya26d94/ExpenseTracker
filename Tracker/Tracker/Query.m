//
//  Query.m
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "Query.h"

#define CategoryQuery  @"categories CONTAINS[cd] %@  AND date >= %@ AND date <  %@ "

@implementation Query

#pragma mark -Sigleton method
+ (Query *)sharedInstance {
    static dispatch_once_t once;
    static Query *dataBaseDAOObject;
    dispatch_once(&once, ^{
        dataBaseDAOObject = [[self alloc] init];
    });
    return dataBaseDAOObject;
}

-(NSPredicate*)dashBoardFilterQueryForCategory:(NSString*)category startDate:(NSDate*)startDate endDate:(NSDate*)endDate {
    return [NSPredicate predicateWithFormat: CategoryQuery, category , startDate, endDate];
}

@end
