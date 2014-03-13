//
//  ABMultiplePeoplePickerController.m
//  AddressBook
//
//  Created by Mason Mei on 2/27/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#import "ABMultiplePeoplePickerController.h"

@interface ABMultiplePeoplePickerController ()

@end

@implementation ABMultiplePeoplePickerController

-(id)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    if(self){
        //Other info
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


@end
