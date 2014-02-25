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

-(void) useAddressBook:(ABAddressBookRef) paramAddressBook {
    if(ABAddressBookHasUnsavedChanges(paramAddressBook)){
        NSLog(@"Changes were found in the address book.");
        
        BOOL doYouWantToSaveChanges = YES;
        
        if(doYouWantToSaveChanges){
            CFErrorRef saveError = nil;
            if(ABAddressBookSave(paramAddressBook, &saveError)){
                NSLog(@"Save the unsaved changes success.");
            } else {
                NSLog(@"Save the unsaved changes failed.");
            }
        } else {
            ABAddressBookRevert(paramAddressBook);
        }
    } else {
        NSLog(@"No changes to the address book.");
    }
}

- (void) readFromAddressBook:(ABAddressBookRef) paramAddressBook {
    NSArray *allPeople = (__bridge_transfer NSArray *)(ABAddressBookCopyArrayOfAllPeople(paramAddressBook));
    NSLog(@"Read all people from the address book, %ld person in total.", [allPeople count]);
}

-(ABRecordRef) newGroupWithName:(NSString *) groupName inAddressBook:(ABAddressBookRef) paramAddressBook {
    ABRecordRef group = nil;
    
    if(paramAddressBook == NULL){
        NSLog(@"The address book is nil.");
        return group;
    }
    
    group = ABGroupCreate();
    
    if(group == NULL){
        NSLog(@"Failed to create a new group.");
        return group;
    }
    
    BOOL couldSetGroupName = NO;
    CFErrorRef error = NULL;
    
    couldSetGroupName = ABRecordSetValue(group, kABGroupNameProperty, (__bridge CFTypeRef)(groupName), &error);
    
    if(couldSetGroupName) {
        BOOL couldAddRecord = NO;
        CFErrorRef addRecordError = NULL;
        
        couldAddRecord = ABAddressBookAddRecord(paramAddressBook, group, &addRecordError);
        
        if(couldAddRecord) {
            NSLog(@"Successfully added the new group.");
            if(ABAddressBookHasUnsavedChanges(paramAddressBook)) {
                BOOL couldSaveAddressBook = NO;
                CFErrorRef couldSaveAddressBookError = NULL;
                
                couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
                
                if(couldSaveAddressBook) {
                    NSLog(@"Successfully saved the address book.");
                } else {
                    CFRelease(group);
                    group = NULL;
                    NSLog(@"Failed to save the address book.");
                }
            } else {
                CFRelease(group);
                group = NULL;
                NSLog(@"No unsaved changes");
            }
        } else {
            CFRelease(group);
            group = NULL;
            NSLog(@"Could not add a new group.");
        }
    } else {
        CFRelease(group);
        group = NULL;
        NSLog(@"Failed to set the name of the group.");
    }
    
    return group;
}

-(ABRecordRef) findGroupWithName:(NSString *) groupName inAddressBook:(ABAddressBookRef) paramAddressBook {
    ABRecordRef result = nil;
    
    if(groupName == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for check group exist or not.");
        return  result;
    }
    
    NSArray *allGroups = (__bridge_transfer NSArray *)(ABAddressBookCopyArrayOfAllGroups(paramAddressBook));
    
    for (int i = 0; i < [allGroups count]; i++) {
        ABRecordRef group = (__bridge ABRecordRef)([allGroups objectAtIndex:i]);
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
        
        if( [groupName length] == 0 && [name length] == 0) {
            return group;
        } else if([groupName isEqualToString:name]){
            return group;
        }
    }
    
    return result;
}

-(NSArray *) readAllGroupsInAddressBook:(ABAddressBookRef) paramAddressBook {
    NSArray *result = nil;
    if(paramAddressBook == NULL) {
        NSLog(@"Invalid parameters for retrieve all groups");
        return result;
    }
    
    result = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllGroups(paramAddressBook));
    
    NSLog(@"Read all the groups in address book.");
    return result;
}

-(NSArray *) readMembersWithGroup:(ABRecordRef) group {
    NSArray *members = nil;
    if(group == NULL){
        NSLog(@"Invalid parameters in read members from group.");
        return members;
    }
    
    members = (__bridge_transfer NSArray *)(ABGroupCopyArrayOfAllMembers(group));
    NSLog(@"Read all members in group.");
    return members;
}

-(BOOL) removeGroupWithName:(NSString *) groupName inAddressBook:(ABAddressBookRef) paramAddressBook {
    BOOL result = NO;
    
    if(groupName == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for check group exist or not.");
        return  result;
    }
    
    NSArray *allGroups = (__bridge_transfer NSArray *)(ABAddressBookCopyArrayOfAllGroups(paramAddressBook));
    
    for (int i = 0; i < [allGroups count]; i++) {
        ABRecordRef group = (__bridge ABRecordRef)([allGroups objectAtIndex:i]);
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
        
        if( [groupName length] == 0 && [name length] == 0) {
            return [self removeGroup:group inAddressBook:paramAddressBook];
        } else if([groupName isEqualToString:name]){
            return [self removeGroup:group inAddressBook:paramAddressBook];
        }
    }
    
    return result;
}

