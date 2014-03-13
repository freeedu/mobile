//
//  ABContactPickerViewController.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABContactPickerViewController.h"
#import "ABAddressBookUtils.h"

@interface ABContactPickerViewController (){
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
}

@end

@implementation ABContactPickerViewController

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
    
    
    if(_selectedContactList == NULL){
        _selectedContactList = [NSMutableArray new];
    }
    
    if (!doneButton) {
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    }
    if(!cancelButton) {
        cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction:)];
    }
    
    ABMultiplePeoplePickerController * multiplePeoplePicker = (ABMultiplePeoplePickerController *) self.navigationController;
    
    if([multiplePeoplePicker.contactPickerDelegate respondsToSelector:@selector(invokeMode)]){
        _contactInvokeMode = [multiplePeoplePicker.contactPickerDelegate invokeMode];
    }
    
    if(!_contactInvokeMode){
        _contactInvokeMode = abInvokeModeFullFunction;
    }
    
    switch (_contactInvokeMode) {
        case abInvokeModeFullFunction:
            //DO Nothing
            break;
        case abInvokeModePickerOnly:
            self.navigationItem.rightBarButtonItem = cancelButton;
            break;
        case abInvokeModeReadOnly:
            self.navigationItem.rightBarButtonItem = nil;
            break;
    }
    
    [self setContactCommunicationDelegate:self];
    
    if (_contactInvokeMode == abInvokeModeFullFunction){
        
    } else {
        [_toolBar setHidden:YES];
    }
    [self reloadAllContacts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) reloadAllContacts {
    NSLog(@"Start reload all contacts from addressbook.");
    if (_allContactList == NULL){
        _allContactList = [NSMutableArray new];
    }
    if (_filteredContactList == NULL){
        _filteredContactList = [NSMutableArray new];
    }
    
    [_allContactList removeAllObjects];
    [_filteredContactList removeAllObjects];
    
    NSArray *peopleArray = nil;
    
    if (_selectedGroups == NULL || [_selectedGroups count] == 0) {
        self.title = @"All Contacts";
        peopleArray = [[ABAddressBookUtils sharedInstance] readAllPeople];
    } else {
        if([_selectedGroups count] == 1){
            ABMGroup *group = [_selectedGroups objectAtIndex:0];
            self.title = [group groupName];
            peopleArray = [[ABAddressBookUtils sharedInstance] readPeopleWithGroup:group];
        } else {
            self.title = @"Contacts";
            peopleArray = [[ABAddressBookUtils sharedInstance] readPeopleInGroups:_selectedGroups];
        }
    }
    
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
        [_allContactList addObject:sortedSection];
    }
    
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SegueForAllGroup"]){
        ABGroupPickerViewController *groupPicker = [segue destinationViewController];
        if(_selectedGroups){
            [groupPicker initSelectedGroupsWith:_selectedGroups];
        }
        
        [groupPicker setInvokeMode:_contactInvokeMode];
        
        groupPicker.groupPickerDelegate = self;
    } else if ([[segue identifier] isEqualToString:@"SegueContactNew"]){
        ABContactNewViewController *newContact = [segue destinationViewController];
        [newContact setContact:[[ABMContact alloc] init]];
    } else if([[segue identifier] isEqualToString:@"SegueViewContact"]){
        ABContactNewViewController *newContact = [segue destinationViewController];
        
        NSIndexPath *indexPath;
        if(_searchWasActived){
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            [newContact setContact:[_filteredContactList objectAtIndex:indexPath.row]];
        } else {
            indexPath = [self.tableView indexPathForCell:sender];
            [newContact setContact:[[_allContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        }
    }
}

// ABContactBaseCommunication Protocal Section Start
-(NSArray *)prepareSMSToReceipt{
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    if([_selectedContactList count]){
        
        for (ABMContact *contact in _selectedContactList) {
            if([contact phoneNumber]){
                [phoneNumbers addObject:[contact phoneNumber]];
            }
        }
       
    }
    return phoneNumbers;
}

-(NSArray *)prepareMailToReceipt{
    NSMutableArray *emails = [NSMutableArray new];
    if([_selectedContactList count]){
        
        for (ABMContact *contact in _selectedContactList) {
            if([contact email]){
                [emails addObject:[contact email]];
            }
        }
        
    }
    return emails;
}
// ABContactBaseCommunication Protocal Section End


// ABContactBaseSearch Protocol Section Start
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
 	[_filteredContactList removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@) OR (phoneNumber CONTAINS[cd] %@)", searchText, searchText];
    for (NSArray *section in _allContactList) {
        [_filteredContactList addObjectsFromArray:[section filteredArrayUsingPredicate:predicate]];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isSearchDisplayController:tableView]){
        return 1;
    }
    return [_allContactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ABContactCellID";
    
    ABContactPeopleCell *cell = (ABContactPeopleCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ABContactPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    ABMContact *contact = nil;
    
    if([self isSearchDisplayController:tableView]){
        contact = [_filteredContactList objectAtIndex:indexPath.row];
    } else {
        contact = [[_allContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    //    //[cell setContactCellImage:[contact image]];
    if([contact image] == NULL) {
        [cell.contactImageView setImage:[UIImage imageNamed:@"male.png"]];
    } else {
        UIImage *image = [contact image];
        [cell.contactImageView setImage: image];
    }
    
    cell.contactNameLabel.text = [contact name];
    cell.contactPrimaryNumberLabel.text = [contact phoneNumber];
    
    [cell setCellSelected:contact.rowSelected];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([self isSearchDisplayController:tableView]){
        return nil;
    } else {
        return [[_allContactList objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if([self isSearchDisplayController:tableView]) {
        return nil;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if([self isSearchDisplayController:tableView]){
        return 0;
    } else {
        if(title == UITableViewIndexSearch){
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self isSearchDisplayController:tableView]){
        return 0;
    } else {
        return [[_allContactList objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self isSearchDisplayController:tableView]){
        return [_filteredContactList count];
    } else {
        return [[_allContactList objectAtIndex:section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ABMContact *contact;
    
    if ([self isSearchDisplayController:tableView]) {
        contact = [_filteredContactList objectAtIndex:indexPath.row];
    } else {
        contact = [[_allContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    contact.rowSelected = !contact.rowSelected;
    
    if(contact.rowSelected == YES){
        [_selectedContactList addObject:contact];
    } else {
        for (NSUInteger i = 0; i < [_selectedContactList count]; i++) {
            if([[_selectedContactList objectAtIndex:i] recordId] == [contact recordId]){
                [_selectedContactList removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    ABContactPeopleCell *cell = (ABContactPeopleCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell setCellSelected:contact.rowSelected];
    
    [self resetNavigationBar];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_searchWasActived){
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ABMContact *contact = [[_allContactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        for (int i = 0; i < [_selectedContactList count]; i++) {
            if([[_selectedContactList objectAtIndex:i] recordId] == [contact recordId]){
                [_selectedContactList removeObjectAtIndex:i];
                break;
            }
        }
        
        [[ABAddressBookUtils sharedInstance] removeContact:contact];
        [self reloadAllContacts];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //
    }
}


// searchbar section
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchDisplayController.searchBar setShowsCancelButton:NO];
    _searchWasActived = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchDisplayController setActive:NO animated:YES];
    _searchWasActived = NO;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchDisplayController setActive:NO animated:YES];
    _searchWasActived = NO;
    [self.tableView reloadData];
}


// End of SearchBar section.


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    if(![searchString isEqualToString:@""]){
        [self filterContentForSearchText:searchString
                                                     scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    }
    return YES;
}


-(BOOL)isSearchDisplayController:(UITableView *) tableView {
    return self.searchDisplayController.searchResultsTableView == tableView;
}

- (void)transferSelectGroups:(NSArray *)groups {
    [self setSelectedGroups:groups];
    [self reloadAllContacts];
}

-(void)doneAction:(id)sender{
    NSMutableArray *array = [NSMutableArray new];
    for (NSArray *section in _allContactList) {
        for (ABMContact *contact in section) {
            if(contact.rowSelected){
                [array addObject:contact];
            }
        }
    }
    
    if([self.navigationController isKindOfClass:[ABMultiplePeoplePickerController class]]){
        ABMultiplePeoplePickerController * multiplePeoplePicker = (ABMultiplePeoplePickerController *) self.navigationController;
        
        if([multiplePeoplePicker.contactPickerDelegate respondsToSelector:@selector(multiplePeoplePickerController:shouldContinueAfterSelectingContacts:)]){
            BOOL result = [multiplePeoplePicker.contactPickerDelegate multiplePeoplePickerController:multiplePeoplePicker shouldContinueAfterSelectingContacts:array];
            
            if(result){
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            NSLog(@"Done with selected");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)dismissAction:(id)sender {
    if([self.navigationController isKindOfClass:[ABMultiplePeoplePickerController class]]){
        ABMultiplePeoplePickerController * multiplePeoplePicker = (ABMultiplePeoplePickerController *) self.navigationController;
        
        if([multiplePeoplePicker.contactPickerDelegate respondsToSelector:@selector(multiplePeoplePickerControllerDidCancel:)]){
            [multiplePeoplePicker.contactPickerDelegate multiplePeoplePickerControllerDidCancel:multiplePeoplePicker];
        } else {
            NSLog(@"Done with selected");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)resetNavigationBar{
    if([_selectedContactList count]){
        switch (_contactInvokeMode) {
            case abInvokeModeFullFunction:
                //DO Nothing
                self.navigationItem.rightBarButtonItem = doneButton;
                break;
            case abInvokeModePickerOnly:
                self.navigationItem.rightBarButtonItem = doneButton;
                break;
            case abInvokeModeReadOnly:
                self.navigationItem.rightBarButtonItem = nil;
                break;
        }
    } else {
        switch (_contactInvokeMode) {
            case abInvokeModeFullFunction:
                //DO Nothing
                self.navigationItem.rightBarButtonItem = _addContactButton;
                break;
            case abInvokeModePickerOnly:
                self.navigationItem.rightBarButtonItem = cancelButton;
                break;
            case abInvokeModeReadOnly:
                self.navigationItem.rightBarButtonItem = nil;
                break;
        }

    }

}

- (IBAction)sendMessageToSelectedContact:(id)sender {
    [self sendSMS];
}

- (IBAction)sendEmailToSelectedContacts:(id)sender {
    [self sendMail];
}
@end
