//
//  ABGroupNewViewController.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABGroupNewViewController.h"
#import "ABAddressBookUtils.h"

@interface ABGroupNewViewController (){
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
}

@end

@implementation ABGroupNewViewController

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
    if (!doneButton){
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createGroup)];
    }
    
    if (!cancelButton){
        cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCreateGroup)];
    }
    
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setGroupImage:(id)sender {
    
    
}

- (IBAction)onEditingChanged:(id)sender {
    NSString *grouName = [self.groupNameFirstTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([grouName isEqualToString:@""]){
        self.navigationItem.rightBarButtonItem = cancelButton;
    } else {
        self.navigationItem.rightBarButtonItem = doneButton;
    }
}

- (void)createGroup{
    NSString *groupNameFirst = [self.groupNameFirstTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *groupNameAdditional = [self.groupNameAdditionalTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *groupName;
    if (![groupNameAdditional isEqualToString:@""]) {
        groupName = [NSString stringWithFormat:@"%@(%@)", groupNameFirst, groupNameAdditional];
    } else {
        groupName = groupNameFirst;
    }
    
    if ([[ABAddressBookUtils sharedInstance] checkExistGroupWithName:groupName]) {
        NSString *message = [NSString stringWithFormat:@"Group with name %@ already exist.", groupName];
        [self showAlertWithMessage:message];
    } else {
        [[ABAddressBookUtils sharedInstance] createGroupWithName:groupName];
        [self.groupNewDelegate refreshGroups];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelCreateGroup{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
