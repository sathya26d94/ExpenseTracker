//
//  TrackerTests.m
//  TrackerTests
//
//  Created by SaTHYa on 24/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+String.h"


@interface TrackerTests : XCTestCase
@end

@implementation TrackerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsValidEmailMethod {
    NSString* sampleString =@"notvalidemail";
    BOOL result = [sampleString isValidEmail];
    BOOL expectedResult = false;
    XCTAssertEqual(result, expectedResult);
}

- (void)testIsValidUserNameOrPassword {
    NSString* sampleString =@"123";
    BOOL result = [sampleString isValidUserNameOrPassword];
    BOOL expectedResult = false;
    XCTAssertEqual(result, expectedResult);
}

- (void)testIsValidTitle {
    NSString* sampleString =@"validtitle";
    BOOL result = [sampleString isValidTitle];
    BOOL expectedResult = true;
    XCTAssertEqual(result, expectedResult);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
