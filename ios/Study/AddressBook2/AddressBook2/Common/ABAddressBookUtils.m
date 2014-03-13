//
//  ABAddressBookUtils.m
//  AddressBook
//
//  Created by Mason Mei on 2/22/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABAddressBookUtils.h"
#import <AddressBook/AddressBook.h>


NSString *const kDenied = @"Access to address book is denied";
NSString *const kRestricted = @"Access to address book is restricted";


@interface ABAddressBookUtils()

@property (nonatomic, strong) NSArray *allGroups;
@property (nonatomic) ABAddressBookRef addressBook;

@end

@implementation ABAddressBookUtils

static ABAddressBookUtils *sharedInstance = nil;

+(ABAddressBookUtils *)sharedInstance {
    if(!sharedInstance){
        sharedInstance = [[ABAddressBookUtils alloc] init];
    }
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self) {
        CFErrorRef error = NULL;
        
        switch (ABAddressBookGetAuthorizationStatus()){
            case kABAuthorizationStatusAuthorized:{
                _addressBook = ABAddressBookCreateWithOptions(NULL, &error);
                break;
            }
            case kABAuthorizationStatusDenied:{
                NSLog(kDenied);
                break;
            }
            case kABAuthorizationStatusNotDetermined:{
                _addressBook = ABAddressBookCreateWithOptions(NULL, &error);
                ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
                    if (granted){
                        NSLog(@"Access was granted");
                    } else {
                        NSLog(@"Access was not granted");
                    }
                });
                break;
            }
            case kABAuthorizationStatusRestricted:{
                NSLog(kRestricted);
                break;
            }
        }
    }
    return self;
}

-(void)releaseAddressBook {
    if(_addressBook){
        CFRelease(_addressBook);
    }
}

-(UIImage *) getPersonImage:(ABRecordRef) person {
    UIImage *result = nil;
    
    if(person == NULL) {
        NSLog(@"The person for retrieve image is null.");
        return  NULL;
    }
    
    NSData *imageData = (__bridge_transfer NSData *)(ABPersonCopyImageData(person));
    if(imageData != nil){
        result = [UIImage imageWithData:imageData];
    }
    return result;
}

- (bool) setPersonImage:(ABRecordRef) person inAddressBook:(ABAddressBookRef) paramAddressBook withImageData:(NSData *) imageData {
    bool result = NO;
    
    if(paramAddressBook == NULL || person == NULL){
        NSLog(@"Invalid paramters for set person image.");
        return result;
    }
    
    CFErrorRef couldSetPersonImageError = NULL;
    bool couldSetPersonImage = ABPersonSetImageData(person, (__bridge CFDataRef)(imageData), &couldSetPersonImageError);
    
    if(couldSetPersonImage){
        NSLog(@"Successfully set the person's image.");
        if(ABAddressBookHasUnsavedChanges(paramAddressBook)){
            CFErrorRef couldSaveAddressBookError = NULL;
            
            bool couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
            
            if(couldSaveAddressBook){
                NSLog(@"Successfully saved the address book.");
                result = YES;
            } else{
                NSLog(@"Failed to save the address book.");
            }
            
        } else {
            NSLog(@"There is no change to be saved.");
        }
    }else {
        NSLog(@"Failed to set the person's image.");
    }
    
    return result;
}

-(ABRecordRef) findPersonWithRecordId:(ABRecordID) personRecordId inAddressBook:(ABAddressBookRef) paramAddressBook {
    ABRecordRef result = NULL;
    if(personRecordId < 0 || paramAddressBook == NULL){
        NSLog(@"Invalid parameter for retrieve person.");
        return result;
    }
    
    result = ABAddressBookGetPersonWithRecordID(paramAddressBook, personRecordId);
    NSLog(@"Retrieve person with record Id");
    
    return result;
}

//For New API
//private section





