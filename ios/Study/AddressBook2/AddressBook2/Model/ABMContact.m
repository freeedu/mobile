//
//  ABMContact.m
//  AddressBook
//
//  Created by Mason Mei on 2/25/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABMContact.h"

@implementation ABMContact


-(NSString *)firstname{
    if (!_firstname){
        _firstname = [self valueForAddressBookKey:kABPersonFirstNameProperty];
    }
    return _firstname;
}

-(NSString *)middlename{
    if (!_middlename){
        _middlename =  [self valueForAddressBookKey:kABPersonMiddleNameProperty];
    }
    return _middlename;
}

-(NSString *)lastname{
    if (!_lastname){
        _lastname = [self valueForAddressBookKey:kABPersonLastNameProperty];
    }
    return _lastname;
}

-(NSString *)nickname{
    if (!_nickname){
        _nickname = [self valueForAddressBookKey:kABPersonNicknameProperty];
    }
    return _nickname;
}

-(NSString *)name{
    if (_name){
        return _name;
    }
    
    NSMutableString *name = [[NSMutableString alloc] initWithString:@""];
    
    if(self.firstname != NULL){
        [name appendString:self.firstname];
    }
    
    if (self.lastname != NULL) {
        if([name length] != 0){
            [name appendString:@" "];
        }
        [name appendString:self.lastname];
    }
    
    _name = name;
    
    return _name;
}

-(NSString *)companyName {
    if (!_companyName){
        _companyName = [self valueForAddressBookKey:kABPersonOrganizationProperty];
    }
    return _companyName;
}

-(UIImage *)image{
    if(_image){
        return _image;
    }
    
    if(!ABPersonHasImageData(_record)){
        return nil;
    }
    
    CFDataRef imageData = ABPersonCopyImageData(_record);
    _image = [UIImage imageWithData:(__bridge NSData *)(imageData)];
    CFRelease(imageData);
    return _image;
}

-(NSString *)phoneNumber{
    ABMultiValueRef multiValue = ABRecordCopyValue(_record, kABPersonPhoneProperty);
    
    if (multiValue == nil || ABMultiValueGetCount(multiValue) == 0) {
        return nil;
    }
    
    return (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiValue, 0);
}

- (NSString *)email {
    ABMultiValueRef multiValue = ABRecordCopyValue(_record, kABPersonEmailProperty);
    
    if (multiValue == nil || ABMultiValueGetCount(multiValue) == 0) {
        return nil;
    }
    
    return (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiValue, 0);
}

- (NSString*)firstLastSort {
    NSString *firstName = [self firstname];
    NSString *lastName = [self lastname];
    NSString *name = [self name];
    
    if (nil != firstName && ![firstName isEqualToString:@""]) {
        return firstName;
    }
    if (nil != lastName && ![lastName isEqualToString:@""]) {
        return lastName;
    }
    if (nil != name && ![name isEqualToString:@""]) {
        return name;
    }
    return @"";
}

- (NSString*)lastFirstSort {
    NSString *firstName = [self firstname];
    NSString *lastName = [self lastname];
    NSString *name = [self name];
    if (nil != lastName && ![lastName isEqualToString:@""]) {
        return lastName;
    }
    if (nil != firstName && ![firstName isEqualToString:@""]) {
        return firstName;
    }
    if (nil != name && ![name isEqualToString:@""]) {
        return name;
    }
    return @"";
}

-(NSMutableArray *)allPhones {
    if (_allPhones == NULL){
        _allPhones = [self readMultiValue:kABPersonPhoneProperty valueType:kABMValueTypeString];
    }
    
    return _allPhones;
}

- (NSMutableArray *) allEmails {
    if(_allEmails == NULL) {
        _allEmails = [self readMultiValue:kABPersonEmailProperty valueType:kABMValueTypeString];
    }
    
    return _allEmails;
}

-(NSMutableArray *)allInstantMessages {
    if(_allInstantMessages == NULL) {
        _allInstantMessages = [self readMultiValue:kABPersonInstantMessageProperty valueType:kABMValueTypeDictionary];
    }
        
    return _allInstantMessages;
}

-(NSMutableArray *)allSocials {
    if (_allSocials == NULL){
        _allSocials = [self readMultiValue:kABPersonSocialProfileProperty valueType:kABMValueTypeDictionary];
    }
    return _allSocials;
}

-(NSMutableArray *)allUrls{
    if(_allUrls == NULL){
        _allUrls = [self readMultiValue:kABPersonURLProperty valueType:kABMValueTypeString];
    }
    return _allUrls;
}

- (NSMutableArray *) readMultiValue:(ABPropertyID) propertyID valueType: (ABMValueType) valueType {
    ABMutableMultiValueRef multiValueRef = [self multiValueForAddressBookKey:propertyID];
    NSMutableArray *multiValueArray = [NSMutableArray new];
    if(multiValueRef){
        for (CFIndex i = 0; i < ABMultiValueGetCount(multiValueRef); i++) {
            CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValueRef, i);
            
            ABMMultiValue *multiValue = [[ABMMultiValue alloc] init];
            [multiValue setLabel:(__bridge NSString *)(label)];
            [multiValue setHumanReadableLabel:(__bridge NSString *)(ABAddressBookCopyLocalizedLabel(label))];
            
            switch (valueType) {
                case kABMValueTypeString:{
                        CFStringRef stringValue  = ABMultiValueCopyValueAtIndex(multiValueRef, i);
                        [multiValue setStringValue:(__bridge NSString *)(stringValue)];
                        CFRelease(stringValue);
                    }
                    break;
                case kABMValueTypeDate:{
                        CFDateRef dateValue = ABMultiValueCopyValueAtIndex(multiValueRef, i);
                        [multiValue setDateValue:(__bridge NSDate *)(dateValue)];
                    }
                    break;
                case kABMValueTypeDictionary:{
                    
                        NSDictionary *dictionary = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(multiValueRef, i));
                        if(dictionary != NULL){
                            for (NSString *key in [dictionary allKeys]) {
                                [[multiValue dictionaryValue] setObject:[dictionary valueForKey:key] forKey:key];
                            }
                        }
                        
                    }
                    break;
            }
    
            [multiValueArray addObject:multiValue];
            NSLog(@"%@ : %@ %@", [multiValue humanReadableLabel], [multiValue stringValue], [multiValue dateValue]);
        }
    }
    
    return multiValueArray;
}

-(ABMMultiValue *)birthday{
    if(_birthday == NULL){
        CFDateRef birthdayRef = ABRecordCopyValue(_record, kABPersonBirthdayProperty);
        
        if(birthdayRef != NULL){
            _birthday = [[ABMMultiValue alloc] init];
            [_birthday setLabel:@"Birthday"];
            [_birthday setDateValue:(__bridge NSDate *)(birthdayRef)];
        }
        
    }
    return _birthday;
}

-(NSArray *) allAnniversary{
    if(_allAnniversary == NULL){
        _allAnniversary = [self readMultiValue:kABPersonDateProperty valueType:kABMValueTypeDate];
    }
    return _allAnniversary;
}

@end
