//
//  ABMMultiValue.m
//  AddressBook
//
//  Created by Mason Mei on 3/8/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABMMultiValue.h"

@implementation ABMMultiValue


-(NSMutableDictionary *)dictionaryValue{
    if(_dictionaryValue == NULL){
        _dictionaryValue = [NSMutableDictionary new];
    }
    return _dictionaryValue;
}

@end
