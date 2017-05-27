//
//  NSDate+Date.m
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate(Date)
-(NSDate *)beginningOfDay {
    return [[NSCalendar currentCalendar] startOfDayForDate:self];
}

-(NSDate *)endOfDay {
    int dayOffset = 1;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * calComponents = [cal components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [calComponents setDay:([calComponents day] + dayOffset)];
    return[cal dateFromComponents:calComponents];
}

-(NSDate *)startOfTheWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *startOfTheWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSCalendarUnitWeekOfYear
           startDate:&startOfTheWeek
            interval:&interval
             forDate:self];
    return startOfTheWeek;
}

-(NSDate *)endOfTheWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *startOfTheWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSCalendarUnitWeekOfYear
           startDate:&startOfTheWeek
            interval:&interval
             forDate:self];
    return [startOfTheWeek dateByAddingTimeInterval:interval-1];
}

-(NSDate *)startOfTheMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comp setDay:1];
    return [gregorian dateFromComponents:comp];
}

-(NSDate *)endOfTheMonth {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday| NSCalendarUnitWeekday fromDate:self];
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    return [calendar dateFromComponents:comps];
}

@end