-(BOOL) removeGroup:(ABRecordRef) group inAddressBook:(ABAddressBookRef) paramAddressBook {
    BOOL result = NO;
    
    if(group == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid Paramaters for remove group");
        return result;
    }
    
    
    BOOL canRemoveGroup = NO;
    CFErrorRef canRemoveGroupError = NULL;
    
    
    NSArray *members = CFBridgingRelease(ABGroupCopyArrayOfAllMembers(group));
    for (int i = 0; i < [members count]; i ++) {
        ABGroupRemoveMember(group, (__bridge ABRecordRef)([members objectAtIndex:i]), nil);
    }
    
    canRemoveGroup = ABAddressBookRemoveRecord(paramAddressBook, group, &canRemoveGroupError);
    
    
    if(canRemoveGroup) {
        NSLog(@"Successfully Removed the group.");
        if(ABAddressBookHasUnsavedChanges(paramAddressBook)) {
            BOOL couldSaveAddressBook = NO;
            CFErrorRef couldSaveAddressBookError = NULL;
            
            couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
            
            if(couldSaveAddressBook) {
                NSLog(@"Successfully saved the address book.");
                result = YES;
            } else {
                CFRelease(group);
                group = NULL;
                NSLog(@"Failed to save the address book.");
            }
        } else {
            CFRelease(group);
            group = NULL;
            NSLog(@"No unsaved changes");
        }
    } else {
        CFRelease(group);
        group = NULL;
        NSLog(@"Could not remove group.");
    }
    
    return result;
}

-(BOOL) addPeson:(ABRecordRef) person toGroup:(ABRecordRef) group saveToAddressBook:(ABAddressBookRef) paramAddressBook {
    BOOL result = NO;
    
    if(person == NULL || group == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters are give for add memeber to group.");
        return  result;
    }
    
    CFErrorRef error = NULL;
    
    result = ABGroupAddMember(group, person, &error);
    if(!result){
        NSLog(@"Could not add the person to the group.");
        return result;
    }
    
    if(ABAddressBookHasUnsavedChanges(paramAddressBook)){
        BOOL couldSaveAddressBook = NO;
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

-(BOOL) doesGroupExistWithGroupName:(NSString *)groupName inAddressBook:(ABAddressBookRef) paramAddressBook {
    BOOL result = NO;
    
    if(groupName == NULL || paramAddressBook == NULL){
        NSLog(@"Invalid parameters for check group exist or not.");
        return  result;
    }
    
    NSArray *allGroups = (__bridge_transfer NSArray *)(ABAddressBookCopyArrayOfAllGroups(paramAddressBook));
    
    for (int i = 0; i < [allGroups count]; i++) {
        ABRecordRef group = (__bridge ABRecordRef)([allGroups objectAtIndex:i]);
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(group, kABGroupNameProperty);
        
        if( [groupName length] == 0 && [name length] == 0) {
            return YES;
        } else if([groupName isEqualToString:name]){
            return YES;
        }
    }
    
    return result;
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

- (BOOL) setPersonImage:(ABRecordRef) person inAddressBook:(ABAddressBookRef) paramAddressBook withImageData:(NSData *) imageData {
    BOOL result = NO;
    
    if(paramAddressBook == NULL || person == NULL){
        NSLog(@"Invalid paramters for set person image.");
        return result;
    }
    
    CFErrorRef couldSetPersonImageError = NULL;
    BOOL couldSetPersonImage = ABPersonSetImageData(person, (__bridge CFDataRef)(imageData), &couldSetPersonImageError);
    
    if(couldSetPersonImage){
        NSLog(@"Successfully set the person's image.");
        if(ABAddressBookHasUnsavedChanges(paramAddressBook)){
            BOOL couldSaveAddressBook = NO;
            CFErrorRef couldSaveAddressBookError = NULL;
            
            couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
            
            if(couldSetPersonImage){
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

//API for using
-(BOOL)existGroupWithName:(NSString *)groupName {
    if(_addressBook != NULL){
        return [self doesGroupExistWithGroupName:groupName inAddressBook:_addressBook];
    }
    
    return NO;
}

-(BOOL)createGroup:(NSString *)groupName {
    if(_addressBook){
        if([self doesGroupExistWithGroupName:groupName inAddressBook:_addressBook]){
            return NO;
        }
        
        ABRecordRef group = [self newGroupWithName:groupName inAddressBook:_addressBook];
        return group != NULL;
    }
    
    return NO;
}

-(BOOL)deleteGroupWithName:(NSString *)groupName {
    if(_addressBook){
        return [self removeGroupWithName:groupName inAddressBook:_addressBook];
    }
    
    return NO;
}

-(NSArray *)getAllMembersInGroup:(NSString *)groupName {
    if(_addressBook){
        ABRecordRef group = [self findGroupWithName:groupName inAddressBook:_addressBook];
        if(group){
            return [self readMembersWithGroup:group];
        }
    }
    
    return nil;
}

-(NSArray *)getAllGroups{
    if(_addressBook){
        return [self readAllGroupsInAddressBook:_addressBook];
    }
    
    return nil;
}

-(BOOL)addPerson:(ABRecordID)recordId toGroup:(NSString *)groupName {
    if(_addressBook){
        ABRecordRef person = [self findPersonWithRecordId:recordId inAddressBook:_addressBook];
        ABRecordRef group = [self findGroupWithName:groupName inAddressBook:_addressBook];
        
        if(person != NULL && group != NULL){
            return [self addPeson:person toGroup:group saveToAddressBook:_addressBook];
        }
    }
    
    return NO;
}
@end
