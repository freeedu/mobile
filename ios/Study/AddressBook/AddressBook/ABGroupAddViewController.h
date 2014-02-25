//
//  ABGroupAddViewController.h
//  AddressBook
//
//  Created by Mason Mei on 2/20/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABGroupAddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *groupName;

- (IBAction)createGroup:(id)sender;
@end
