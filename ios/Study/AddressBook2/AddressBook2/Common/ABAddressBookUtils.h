//
//  ABAddressBookUtils.h
//  AddressBook
//
//  Created by Mason Mei on 2/22/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABMGroup.h"
#import "ABMContact.h"

@interface ABAddressBookUtils : NSObject

// Shared instances
+(ABAddressBookUtils *) sharedInstance;


-(id) init;
-(void) releaseAddressBook;

// instance interface methods
//-(BOOL) existGroupWithName:(NSString *)groupName;
//-(BOOL) deleteGroupWithName:(NSString *)groupName;
//-(BOOL) createGroup:(NSString *) groupName;
//-(NSArray *) getAllGroups;
//-(NSArray *) getAllMembersInGroup:(NSString *) groupName;
//-(BOOL) addPerson:(int)recordId toGroup:(NSString *) groupName;


//New API
-(NSArray *) readPeopleWithGroup: (ABMGroup *) group;
-(NSArray *) readPeopleInGroups: (NSArray *) groups;
-(NSArray *) readAllPeople;
-(NSArray *) readAllGroup;
-(BOOL) checkExistGroupWithName:(NSString *) groupName;
-(ABMGroup *) createGroupWithName:(NSString *) groupName;
-(BOOL) deleteGroup:(ABMGroup *) group;
-(BOOL) addMembers:(NSArray *) members toGroup:(ABMGroup *) group;
-(BOOL) removeMember:(ABMContact *) member fromGroup:(ABMGroup *) group;
-(BOOL) removeContact:(ABMContact *) contact;

@end
