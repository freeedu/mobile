//
//  ABGroupMembersViewController.h
//  AddressBook
//
//  Created by Mason Mei on 2/22/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ABGroupMembersViewController : UITableViewController<ABPeoplePickerNavigationControllerDelegate>

- (IBAction)showAddressBook:(id)sender;
@property (nonatomic, strong) NSString *groupName;

@end
