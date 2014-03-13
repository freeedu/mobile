//
//  ABMRecord.h
//  AddressBook
//
//  Created by Mason Mei on 2/28/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ABMRecord : NSObject {
    ABRecordRef _record;
}

@property (readonly) ABRecordRef record;
@property (readonly) ABRecordType recordType;
@property (readonly) ABRecordID recordId;
@property NSInteger sectionNumber;
@property BOOL      rowSelected;

- (id)initWithABRecordRef:(ABRecordRef)recordRef;
- (NSString *)valueForAddressBookKey:(ABRecordID)key;
- (ABMutableMultiValueRef) multiValueForAddressBookKey:(ABRecordID) key;

@end
