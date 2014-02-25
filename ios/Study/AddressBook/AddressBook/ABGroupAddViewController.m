//
//  ABGroupAddViewController.m
//  AddressBook
//
//  Created by Mason Mei on 2/20/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABGroupAddViewController.h"
#import "ABAddressBookUtils.h"

@interface ABGroupAddViewController ()

@end

@implementation ABGroupAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createGroup:(id)sender {
    [[ABAddressBookUtils sharedInstance] createGroup:_groupName.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