//API for using
//-(bool)existGroupWithName:(NSString *)groupName {
//    if(_addressBook != NULL){
//        return [self doesGroupExistWithGroupName:groupName inAddressBook:_addressBook];
//    }
//
//    return NO;
//}
//
//-(bool)createGroup:(NSString *)groupName {
//    if(_addressBook){
//        if([self doesGroupExistWithGroupName:groupName inAddressBook:_addressBook]){
//            return NO;
//        }
//
//        ABRecordRef group = [self newGroupWithName:groupName inAddressBook:_addressBook];
//        return group != NULL;
//    }
//
//    return NO;
//}
//
//-(bool)deleteGroupWithName:(NSString *)groupName {
//    if(_addressBook){
//        return [self removeGroupWithName:groupName inAddressBook:_addressBook];
//    }
//
//    return NO;
//}
//
//-(NSArray *)getAllMembersInGroup:(NSString *)groupName {
//    if(_addressBook){
//        ABRecordRef group = [self findGroupWithName:groupName inAddressBook:_addressBook];
//        if(group){
//            return [self readMembersWithGroup:group];
//        }
//    }
//
//    return nil;
//}
//
//-(NSArray *)getAllGroups{
//    if(_addressBook){
//        return [self readAllGroupsInAddressBook:_addressBook];
//    }
//
//    return nil;
//}
//
//-(bool)addPerson:(ABRecordID)recordId toGroup:(NSString *)groupName {
//    if(_addressBook){
//        ABRecordRef person = [self findPersonWithRecordId:recordId inAddressBook:_addressBook];
//        ABRecordRef group = [self findGroupWithName:groupName inAddressBook:_addressBook];
//
//        if(person != NULL && group != NULL){
//            return [self addPeson:person toGroup:group saveToAddressBook:_addressBook];
//        }
//    }
//
//    return NO;
//}

//New API
//private

-(ABMGroup *) convertRecordToGroup:(ABRecordRef) groupRecord{
    if(groupRecord != NULL){
        ABMGroup *group = [[ABMGroup alloc]initWithABRecordRef:groupRecord];
        
        return group;
    }
    
    return nil;
}

-(ABMContact *) convertRecordToContact:(ABRecordRef) contactRecord{
    if(contactRecord){
        ABMContact *contact = [[ABMContact alloc] initWithABRecordRef:contactRecord];
        return contact;
    }
    
    return nil;
}

-(NSArray *) readMembersInGroup:(ABRecordRef) group inAddressBook:(ABAddressBookRef) paramAddressBook {
    NSMutableArray *result = [NSMutableArray new];
    if(group == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid Parameter for load memeber in group.");
        return result;
    }
    
    CFArrayRef members = ABGroupCopyArrayOfAllMembers(group);
    
    if(members == NULL){
        NSLog(@"There is no memeber within group.");
    } else {
        for (int i = 0; i < CFArrayGetCount(members) ; i++) {
            ABMContact *contact = [self convertRecordToContact:CFArrayGetValueAtIndex(members, i)];
            if(contact != NULL){
                [result addObject:contact];
            }
        }
        CFRelease(members);
    }
    
    return result;
}

-(NSArray *) readAllContactInAddressBook:(ABAddressBookRef) paramAddressBook {
    NSMutableArray *result = [NSMutableArray new];
    if(paramAddressBook == NULL){
        NSLog(@"Invalid Parameter for load all memebers.");
        return result;
    }
    
    CFArrayRef members = ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    if(members == NULL){
        NSLog(@"There is no contact.");
    } else {
        for (int i = 0; i < CFArrayGetCount(members) ; i++) {
            ABMContact *contact = [self convertRecordToContact:CFArrayGetValueAtIndex(members, i)];
            if(contact != NULL){
                [result addObject:contact];
            }
        }
        CFRelease(members);
    }
    return result;
}


