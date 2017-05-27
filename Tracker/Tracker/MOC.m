//
//  MOC.m
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "MOC.h"

@interface MOC()
@property(strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property(strong, nonatomic) NSManagedObjectContext *childManagedObjectContext;
@property(strong, nonatomic) NSManagedObjectContext *child2ManagedObjectContext;
@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(readonly, copy) NSDictionary *managedObjectModelEntities;
@end


@implementation MOC

@synthesize masterManagedObjectContext = _masterManagedObjectContext;
@synthesize childManagedObjectContext = _childManagedObjectContext;
@synthesize child2ManagedObjectContext = _child2ManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark -Sigleton method
+ (MOC *)sharedInstance {
    static dispatch_once_t once;
    static MOC *dataBaseDAOObject;
    dispatch_once(&once, ^{
        dataBaseDAOObject = [[self alloc] init];
    });
    return dataBaseDAOObject;
}

#pragma mark -class initialization method
- (id)init {
    self = [super init];
    return self;
}

#pragma mark -Public methods
- (NSManagedObjectContext *)masterManagedObjectContext {
    if (_masterManagedObjectContext != nil) {
        return _masterManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_masterManagedObjectContext performBlockAndWait:^{
            [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
        }];
    }
    return _masterManagedObjectContext;
}

- (NSManagedObjectContext *) childManagedObjectContext {
    if (_childManagedObjectContext != nil) {
        return _childManagedObjectContext;
    }
    _childManagedObjectContext = [self newManagedObjectContext];
    return _childManagedObjectContext;
}

- (NSManagedObjectContext *)newManagedObjectContext {
    NSManagedObjectContext *newContext = nil;
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil) {
        newContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [newContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [newContext performBlockAndWait:^{
            [newContext setParentContext:masterContext];
        }];
    }
    return newContext;
}

- (void)saveMasterContext:(SuccessBlock)successBlock error:(FailureBlock)failureBlock {
    [self.masterManagedObjectContext performBlock:^{
        NSError *error = nil;
        [self.masterManagedObjectContext save:&error];
        if (error) {
            failureBlock([error localizedDescription]);
        }else {
            successBlock(@"Success");
        }
    }];
}

- (void)saveChildContext:(SuccessBlock)successBlock error:(FailureBlock)failureBlock {
    [self saveContextAndMasterContext:self.childManagedObjectContext success:^(id responseObjects) {
        successBlock(@"Success");
    } error:^(NSString *failureReason) {
        failureBlock(failureReason);
    }];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *managedObjectModelUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"Tracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:managedObjectModelUrl];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [self addPersistentStore];
    return _persistentStoreCoordinator;
}


- (void)saveContext:(NSManagedObjectContext*)managedObjectContext  success:(SuccessBlock)successBlock error:(FailureBlock)failureBlock {
    [managedObjectContext performBlock:^{
        NSError *error = nil;
        [managedObjectContext save:&error];
        if (error) {
            failureBlock([error localizedDescription]);
        }else {
            successBlock(@"success");
        }
    }];
}

- (void)saveContextAndMasterContext:(NSManagedObjectContext*)managedObjectContext success:(SuccessBlock)successBlock error:(FailureBlock)failureBlock {
    [self saveContext:managedObjectContext success:^(id responseObjects) {
        [self saveMasterContext:^(id responseObjects) {
            successBlock(responseObjects);
        } error:^(NSString *failureReason) {
            failureBlock(failureReason);
        }];
    } error:^(NSString *failureReason) {
        failureBlock(failureReason);
    }];
}

#pragma mark -Private methods
- (void)addPersistentStore {
    NSURL *storeURL = [[[[NSFileManager defaultManager]URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[@"Tracker" stringByAppendingPathExtension:@"sqlite"]];
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        abort();
    }
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager]setAttributes:fileAttributes ofItemAtPath:[storeURL path] error:nil];
    
}

@end