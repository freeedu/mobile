//
//  ABContactPeopleCell.m
//  AddressBook2
//
//  Created by Mason Mei on 3/11/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactPeopleCell.h"

@implementation ABContactPeopleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellSelected:(BOOL)select {
    [_contactSelectedButton setTitle:@"" forState:UIControlStateNormal];
    [_contactSelectedButton setTitle:@"\u2713" forState:UIControlStateSelected];
    [_contactSelectedButton.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [_contactSelectedButton setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
    
    if(select == YES){
        [self setSelected:YES animated:YES];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [_contactSelectedButton setSelected:YES];
    } else {
        [self setSelected:NO animated:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [_contactSelectedButton setSelected:NO];
    }
}

@end
