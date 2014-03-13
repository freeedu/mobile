//
//  ABContactPeopleCell.h
//  AddressBook2
//
//  Created by Mason Mei on 3/11/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABContactPeopleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPrimaryNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactSelectedButton;

-(void)setCellSelected:(BOOL)select ;
@end