- (NSArray *)readAllGroupInAddressBook:(ABAddressBookRef) paramAddressBook {
    NSMutableArray *result = [NSMutableArray new];
    if(paramAddressBook == NULL){
        NSLog(@"Invalid Parameter for load all group.");
        return result;
    }
    
    CFArrayRef groups = ABAddressBookCopyArrayOfAllGroups(paramAddressBook);
    
    if(groups == NULL){
        NSLog(@"There is no group.");
    } else {
        for (int i = 0; i < CFArrayGetCount(groups) ; i++) {
            ABMGroup *group = [self convertRecordToGroup:CFArrayGetValueAtIndex(groups, i)];
            if(group != NULL){
                [result addObject:group];
            }
        }
        CFRelease(groups);
    }
    
    return result;
}

-(bool)checkExistGroupWithName:(NSString *)groupName inAddressBook:(ABAddressBookRef) paramAddressBook {
    bool result = YES;
    
    if(groupName == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for check group exist or not.");
        return  result;
    }
    
    CFArrayRef groups = ABAddressBookCopyArrayOfAllGroups(paramAddressBook);
    
    if(groups != NULL){
        result = NO;
        
        for (int i = 0; i < CFArrayGetCount(groups); i++) {
            ABRecordRef group = CFArrayGetValueAtIndex(groups, i);
            NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
            
            if( [groupName length] == 0 && [name length] == 0) {
                result = YES;
                break;
            } else if([groupName isEqualToString:name]){
                result = YES;
                break;
            }
        }
        CFRelease(groups);
    }
    return result;
}

-(ABMGroup *)createGroupWithName:(NSString *)groupName inAddressBook:(ABAddressBookRef) paramAddressBook{
    ABMGroup *result = NULL;
    
    if(groupName == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for create group.");
        return  result;
    }
    
    ABRecordRef group = ABGroupCreate();
    if(group == NULL){
        NSLog(@"Failed to create group with given name %@.", groupName);
        return result;
    }
    
    CFErrorRef error = NULL;
    
    bool couldSetGroupName = ABRecordSetValue(group, kABGroupNameProperty, (__bridge_retained CFTypeRef)(groupName), &error);
    if(couldSetGroupName) {
        bool couldAddRecord = NO;
        CFErrorRef addRecordError = NULL;
        
        couldAddRecord = ABAddressBookAddRecord(paramAddressBook, group, &addRecordError);
        
        if(couldAddRecord) {
            NSLog(@"Successfully added the new group.");
            if(ABAddressBookHasUnsavedChanges(paramAddressBook)) {
                CFErrorRef couldSaveAddressBookError = NULL;
                
                bool couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
                
                if(couldSaveAddressBook) {
                    NSLog(@"Successfully saved the address book.");
                } else {
                    group = NULL;
                    NSLog(@"Failed to save the address book.");
                }
            } else {
                group = NULL;
                NSLog(@"No unsaved changes");
            }
        } else {
            group = NULL;
            NSLog(@"Could not add a new group.");
        }
    } else {
        group = NULL;
        NSLog(@"Failed to set the name of the group.");
    }
    
    if(group){
        result = [[ABMGroup alloc] initWithABRecordRef:group];
    }
    
    return result;
}

-(bool) deleteGroup:(ABMGroup *) groupToDelete inAddressBook:(ABAddressBookRef) paramAddressBook {
    bool result = NO;
    
    if(groupToDelete == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for create group.");
        return  result;
    }
    
    bool canRemoveGroup = NO;
    CFErrorRef canRemoveGroupError = NULL;
    
    ABRecordRef group = [groupToDelete record];
    
    NSArray *members = CFBridgingRelease(ABGroupCopyArrayOfAllMembers(group));
    if(members){
        for (int i = 0; i < [members count]; i ++) {
            ABGroupRemoveMember(group, (__bridge ABRecordRef)([members objectAtIndex:i]), nil);
        }
    }
    
    canRemoveGroup = ABAddressBookRemoveRecord(paramAddressBook, group, &canRemoveGroupError);
    
    
    if(canRemoveGroup) {
        NSLog(@"Successfully Removed the group.");
        if(ABAddressBookHasUnsavedChanges(paramAddressBook)) {
            bool couldSaveAddressBook = NO;
            CFErrorRef couldSaveAddressBookError = NULL;
            
            couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
            
            if(couldSaveAddressBook) {
                NSLog(@"Successfully saved the address book.");
                result = YES;
            } else {
                group = NULL;
                NSLog(@"Failed to save the address book.");
            }
        } else {
            group = NULL;
            NSLog(@"No unsaved changes");
        }
    } else {
        group = NULL;
        NSLog(@"Could not remove group.");
    }
    
    if(group == NULL){
        result = NO;
    }
    
    return result;
}

