//
//  ABGroupPickerViewController.m
//  AddressBook
//
//  Created by Mason Mei on 3/9/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABGroupPickerViewController.h"
#import "ABGroupNewViewController.h"
#import "ABGroupMembersViewController.h"
#import "ABAddressBookUtils.h"
#import "ABGroupCell.h"

@interface ABGroupPickerViewController (){
    ABContactInvokeMode contactInvokeMode;
}

@property (nonatomic, strong) NSMutableArray *selectedGroupList;
@property (nonatomic, strong) NSArray *allGroupList;

@end

@implementation ABGroupPickerViewController

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
    if(contactInvokeMode != abInvokeModeFullFunction){
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self reloadAllGroup];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.groupPickerDelegate transferSelectGroups:_selectedGroupList];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadAllGroup {
    _allGroupList = [[ABAddressBookUtils sharedInstance] readAllGroup];
    if (_selectedGroupList){
        for (ABMGroup *group in _selectedGroupList) {
            for (ABMGroup *g in _allGroupList) {
                if([g.groupName isEqualToString:group.groupName]){
                    [g setRowSelected:YES];
                    break;
                }
            }
        }
    } else {
        _selectedGroupList = [NSMutableArray new];
    }
    
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ABGroupPickerViewControllerCell";
    ABGroupCell *cell = (ABGroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[ABGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ABMGroup *group = [_allGroupList objectAtIndex:indexPath.row];
    
    
    cell.groupImageView.image = [UIImage imageNamed:@"group.png"];
    cell.groupNameFirstLabel.text = [group groupNameFirstPart];
    cell.groupNameSecondLabel.text = [group groupNameSecondPart];
    
    [cell setCellSelected:group.rowSelected];
    
    if(contactInvokeMode != abInvokeModeFullFunction){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_allGroupList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ABMGroup *group = [_allGroupList objectAtIndex:indexPath.row];
    
    group.rowSelected  = !group.rowSelected;
    
    ABGroupCell *cell = (ABGroupCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setCellSelected:group.rowSelected];
    
    if(group.rowSelected == YES){
        [_selectedGroupList addObject:group];
    } else {
        for (NSUInteger i = 0; i < [_selectedGroupList count]; i++) {
            if([[[_selectedGroupList objectAtIndex:i] groupName] isEqualToString:[group groupName]]){
                [_selectedGroupList removeObjectAtIndex:i];
                break;
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ABMGroup *group = [_allGroupList objectAtIndex:indexPath.row];
        
        for (NSUInteger i = 0; i < [_selectedGroupList count]; i++) {
            if([[[_selectedGroupList objectAtIndex:i] groupName] isEqualToString:[group groupName]]){
                [_selectedGroupList removeObjectAtIndex:i];
                break;
            }
        }
        
        [[ABAddressBookUtils sharedInstance] deleteGroup:group];
        
        [self reloadAllGroup];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueForGroupNew"]){
        ABGroupNewViewController *groupNew = [segue destinationViewController];
        groupNew.groupNewDelegate = self;
    } else if([[segue identifier] isEqualToString:@"SegueForGroupMembers"]){
        ABGroupMembersViewController *groupMemeber = [segue destinationViewController];
        NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
        groupMemeber.group = [_allGroupList objectAtIndex:indexpath.row];
    }
}


-(NSArray *)prepareSMSToReceipt{
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    
    if([_selectedGroupList count]){
        NSArray *memebers = [[ABAddressBookUtils sharedInstance] readPeopleInGroups:_selectedGroupList];
        
        if(memebers != NULL){
            for (ABMContact *contact in memebers) {
                if([contact phoneNumber]){
                    [phoneNumbers addObject:[contact phoneNumber]];
                }
            }
        }
    }
    return phoneNumbers;
}


-(NSArray *)prepareMailToReceipt{
    NSMutableArray *emails = [NSMutableArray new];
    
    if([_selectedGroupList count]){
        NSArray *memebers = [[ABAddressBookUtils sharedInstance] readPeopleInGroups:_selectedGroupList];
        
        if(memebers != NULL){
            for (ABMContact *contact in memebers) {
                if([contact email]){
                    [emails addObject:[contact email]];
                }
            }
        }
    }
    return emails;
}

-(void)refreshGroups{
    [self reloadAllGroup];
}

-(void)setInvokeMode: (ABContactInvokeMode) invokeMode {
    contactInvokeMode = invokeMode;
}

-(void)initSelectedGroupsWith:(NSArray *)groups{
    if (_selectedGroupList == NULL){
        _selectedGroupList = [NSMutableArray new];
    }
    if( groups != NULL){
        [_selectedGroupList addObjectsFromArray:groups];
    }
}

- (IBAction)sendMessageToSelectedGroups:(id)sender {
    [self sendSMS];
}

- (IBAction)sendEmailToSelectedGroups:(id)sender {
    [self sendMail];
}





@end
