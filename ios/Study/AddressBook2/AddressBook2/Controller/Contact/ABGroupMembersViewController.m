//
//  ABGroupMembersViewController.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABGroupMembersViewController.h"
#import "ABMultiplePeoplePickerController.h"
#import "ABContactPickerViewController.h"
#import "ABContactNewViewController.h"
#import "ABAddressBookUtils.h"
#import "ABContactPeopleCell.h"

@interface ABGroupMembersViewController () <ABMultiplePeoplePickerControllerDelegate>{
    NSMutableArray *members;
    NSMutableArray *selectedMembers;
    ABMultiplePeoplePickerController *multiplePeoplePickerController;
}

@end

@implementation ABGroupMembersViewController

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
    [self setContactCommunicationDelegate:self];
    if(!members){
        members = [NSMutableArray new];
    }
    
    if(!selectedMembers){
        selectedMembers = [NSMutableArray new];
    }
    
    [self loadMemberInGroup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadMemberInGroup {
    if (members == NULL){
        members = [NSMutableArray new];
    }
    
    [members removeAllObjects];
    
    self.title = [_group groupName];
    NSArray *peopleArray = [[ABAddressBookUtils sharedInstance] readPeopleWithGroup:_group];
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    SEL sorter = ABPersonGetSortOrdering() == kABPersonSortByFirstName ? NSSelectorFromString(@"firstLastSort") : NSSelectorFromString(@"lastFirstSort");
    
    for (ABMContact *contact in peopleArray) {
        NSInteger sect = [theCollation sectionForObject:contact collationStringSelector:sorter];
        contact.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (ABMContact *contact in peopleArray) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:sorter];
        [members addObject:sortedSection];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [members count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[members objectAtIndex:section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{        return [[members objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[members objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ABGroupMembersViewControllerCell";
    ABContactPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ABMContact *contact = [[members objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    if([contact image] == NULL){
        cell.contactImageView.image = [UIImage imageNamed:@"male.png"];
    } else {
        cell.contactImageView.image = [contact image];
    }
    
    cell.contactNameLabel.text = [contact name];
    cell.contactPrimaryNumberLabel.text = [contact phoneNumber];
    [cell setCellSelected:contact.rowSelected];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ABMContact *contact = [[members objectAtIndex:indexPath.section] objectAtIndex: indexPath.row];
        [[ABAddressBookUtils sharedInstance] removeMember:contact fromGroup:_group];
        [self loadMemberInGroup];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ABMContact *contact = [[members objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    contact.rowSelected = !contact.rowSelected;
    
    if(contact.rowSelected == YES){
        [selectedMembers addObject:contact];
    } else {
        for (NSUInteger i = 0; i < [selectedMembers count]; i++) {
            if([[selectedMembers objectAtIndex:i] recordId] == [contact recordId]){
                [selectedMembers removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    ABContactPeopleCell *cell = (ABContactPeopleCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell setCellSelected:contact.rowSelected];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)multiplePeoplePickerController:(ABMultiplePeoplePickerController *)peoplePicker shouldContinueAfterSelectingContacts:(NSArray *)contacts{
    [[ABAddressBookUtils sharedInstance] addMembers:contacts toGroup:_group];
    [self loadMemberInGroup];
    return NO;
}

-(void)multiplePeoplePickerControllerDidCancel:(ABMultiplePeoplePickerController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

-(ABContactInvokeMode)invokeMode{
    return abInvokeModePickerOnly;
}

-(NSArray *)prepareSMSToReceipt{
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    if([selectedMembers count]){
         for (ABMContact *contact in selectedMembers) {
             if([contact phoneNumber]){
                [phoneNumbers addObject:[contact phoneNumber]];
            }
        }
    }
    return phoneNumbers;
}

-(NSArray *)prepareMailToReceipt{
    NSMutableArray *emails = [NSMutableArray new];
    if([selectedMembers count]){
        for (ABMContact *contact in selectedMembers) {
            if([contact email]){
                [emails addObject:[contact email]];
            }
        }
    }
    return emails;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"SegueViewMember"]){
        ABContactNewViewController *newContact = [segue destinationViewController];
    
        NSIndexPath *indexPath;
    
        indexPath = [self.tableView indexPathForCell:sender];
        [newContact setContact:[[members objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
}

- (IBAction)sendSMSToSelectedContacts:(id)sender {
    [self sendSMS];
}

- (IBAction)sendEmailToSelectedContacts:(id)sender {
    [self sendMail];
}

- (IBAction)showContactsForSelect:(id)sender {
    multiplePeoplePickerController = [[ABMultiplePeoplePickerController alloc] init];
    multiplePeoplePickerController.contactPickerDelegate = self;

    
    [self presentViewController:multiplePeoplePickerController animated:YES completion:nil];
}
@end
