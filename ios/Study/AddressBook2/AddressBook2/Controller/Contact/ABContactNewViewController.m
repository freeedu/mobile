//
//  ABContactNewViewController.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactNewViewController.h"
#import "ABContactMultiValueCell.h"
#import "ABContactBasicInfoCell.h"
#import "ABMMultiValue.h"

@interface ABContactNewViewController (){
    NSDateFormatter *formatter;
    BOOL editing;
    
    NSMutableArray *displayData;
    NSInteger phoneSection;
}

@end

@implementation ABContactNewViewController

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
    [self prepareData];
}

- (void) prepareData {
    if (formatter == NULL){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    phoneSection = 1;
    
    if(!displayData){
        displayData = [NSMutableArray new];
    }
    
    if([_contact birthday]){
        [displayData addObject:[_contact birthday]];
        phoneSection ++;
    }
    if([[_contact allPhones] count]){
        [displayData addObject:[_contact allPhones]];
    } else {
        phoneSection = -1;
    }
    if([[_contact allEmails] count]){
        [displayData addObject:[_contact allEmails]];
    }
    if([[_contact allUrls] count]){
        [displayData addObject:[_contact allUrls]];
    }
    if([[_contact allAnniversary] count]){
        [displayData addObject:[_contact allAnniversary]];
    }
    
    if([[_contact allSocials] count]){
        [displayData addObject:[_contact allSocials]];
    }
    if([[_contact allInstantMessages] count]){
        [displayData addObject:[_contact allInstantMessages]];
    }
    if([[_contact allAddress] count]){
        [displayData addObject:[_contact allAddress]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [displayData count] + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    } else {
        NSObject *object = [displayData objectAtIndex:(section - 1)];
        if([object isMemberOfClass:[ABMMultiValue class]]){
            return 1;
        } else {
            NSArray *multivalues = (NSArray *)object;
            return [multivalues count];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 132;
    } else if(indexPath.section < [displayData count]){
        return 44;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    } else {
        return 15;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editing){
        
    } else {
        if(indexPath.section == phoneSection) {
            ABContactMultiValueCell *cell = (ABContactMultiValueCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [self call:cell.contactMultiValueValueTextField.text];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ABContactBasicInfoCell *cell = (ABContactBasicInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactBasic" forIndexPath:indexPath];
        
        if([_contact image]){
            [cell.contactImageButton.imageView setImage:[_contact image]];
        } else {
            [cell.contactImageButton.imageView setImage:[UIImage imageNamed:@"male.png"]];
        }
        
        cell.contactFirstNameTextField.text = [_contact firstname];
        cell.contactLastNameTextField.text = [_contact lastname];
        cell.contactCompanyTextField.text = [_contact companyName];
        
        [cell.contactCompanyTextField setEnabled:editing];
        [cell.contactFirstNameTextField setEnabled:editing];
        [cell.contactLastNameTextField setEnabled:editing];
        
        [cell setEditing:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ABContactMultiValueCell *cell = (ABContactMultiValueCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ContactMulti" forIndexPath:indexPath];
        
        [cell.contactMultiValueTagTextField setEnabled:editing];
        [cell.contactMultiValueTagTextField setFont:[UIFont boldSystemFontOfSize:14]];
        
        [cell.contactMultiValueValueTextField setEnabled:editing];
        
    
        NSObject *object = [displayData objectAtIndex:(indexPath.section - 1)];
        
        ABMMultiValue * multiValue;
        if([object isMemberOfClass:[ABMMultiValue class]]){
            multiValue = (ABMMultiValue *) object;
        } else {
            NSArray *array = (NSArray *)object;
            multiValue = [array objectAtIndex:indexPath.row];
        }
        
        if ([multiValue humanReadableLabel] != NULL && ![[multiValue humanReadableLabel] isEqualToString:@""]) {
            cell.contactMultiValueTagTextField.text = [multiValue humanReadableLabel];
        } else {
            cell.contactMultiValueTagTextField.text = [multiValue label];
        }
        
        if([multiValue stringValue] != NULL){
            cell.contactMultiValueValueTextField.text = [multiValue stringValue];
        } else if([multiValue dateValue] != NULL){
            cell.contactMultiValueValueTextField.text = [formatter stringFromDate:[multiValue dateValue]];
        } else if([multiValue dictionaryValue] != NULL){
            cell.contactMultiValueTagTextField.text = [[multiValue dictionaryValue] objectForKey:@"service"];
            cell.contactMultiValueValueTextField.text = [[multiValue dictionaryValue] objectForKey:@"username"];
        }
        return cell;
    }
    
    return nil;
}

-(NSArray *)prepareMailToReceipt{
    NSMutableArray *emails = [NSMutableArray new];
    
    if(_contact){
        if([_contact email]){
            [emails addObject:[_contact email]];
        }
    }
    return emails;
}

-(NSArray *)prepareSMSToReceipt{
    NSMutableArray *phones = [NSMutableArray new];
    
    if(_contact){
        if([_contact phoneNumber]){
            [phones addObject:[_contact phoneNumber]];
        }
    }
    return phones;
}

- (IBAction)sendSMSToContact:(id)sender {
    [self sendSMS];
}

- (IBAction)callContact:(id)sender {
    [self call:[_contact phoneNumber]];
}

- (IBAction)sendEmailToContact:(id)sender {
    [self sendMail];
}

@end
