//
//  ABContactBaseCell.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseCell.h"

@implementation ABContactBaseCell

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

@end
