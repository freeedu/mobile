//
//  ABMContact.h
//  AddressBook
//
//  Created by Mason Mei on 2/25/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABMRecord.h"
#import "ABMMultiValue.h"

@interface ABMContact : ABMRecord

@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *middlename;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *imageForExchange;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSMutableArray *allPhones;
@property (nonatomic, retain) NSMutableArray *allEmails;
@property (nonatomic, retain) NSMutableArray *allInstantMessages;
@property (nonatomic, retain) NSMutableArray *allSocials;
@property (nonatomic, retain) NSMutableArray *allUrls;
@property (nonatomic, retain) ABMMultiValue *birthday;
@property (nonatomic, retain) NSMutableArray *allAnniversary;
@property (nonatomic, retain) NSMutableArray *allAddress;




- (NSString*)firstLastSort;
- (NSString*)lastFirstSort;

@end
