//
//  TMListingTableViewController.m
//  trademe
//
//  Created by David Lashkhi on 10/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "TMListingTableViewController.h"
#import "TMCategory.h"
#import "TMListing.h"
#import "TMNetworkDataManager.h"


@interface TMListingTableViewController ()

@property (nonatomic, strong) TMCategory *category;
@property (nonatomic, strong) NSArray *listingsArray;
@property (nonatomic, strong) NSCache *cache;


@end

@implementation TMListingTableViewController

static NSString * const reuseIdentifier = @"ListTableViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cache = [NSCache new];
}

- (void)injectCategory:(TMCategory *)category {
    self.category = category;
    [self fetchListingsWithParameters:self.category.number isKeyword:NO];
}

- (void)searchFomKeywords:(NSString *)keywords{
    [self fetchListingsWithParameters:keywords isKeyword:YES];
}

- (void)fetchListingsWithParameters:(NSString *)parameter isKeyword:(BOOL)isKeyword {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[TMNetworkDataManager sharedInstance] fetchListingsForParameter:parameter isSearchByKeywords:isKeyword andCompletionBlock:^(NSArray *listings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.listingsArray = listings;
                [self.tableView reloadData];
            });
        } failure:^(NSError *error) {
            //show some error
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listingsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TMListing *listing = self.listingsArray[indexPath.row];
    cell.textLabel.text = listing.title;
    cell.detailTextLabel.text = listing.priceDisplay;
    
    NSString *keyString = [NSString stringWithFormat:@"listing-%ld", (long)indexPath.row];
    if ([self.cache objectForKey:keyString]) {
        cell.imageView.image = [self.cache objectForKey:keyString];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[TMNetworkDataManager sharedInstance] fetchImageFromUrl:listing.pictureHref onDidLoad:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell && image) { //image checking was added as temp bug fixing
                        updateCell.imageView.image = image;
                        [self.cache setObject:image forKey:keyString];
                    }
                });
            }];
        });
    }
    return cell;
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
