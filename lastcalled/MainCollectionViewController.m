//
//  MainCollectionViewController.m
//  lastcalled
//
//  Created by David Geijer on 21/05/14.
//  Copyright (c) 2014 Witch Craft International. All rights reserved.
//

#import "MainCollectionViewController.h"
#import <AddressBook/AddressBook.h>
#import "ASHSpringyCollectionViewFlowLayout.h"
#import "AppDelegate.h"
@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController
@synthesize addressBookNum,peopleInContactList;
static NSString *CellIdentifier = @"Cell";

-(void)viewDidLoad
{
    [super viewDidLoad];
   
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout= [[ASHSpringyCollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    
    [self getAllContacts];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
            /**
             *What does invalidateLayout ?
             */
             //[self.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}
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
            
            
            /*for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
             
                addressBookNum = [addressBookNum stringByAppendingFormat: @":%@",phoneNumber];
            }
             */
        }
    }
    else {
        // Send an alert telling user to change privacy setting in settings app
    }
}
- (void) saveDataToPresistentStore{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
   
    

    // NSManagedObjectContext *context =
    //[appDelegate managedObjectContext];
    
    /*NSManagedObject *newContact;
    newContact = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Contacts"
                  inManagedObjectContext:context];
    [newContact setValue: _name.text forKey:@"name"];
    [newContact setValue: _address.text forKey:@"address"];
    [newContact setValue: _phone.text forKey:@"phone"];
    _name.text = @"";
    _address.text = @"";
    _phone.text = @"";
    NSError *error;
    [context save:&error];
    _status.text = @"Contact saved";*/
}

@end
