//
//  ABMGroup.h
//  AddressBook
//
//  Created by Mason Mei on 2/25/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "ABMRecord.h"
#import "ABMContact.h"

@interface ABMGroup : ABMRecord

@property (nonatomic, retain) NSString *groupName;

@property (nonatomic, readonly) NSArray *members;
@property (nonatomic, readonly) NSArray *membersSorted;

-(NSString *)groupNameFirstPart;
-(NSString *)groupNameSecondPart;

@end
