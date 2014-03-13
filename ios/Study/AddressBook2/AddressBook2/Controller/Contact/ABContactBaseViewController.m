//
//  ABContactBaseViewController.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactBaseViewController.h"

@interface ABContactBaseViewController (){
    BOOL searchEnabled;
    BOOL searchWasActived;
}

@end

@implementation ABContactBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// section for message and email.
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSLog(@"Result : %u", result);
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)sendMail{
    NSArray *receipts = [_contactCommunicationDelegate prepareMailToReceipt];
    if([receipts count]){
        if(![MFMailComposeViewController canSendMail]){
            NSLog(@"Unable to send Email");
        } else {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setMailComposeDelegate:self];
            [mailController setToRecipients:receipts];
            NSLog(@"Send Email to %lu contacts", (unsigned long)[receipts count]);
            [self presentViewController:mailController animated:YES completion:nil];
        }
    } else {
        [self showAlertWithMessage:@"No Contact has Email."];
    }
}

-(void)sendSMS{
    NSArray *receipts = [_contactCommunicationDelegate prepareSMSToReceipt];
    if([receipts count]){
        if(![MFMessageComposeViewController canSendText]){
            NSLog(@"Unable to send SMS msg");
        } else {
            MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
            [sms setMessageComposeDelegate:self];
            [sms setRecipients:receipts];
            NSLog(@"Send sms to %lu contacts", (unsigned long)[receipts count]);
            [self presentViewController:sms animated:YES completion:nil];
        }
    } else {
        [self showAlertWithMessage:@"No Contact to Send Message."];
    }
}

-(void)call:(NSString *)receipt {
    if(receipt != NULL && ![receipt isEqualToString:@""]){
        NSLog(@"Start to Call");
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSMutableString *mutableString = [NSMutableString new];
    
        for (int i = 0; i < [receipt length]; i++) {
            if([characterSet characterIsMember:[receipt characterAtIndex:i]]){
                [mutableString appendString:[NSString stringWithFormat:@"%c", [receipt characterAtIndex:i]]];
            }
        }
    
        NSString *phoneToCall = [NSString stringWithFormat:@"telprompt://%@", mutableString];
        NSURL *url = [NSURL URLWithString:phoneToCall];
    
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [self showAlertWithMessage:@"No Contact to Call."];
    }
}

-(void) showAlertWithMessage:(NSString *) message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Fix it!" otherButtonTitles: nil];
    [alertView show];
}

@end
