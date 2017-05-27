//
//  MOC.h
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MOC : NSObject

typedef void (^SuccessBlock)(id responseObjects);
typedef void (^FailureBlock)(NSString* failureReason);
+ (MOC *)sharedInstance;
- (NSManagedObjectContext *)childManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;
- (void)saveMasterContext:(SuccessBlock)successBlock error:(FailureBlock)failureBlock;
- (void)saveChildContext:(SuccessBlock)successBlock error:(FailureBlock)failureBlock;

@end