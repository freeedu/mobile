//
//  ABMRecord.m
//  AddressBook
//
//  Created by Mason Mei on 2/28/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABMRecord.h"

@implementation ABMRecord

-(NSString *)valueForAddressBookKey:(ABRecordID)key{
    if (!_record) {
        return nil;
    }
    
    NSString *value = (__bridge_transfer NSString *)ABRecordCopyValue(_record, key);

    return value;
}

-(ABMultiValueRef) multiValueForAddressBookKey:(ABRecordID) key{
    if (!_record){
        return nil;
    }
    
    ABMultiValueRef multiValueRef = (ABMultiValueRef)ABRecordCopyValue(_record, key);
    return  multiValueRef;
}


-(id)initWithABRecordRef:(ABRecordRef)recordRef {
    if (!recordRef) {
        return nil;
    }
    
    if (self = [super init]) {
        _record = CFRetain(recordRef);
        _recordId = ABRecordGetRecordID(recordRef);
        _recordType = ABRecordGetRecordType(recordRef);
    }
    
    return self;
}

-(BOOL)isEqual:(id)object{
    if ([self class] != [object class]) {
        return NO;
    }
    
    ABMRecord *record = (ABMRecord *)object;
    
    return self.recordId == record.recordId;
}

@end
