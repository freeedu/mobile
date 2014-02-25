//
//  ABMasterViewController.h
//  AddressBook
//
//  Created by Mason Mei on 2/17/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ABMasterViewController : UITableViewController<ABPeoplePickerNavigationControllerDelegate>

- (IBAction)showAddressBook:(id)sender;

@end
