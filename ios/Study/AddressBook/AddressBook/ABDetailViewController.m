//
//  ABDetailViewController.m
//  AddressBook
//
//  Created by Mason Mei on 2/17/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABDetailViewController.h"

@interface ABDetailViewController ()
-(void)populateContactData;
-(void)performPhoneAction:(BOOL)shouldMakeCall;
-(void)makeCallToNumber:(NSString *)numberToCall;
-(void)sendSMSToNumber:(NSString *)numberToSend;
@end

@implementation ABDetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	[_tblContactDetails setDelegate:self];
    [_tblContactDetails setDataSource:self];
    
    [self populateContactData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateContactData{
    NSString *contactFullName = [NSString stringWithFormat:@"%@ %@", [_dictContactDetails objectForKey:@"firstname"], [_dictContactDetails objectForKey:@"lastname"]];
    [_lblContactName setText:contactFullName];
    
    if([_dictContactDetails objectForKey:@"image"] != nil){
        [_imgContactImage setImage:[UIImage imageWithData:[_dictContactDetails objectForKey:@"image"]]];
        [_tblContactDetails reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 || section == 1){
        return 2;
    }
    else{
        return 3;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Phone Numbers";
            break;
        case 1:
            return @"Email Address";
            break;
        case 2:
            return @"Address Info";
            break;
        default:
            return @"";
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *cellText = @"";
    NSString *detailText = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"mobileNumber"];
                    detailText = @"Mobile Number";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"homeNumber"];
                    detailText = @"Home Number";
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"homeEmail"];
                    detailText = @"Home E-mail";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"workEmail"];
                    detailText = @"Work E-mail";
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"address"];
                    detailText = @"Street Address";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"zipCode"];
                    detailText = @"ZIP Code";
                    break;
                case 2:
                    cellText = [_dictContactDetails objectForKey:@"city"];
                    detailText = @"City";
                    break;
            }
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

-(void)performPhoneAction:(BOOL)shouldMakeCall{
    if(![[_dictContactDetails objectForKey:@"mobileNumber"] isEqualToString:@""] &&
       ![[_dictContactDetails objectForKey:@"homeNumber"] isEqualToString:@""]){
        UIActionSheet *phoneOptions = [[UIActionSheet alloc]initWithTitle:@"Pick a number" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"" otherButtonTitles:[_dictContactDetails objectForKey:@"mobileNumber"],[_dictContactDetails objectForKey:@"homeNumber"], nil];
        [phoneOptions showInView:self.view];
        if(shouldMakeCall){
            [phoneOptions setTag:101];
        }else{
            [phoneOptions setTag:102];
        }
    } else {
        NSString *selectedPhoneNumber = nil;
        
        if(![[_dictContactDetails objectForKey:@"mobileNumber"] isEqualToString:@""]){
            selectedPhoneNumber = [_dictContactDetails objectForKey:@"mobileNumber"];
        }
        
        if(![[_dictContactDetails objectForKey:@"homeNumber"] isEqualToString:@""]){
            selectedPhoneNumber = [_dictContactDetails objectForKey:@"homeNumber"];
        }
        
        if(selectedPhoneNumber != nil){
            if(shouldMakeCall){
                [self makeCallToNumber:selectedPhoneNumber];
            } else{
                [self sendSMSToNumber:selectedPhoneNumber];
            }
        }
    }
}

-(void)makeCallToNumber:(NSString *)numberToCall{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",numberToCall]];;
    if([[UIApplication sharedApplication] canOpenURL:phoneUrl]){
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

-(void)sendSMSToNumber:(NSString *)numberToSend{
    if(![MFMessageComposeViewController canSendText]){
        NSLog(@"Unable to send SMS msg");
    } else {
        MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
        [sms setMessageComposeDelegate:self];
        [sms setRecipients:[NSArray arrayWithObjects:numberToSend, nil]];
        [sms setBody:@"This is a SMS msg from :)"];
        [self presentViewController:sms animated:YES completion:nil];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 3){
        NSString * selectedPhoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if([actionSheet tag] == 101){
            [self makeCallToNumber:selectedPhoneNumber];
        } else {
            [self sendSMSToNumber:selectedPhoneNumber];
        }
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)makeCall:(id)sender {
    [self performPhoneAction:YES];
}

- (IBAction)sendSMS:(id)sender {
    [self performPhoneAction:NO];
}
@end
