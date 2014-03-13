//
//  ABContactBaseCell.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABContactCellDelegate ;

@interface ABContactBaseCell : UITableViewCell

@property (nonatomic, strong) id<ABContactCellDelegate> contactCellDelegate;

@end

@protocol ABContactCellDelegate <NSObject>

- (void)fillCellWithData;

@end