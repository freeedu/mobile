//
//  ABContactMultiValueCell.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseCell.h"

@interface ABContactMultiValueCell : ABContactBaseCell

@property (nonatomic, weak) IBOutlet UITextField *contactMultiValueTagTextField;
@property (nonatomic, weak) IBOutlet UITextField *contactMultiValueValueTextField;

@end
