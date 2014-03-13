//
//  ABGroupNewViewController.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseViewController.h"

@protocol ABGroupNewDelegate;

@interface ABGroupNewViewController : ABContactBaseViewController

@property (nonatomic, weak) id<ABGroupNewDelegate> groupNewDelegate;

@property (weak, nonatomic) IBOutlet UIButton *groupImageButton;

@property (weak, nonatomic) IBOutlet UITextField *groupNameFirstTextField;

@property (weak, nonatomic) IBOutlet UITextField *groupNameAdditionalTextField;
@property (weak, nonatomic) IBOutlet UITextView *groupDescriptionTextView;
- (IBAction)setGroupImage:(id)sender;
- (IBAction)onEditingChanged:(id)sender;

@end


@protocol ABGroupNewDelegate <NSObject>

@required
-(void) refreshGroups;

@end