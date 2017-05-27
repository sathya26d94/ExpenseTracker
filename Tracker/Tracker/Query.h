//
//  Query.h
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Query : NSObject

+ (Query *)sharedInstance;
-(NSPredicate*)dashBoardFilterQueryForCategory:(NSString*)Category startDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