-(bool)addMembers:(NSArray *)membersToAdd toGroup:(ABMGroup *)groupToAdd inAddressBook:(ABAddressBookRef) paramAddressBook {
    bool result = NO;
    
    if(membersToAdd == NULL || groupToAdd == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for add member to group.");
        return  result;
    }

    ABRecordRef group = [groupToAdd record];
    
    CFArrayRef members = ABGroupCopyArrayOfAllMembers(group);
    NSMutableArray *groupMembers = [NSMutableArray new];
    NSMutableArray *newAddMembers = [NSMutableArray new];
    
    if(members == NULL){
        NSLog(@"There is no memeber within group.");
        [newAddMembers addObjectsFromArray:membersToAdd];
    } else {
        for (int i = 0; i < CFArrayGetCount(members) ; i++) {
            ABMContact *contact = [self convertRecordToContact:CFArrayGetValueAtIndex(members, i)];
            if(contact != NULL){
                [groupMembers addObject:contact];
            }
        }
        CFRelease(members);
        
        for (ABMContact *contact in membersToAdd) {
            bool contain = NO;
            for (ABMContact *c in groupMembers) {
                if([c recordId] == [contact recordId]){
                    contain = YES;
                    break;
                }
            }
            
            if(contain != YES){
                [newAddMembers addObject:contact];
            }
        }
    }
    
    CFErrorRef error = NULL;
    bool addResult;
    
    for (ABMContact *contact in newAddMembers) {
        addResult = ABGroupAddMember(group, [contact record], &error);
        if(!addResult){
            NSLog(@"Could not add the person %@ to the group.", [contact name]);
        }
    }
    
    if(ABAddressBookHasUnsavedChanges(paramAddressBook)){
        bool couldSaveAddressBook = NO;
        CFErrorRef couldSaveAddressBookError = NULL;
        
        couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
        if(couldSaveAddressBook){
            NSLog(@"Successfully added the person to the group.");
            result = YES;
        } else {
            NSLog(@"Failed to save the address book.");
        }
    } else {
        NSLog(@"No changes were saved.");
    }
    return result;
}

-(bool)removeMember:(ABMContact *)memberToRemove fromGroup:(ABMGroup *)groupToRemove inAddressBook:(ABAddressBookRef) paramAddressBook {
    bool result = NO;
    
    if(memberToRemove == NULL || groupToRemove == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for remove member from group.");
        return  result;
    }
    
    bool canRemoveMember = NO;
    CFErrorRef canRemoveMemberError = NULL;
    
    ABRecordRef group = [groupToRemove record];
    ABRecordRef member = [memberToRemove record];
    
    canRemoveMember = ABGroupRemoveMember(group, member, &canRemoveMemberError);
    
    if(canRemoveMember) {
        NSLog(@"Successfully Removed the member from group.");
        if(ABAddressBookHasUnsavedChanges(paramAddressBook)) {
            bool couldSaveAddressBook = NO;
            CFErrorRef couldSaveAddressBookError = NULL;
            
            couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
            
            if(couldSaveAddressBook) {
                NSLog(@"Successfully saved the address book.");
                result = YES;
            } else {
                group = NULL;
                NSLog(@"Failed to save the address book.");
            }
        } else {
            group = NULL;
            NSLog(@"No unsaved changes");
        }
    } else {
        group = NULL;
        NSLog(@"Could not remove group.");
    }
    
    if(group == NULL){
        result = NO;
    }
    
    return result;
}

