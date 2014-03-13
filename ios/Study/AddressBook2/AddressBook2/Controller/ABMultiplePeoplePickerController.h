//
//  ABMultiplePeoplePickerController.h
//  AddressBook
//
//  Created by Mason Mei on 2/27/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTypeDefine.h"

@protocol ABMultiplePeoplePickerControllerDelegate;

@interface ABMultiplePeoplePickerController : UINavigationController

@property (nonatomic, strong) id<ABMultiplePeoplePickerControllerDelegate> contactPickerDelegate;

@end


@protocol ABMultiplePeoplePickerControllerDelegate <NSObject>

// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)multiplePeoplePickerControllerDidCancel:(ABMultiplePeoplePickerController *) peoplePicker;

// Called after a person has been selected by the user.
- (BOOL)multiplePeoplePickerController:(ABMultiplePeoplePickerController *)peoplePicker shouldContinueAfterSelectingContacts:(NSArray *) contacts;

@required
-(ABContactInvokeMode) invokeMode;

@end