//
//  ABMMultiValue.h
//  AddressBook
//
//  Created by Mason Mei on 3/8/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef uint32_t ABMValueType;

enum ABMValueType {
    kABMValueTypeString = 0,
    kABMValueTypeDate = 1,
    kABMValueTypeDictionary = 2
};

@interface ABMMultiValue : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *humanReadableLabel;
@property (nonatomic, retain) NSString *stringValue;
@property (nonatomic, retain) NSDate *dateValue;
@property (nonatomic, retain) NSMutableDictionary *dictionaryValue;


@end
