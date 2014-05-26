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
#import "Records.h"
@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController
@synthesize addressBookNum,peopleInContactList, managedObjectContext, fetchedRecordsArray;
static NSString *CellIdentifier = @"Cell";

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.backgroundColor = [UIColor blackColor];
    UICollectionViewFlowLayout *layout= [[ASHSpringyCollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    /* Fetch records
     *
    */
    self.fetchedRecordsArray = [appDelegate getAllPhoneBookRecords];
    
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
             *      What does invalidateLayout ?
             */
             //[self.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.fetchedRecordsArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hiq_hi_res.gif"]];
    [imgView setFrame:cell.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundColor = [UIColor whiteColor];
    [cell addSubview:imgView];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath %ld", (long)indexPath.row);
    CGSize cellSize = CGSizeMake(90.0, 130.0);

    return cellSize;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /**
     *      Add logik here that gets correct number for specifik cell.
     *
     **/
    
    NSString *number = @"";
    NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
    NSURL *phoneUrl = [NSURL URLWithString:phoneNumber];
  
    if([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    else {
        //Show error message to user, etc.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Youre device cant call ppl." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertView show];
    }
}


        /**
         *  Load contact data from addressbok this should be done asynch
         *
         **/

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
            
            [self addPhoneBookEntry:firstName phoneNumber:@"0734481300"];
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
- (void)addPhoneBookEntry:(NSString *) name phoneNumber: (NSString*) phoneNumber
{
    // Add Entry to PhoneBook Data base and reset all fields
    
    //  1
    Records * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Records"
                                                      inManagedObjectContext:self.managedObjectContext];
    //  2
    newEntry.name = @"Test name";
    newEntry.phoneNumber = @"0734481300";
   
    //  3
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
  
}



@end
