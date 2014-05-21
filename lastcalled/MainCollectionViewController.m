//
//  MainCollectionViewController.m
//  lastcalled
//
//  Created by David Geijer on 21/05/14.
//  Copyright (c) 2014 Witch Craft International. All rights reserved.
//

#import "MainCollectionViewController.h"

@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController

static NSString * CellIdentifier = @"CellIdentifier";

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:CellIdentifier];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return 120;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                  forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

@end
