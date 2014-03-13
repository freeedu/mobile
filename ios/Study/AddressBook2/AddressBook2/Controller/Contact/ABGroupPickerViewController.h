//
//  ABGroupPickerViewController.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseViewController.h"
#import "ABGroupNewViewController.h"
#import "ABTypeDefine.h"

#import "ABMGroup.h"

@protocol ABGroupPickerViewControllerDelegate;

@interface ABGroupPickerViewController : ABContactBaseViewController<UITableViewDataSource, UITableViewDelegate, ABContactBaseCommunicationDelegate, ABGroupNewDelegate>

@property (nonatomic, weak) id<ABGroupPickerViewControllerDelegate> groupPickerDelegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void) initSelectedGroupsWith:(NSArray *)groups;

- (void)setInvokeMode: (ABContactInvokeMode) invokeMode;

- (IBAction)sendMessageToSelectedGroups:(id)sender;
- (IBAction)sendEmailToSelectedGroups:(id)sender;

@end

@protocol ABGroupPickerViewControllerDelegate <NSObject>

- (void)transferSelectGroups:(NSArray *)groups;

@end