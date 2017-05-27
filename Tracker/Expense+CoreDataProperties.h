//
//  Expense+CoreDataProperties.h
//  Tracker
//
//  Created by SaTHYa on 24/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Expense.h"

NS_ASSUME_NONNULL_BEGIN

@interface Expense (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSString *categories;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
