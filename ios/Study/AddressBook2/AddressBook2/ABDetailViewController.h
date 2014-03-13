//
//  ABDetailViewController.h
//  AddressBook2
//
//  Created by Mason Mei on 3/11/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
