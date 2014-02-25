//
//  ABDetailViewController.h
//  AddressBook
//
//  Created by Mason Mei on 2/17/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ABDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *dictContactDetails;

@property (weak, nonatomic) IBOutlet UILabel *lblContactName;
@property (weak, nonatomic) IBOutlet UIImageView *imgContactImage;
@property (weak, nonatomic) IBOutlet UITableView *tblContactDetails;

- (IBAction)makeCall:(id)sender;
- (IBAction)sendSMS:(id)sender;
@end
