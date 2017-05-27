//
//  NSDate+Date.h
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Date)

-(NSDate *)beginningOfDay;
-(NSDate *)endOfDay;
-(NSDate *)startOfTheWeek;
-(NSDate *)endOfTheWeek;
-(NSDate *)startOfTheMonth;
-(NSDate *)endOfTheMonth;

@end
