//
//  ABContactBasicInfoCell.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseCell.h"

@interface ABContactBasicInfoCell : ABContactBaseCell

@property (weak, nonatomic) IBOutlet UIButton *contactImageButton;
@property (weak, nonatomic) IBOutlet UITextField *contactFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactLastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactCompanyTextField;

- (IBAction)changeContactImage:(id)sender;

@end
