//
//  ABContactPickerViewController.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//


#import "ABContactBaseViewController.h"
#import "ABMultiplePeoplePickerController.h"
#import "ABGroupPickerViewController.h"
#import "ABContactNewViewController.h"
#import "ABContactPeopleCell.h"
#import "ABTypeDefine.h"
#import "ABMContact.h"
#import "ABMGroup.h"


@interface ABContactPickerViewController : ABContactBaseViewController<UITableViewDelegate, UITableViewDataSource,ABGroupPickerViewControllerDelegate, ABContactBaseCommunicationDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIBarButtonItem *addContactButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;


@property (nonatomic, retain) NSArray *selectedGroups;
@property (nonatomic, strong) NSMutableArray *filteredContactList;
@property (nonatomic, strong) NSMutableArray *allContactList;
@property (nonatomic, strong) NSMutableArray *selectedContactList;
@property NSUInteger selectedContactCount;
@property (nonatomic) BOOL searchWasActived;
@property (nonatomic, copy) NSString *savedSearchTerm;

@property (nonatomic) ABContactInvokeMode contactInvokeMode;


- (IBAction)sendMessageToSelectedContact:(id)sender;
- (IBAction)sendEmailToSelectedContacts:(id)sender;


@end