-(bool)removeContact:(ABMContact *)contact inAddressBook:(ABAddressBookRef) paramAddressBook{
    bool result = NO;
    
    if(contact == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameter for remove contact.");
        return result;
    }
    
    bool canRemoveContact = NO;
    CFErrorRef canRemoveContactError = NULL;
    
    ABRecordRef contactToDel = [contact record];
    
    canRemoveContact = ABAddressBookRemoveRecord(_addressBook, contactToDel, &canRemoveContactError);
    
    if(canRemoveContact){
        NSLog(@"Successfully Removed the contact.");
        if(ABAddressBookHasUnsavedChanges(paramAddressBook)) {
            bool couldSaveAddressBook = NO;
            CFErrorRef couldSaveAddressBookError = NULL;
        
            couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
        
            if(couldSaveAddressBook) {
                NSLog(@"Successfully saved the address book.");
                result = YES;
            } else {
                contactToDel = NULL;
                NSLog(@"Failed to save the address book.");
            }
        } else {
            contactToDel = NULL;
            NSLog(@"No unsaved changes");
        }
    } else {
        contactToDel = NULL;
        NSLog(@"Could not remove contact.");
    }

    if(contactToDel == NULL){
        result = NO;
    }

    return result;

}

//public
-(NSArray *)readPeopleWithGroup:(ABMGroup *)group {
    if(group == NULL){
        NSLog(@"Invalid Parameter for read people in group.");
        return nil;
    }
    
    if(_addressBook) {
        return [self readMembersInGroup:[group record] inAddressBook:_addressBook];
    }
    
    return nil;
}

-(NSArray *)readPeopleInGroups:(NSArray *)groups {
    if (groups == NULL || [groups count] == 0){
        NSLog(@"Invalid Parameter for read people in groups");
        return nil;
    }
    
    if (_addressBook) {
        NSMutableArray *peoples = [NSMutableArray new];
        for (ABMGroup *group in groups) {
            NSArray *members = [self readMembersInGroup:[group record] inAddressBook:_addressBook];
            [peoples addObjectsFromArray:members];
        }
        
        return [[NSSet setWithArray:peoples] allObjects];
    }
    
    return nil;
}

-(NSArray *)readAllPeople{
    if(_addressBook){
        return [self readAllContactInAddressBook:_addressBook];
    }
    
    return nil;
}

-(NSArray *)readAllGroup{
    if(_addressBook){
        return [self readAllGroupInAddressBook:_addressBook];
    }
    return nil;
}

-(bool)checkExistGroupWithName:(NSString *)groupName{
    if(_addressBook){
        return [self checkExistGroupWithName:groupName inAddressBook:_addressBook];
    }
    
    return YES;
}

-(ABMGroup *)createGroupWithName:(NSString *)groupName{
    if(_addressBook){
        return [self createGroupWithName:groupName inAddressBook:_addressBook];
    }
    return nil;
}

-(bool)deleteGroup:(ABMGroup *)group {
    if(_addressBook){
        return [self deleteGroup:group inAddressBook:_addressBook];
    }
    return NO;
}

-(bool)addMembers:(NSArray *)members toGroup:(ABMGroup *)group {
    if(_addressBook){
        return [self addMembers:members toGroup:group inAddressBook:_addressBook];
    }
    
    return NO;
}

-(bool)removeMember:(ABMContact *)member fromGroup:(ABMGroup *)group{
    if(_addressBook){
        return [self removeMember:member fromGroup:group inAddressBook:_addressBook];
    }
    return NO;
}

-(bool)removeContact:(ABMContact *)contact {
    if(_addressBook){
        return [self removeContact:contact inAddressBook:_addressBook];
    }
    return NO;
}

@end
