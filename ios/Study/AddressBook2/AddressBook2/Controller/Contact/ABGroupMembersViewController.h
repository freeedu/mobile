//
//  ABGroupMembersViewController.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseViewController.h"
#import "ABMGroup.h"
#import "ABMContact.h"

@interface ABGroupMembersViewController : ABContactBaseViewController <UITableViewDelegate, UITableViewDataSource, ABContactBaseCommunicationDelegate>

@property (nonatomic, strong) ABMGroup *group;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)sendSMSToSelectedContacts:(id)sender;
- (IBAction)sendEmailToSelectedContacts:(id)sender;
- (IBAction)showContactsForSelect:(id)sender;

@end
