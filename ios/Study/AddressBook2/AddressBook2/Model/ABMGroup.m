//
//  ABMGroup.m
//  AddressBook
//
//  Created by Mason Mei on 2/25/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABMGroup.h"

@interface ABMGroup (){
    NSArray *_members;
    NSArray *_membersSorted;
}

@end

@implementation ABMGroup

-(NSString *)groupName {
    if (!_groupName) {
        _groupName = [self valueForAddressBookKey:kABGroupNameProperty];
    }
    
    return _groupName;
}

-(NSString *)groupNameFirstPart{
    NSArray *myArray = [[self groupName] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];

    return [myArray objectAtIndex:0];
}
-(NSString *)groupNameSecondPart{
    NSArray *myArray = [[self groupName] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    if([myArray count] <= 1){
        return @"";
    }
    return [myArray objectAtIndex:1];
}

-(NSArray *)members {
    if(_members){
        return _members;
    }
    
    NSArray *allMembers = (__bridge NSArray *)(ABGroupCopyArrayOfAllMembers(_record));
    NSMutableArray *values = [NSMutableArray new];
    
    for (id record in allMembers) {
        ABRecordRef member = (__bridge ABRecordRef)(record);
        ABMContact *contact = [[ABMContact alloc] initWithABRecordRef:member];
        [values addObject:contact];
    }
    
    _members = [NSMutableArray arrayWithArray:values];
    return _members;
}

-(NSArray *)membersSorted {
    if(_membersSorted){
        return _membersSorted;
    }
    
    NSArray *allMembers = (__bridge NSArray *)(ABGroupCopyArrayOfAllMembersWithSortOrdering(_record, kABPersonSortByFirstName));
    NSMutableArray *values = [NSMutableArray new];
    
    for (id record in allMembers) {
        ABRecordRef member = (__bridge ABRecordRef)(record);
        ABMContact *contact = [[ABMContact alloc] initWithABRecordRef:member];
        [values addObject:contact];
    }
    
    _membersSorted = [NSMutableArray arrayWithArray:values];
    return _membersSorted;
}

@end
