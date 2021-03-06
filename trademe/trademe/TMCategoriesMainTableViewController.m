//
//  TMCategoriesMainTableViewController.m
//  trademe
//
//  Created by David Lashkhi on 09/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "TMCategoriesMainTableViewController.h"
#import "TMNetworkDataManager.h"
#import "TMCategory.h"
#import "TMSubcategoriesTableViewController.h"
#import "TMListingTableViewController.h"

@interface TMCategoriesMainTableViewController ()

@property (nonatomic, assign) BOOL shouldCollapseDetailViewController;
@property (nonatomic, strong) NSArray *baseCategories;

@end

@implementation TMCategoriesMainTableViewController

static NSString * const reuseIdentifier = @"CategoriesTableViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldCollapseDetailViewController = true;
    self.splitViewController.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[TMNetworkDataManager sharedInstance] fetchCategoriesWithSuccess:^(NSArray *categories) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.baseCategories = categories;
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
    return self.baseCategories.count;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.shouldCollapseDetailViewController = false;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TMCategory *baseCategory = self.baseCategories[indexPath.row];
    cell.textLabel.text = baseCategory.name;
    return cell;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TMSubcategoriesTableViewController *subcategoriesTableViewController = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    TMCategory *selectedCategory = self.baseCategories[path.row];
    subcategoriesTableViewController.parentCategory = selectedCategory;
}


#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    //self.listingVC = (TMListingTableViewController *) secondaryViewController;
    return self.shouldCollapseDetailViewController;
}

#pragma mark - SearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    TMListingTableViewController *listingTVC;
    UIViewController *vcToShow;
    if (self.splitViewController.viewControllers.count > 1) {
        UINavigationController *navController = [self.splitViewController.viewControllers lastObject];
        listingTVC = (TMListingTableViewController *)navController.topViewController;
        vcToShow = navController;
    } else {
        listingTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingTVC"];
        vcToShow = listingTVC;
    }
    [listingTVC searchFomKeywords:searchBar.text];
    [self.splitViewController showDetailViewController:vcToShow sender:nil];
}

@end
