//
//  ABGroupCell.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABGroupCell.h"

@implementation ABGroupCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setCellSelected:(BOOL)select {
    [_groupSelectedButton setTitle:@"" forState:UIControlStateNormal];
    [_groupSelectedButton setTitle:@"\u2713" forState:UIControlStateSelected];
    [_groupSelectedButton.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [_groupSelectedButton setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
    
    if(select == YES){
        [self setSelected:YES animated:YES];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [_groupSelectedButton setSelected:YES];
    } else {
        [self setSelected:NO animated:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [_groupSelectedButton setSelected:NO];
    }
}

@end
