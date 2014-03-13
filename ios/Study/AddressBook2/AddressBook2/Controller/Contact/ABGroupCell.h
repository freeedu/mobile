//
//  ABGroupCell.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactSelectableCell.h"

@interface ABGroupCell : ABContactSelectableCell

@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameSecondLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupSelectedButton;

-(void)setCellSelected:(BOOL)selected;

@end
