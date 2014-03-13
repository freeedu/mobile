//
//  ABContactNewViewController.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseViewController.h"
#import "ABMContact.h"

@interface ABContactNewViewController : ABContactBaseViewController<UITableViewDataSource, UITableViewDelegate, ABContactBaseCommunicationDelegate>

@property (nonatomic, strong) ABMContact *contact;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)sendSMSToContact:(id)sender;
- (IBAction)callContact:(id)sender;
- (IBAction)sendEmailToContact:(id)sender;

@end
