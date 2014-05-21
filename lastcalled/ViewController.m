//
//  ViewController.m
//  lastcalled
//
//  Created by David Geijer on 21/05/14.
//  Copyright (c) 2014 Witch Craft International. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController 
@synthesize addressBookNum;
/**
 *  Load contact data from addressbok this should be done asynch 
 *
 */
- (void) getAllContacts
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            ABAddressBookRef addressBook = ABAddressBookCreate( );
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
             NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
             NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            
             NSLog(@"Name:%@ %@", firstName, lastName);
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            [[UIDevice currentDevice] name];
            
            NSLog(@"\n%@\n", [[UIDevice currentDevice] name]);
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                /* There seems to be a problem saving numbers to addressBokNum.
                */
                addressBookNum = [addressBookNum stringByAppendingFormat: @":%@",phoneNumber];
            }  
        }
        NSLog(@"AllNumber:%@",addressBookNum);
    }
    else {
        // Send an alert telling user to change privacy setting in settings app
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Test ");
    
    [self getAllContacts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
