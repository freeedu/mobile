//
//  ABContactBaseViewController.h
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol ABContactBaseCommunicationDelegate;

@interface ABContactBaseViewController : UIViewController< MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>


@property (nonatomic, strong) id<ABContactBaseCommunicationDelegate> contactCommunicationDelegate;


- (void)sendSMS;

- (void)sendMail;

-(void)call:(NSString *)receipt;
-(void) showAlertWithMessage:(NSString *) message;

@end


// Required to enabled the communication function
@protocol ABContactBaseCommunicationDelegate <NSObject>

@optional
- (NSArray *) prepareMailToReceipt;
- (NSArray *) prepareSMSToReceipt;

@end