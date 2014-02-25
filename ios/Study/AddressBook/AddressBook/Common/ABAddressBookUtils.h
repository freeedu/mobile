//
//  ABAddressBookUtils.h
//  AddressBook
//
//  Created by Mason Mei on 2/22/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABAddressBookUtils : NSObject

// Shared instances
+(ABAddressBookUtils *) sharedInstance;


-(id) init;
-(void) releaseAddressBook;

// instance interface methods
-(BOOL) existGroupWithName:(NSString *)groupName;
-(BOOL) deleteGroupWithName:(NSString *)groupName;
-(BOOL) createGroup:(NSString *) groupName;
-(NSArray *) getAllGroups;
-(NSArray *) getAllMembersInGroup:(NSString *) groupName;
-(BOOL) addPerson:(int)recordId toGroup:(NSString *) groupName;




@end
