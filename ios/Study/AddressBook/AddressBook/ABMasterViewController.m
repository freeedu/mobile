//
//  ABMasterViewController.m
//  AddressBook
//
//  Created by Mason Mei on 2/17/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABMasterViewController.h"

#import "ABDetailViewController.h"
#import "ABGroupViewController.h"

@interface ABMasterViewController ()

@property(nonatomic, strong) NSMutableArray *arrContactsData;

@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;

@end

@implementation ABMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddressBook)];
//    self.navigationItem.rightBarButtonItem = addButton;
//    
//    UIBarButtonItem *groupButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showGroupController)];
//    
//    NSArray *rightBarButtonItems = [NSArray arrayWithObjects:addButton, groupButton, nil];
//    
//    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
 
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrContactsData) {
        return _arrContactsData.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *contactInfoDict = [_arrContactsData objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contactInfoDict objectForKey:@"firstname"], [contactInfoDict objectForKey:@"lastname"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSDictionary *contactDetailsDictionary = [_arrContactsData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [[segue destinationViewController] setDictContactDetails:contactDetailsDictionary];
    }
}

//ABPeoplePickerNavigationControllerDelegate section
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc] initWithObjects:@[@"", @"", @"" ,@"", @"",@"", @"", @"", @""] forKeys:@[@"firstname", @"lastname", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
    
    CFTypeRef generalTypeRef;
    generalTypeRef = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if(generalTypeRef){
        [contactInfoDict setObject:(__bridge NSString *)generalTypeRef forKey:@"firstname"];
        CFRelease(generalTypeRef);
    }
    
    generalTypeRef = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if(generalTypeRef){
        [contactInfoDict setObject:(__bridge NSString *)generalTypeRef forKey:@"lastname"];
        CFRelease(generalTypeRef);
    }
    
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i = 0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo){
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if(CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo){
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneValue);
        CFRelease(currentPhoneLabel);
    }
    CFRelease(phonesRef);
    
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i = 0; i < ABMultiValueGetCount(emailsRef); i++) {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        
        if(CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo){
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"workEmail"];
        }
        
        if(CFStringCompare(currentEmailLabel, kABHomeLabel, 0) == kCFCompareEqualTo){
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"homeEmail"];
        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
    }
    
    ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
    if(ABMultiValueGetCount(addressRef) > 0){
        NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *) kABPersonAddressStreetKey] forKey:@"address"];
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *) kABPersonAddressCityKey] forKey:@"city"];
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *) kABPersonAddressZIPKey] forKey:@"zipCode"];
    }
    CFRelease(addressRef);
    
    if(ABPersonHasImageData(person)){
        NSData *contactImgData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        [contactInfoDict setObject:contactImgData forKey:@"image"];
    }
    
    if(_arrContactsData == nil){
        _arrContactsData = [[NSMutableArray alloc] init];
    }
    [_arrContactsData addObject:contactInfoDict];
    
    [self.tableView reloadData];
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (IBAction)showAddressBook:(id)sender {
    [self showAddressBook];
}

-(void)showAddressBook{
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}

-(void)showGroupController{
    ABGroupViewController *groupController = [[ABGroupViewController alloc] init];
    [self presentViewController:groupController animated:YES completion:nil];
}

@end
