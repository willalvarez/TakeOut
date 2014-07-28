//
//  User.h
//  TakeOut
//
//  Created by Will Alvarez on 7/9/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import JavaScriptCore;
@protocol UserJS <JSExport>



+ (instancetype)userWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address;
@end

@interface User : NSObject <UserJS>
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *address;
@end

/*
@interface BNRContact : NSObject <BNRContactJS>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *address;

@end
*/
