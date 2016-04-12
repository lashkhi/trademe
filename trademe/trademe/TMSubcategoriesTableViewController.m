//
//  TMSubcategoriesTableViewController.m
//  trademe
//
//  Created by David Lashkhi on 10/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "TMSubcategoriesTableViewController.h"
#import "TMCategory.h"
#import "TMListingTableViewController.h"
#import "TMCategoriesMainTableViewController.h"


@interface TMSubcategoriesTableViewController ()

@property (nonatomic, strong) NSArray *categories;

@end

@implementation TMSubcategoriesTableViewController

static NSString * const reuseIdentifier = @"SubcategoriesTableViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.categories = self.parentCategory.subcategories;
}

- (void)createSubcategoriesTableViewControllerForCategory:(TMCategory *)category {
    TMSubcategoriesTableViewController *subcategoriesTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SubcategoriesTVC"];
    subcategoriesTVC.parentCategory = category;
    [self.navigationController pushViewController:subcategoriesTVC animated:YES];
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
    return self.categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TMCategory *category = self.categories[indexPath.row];
    cell.textLabel.text = category.name;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TMCategory *category = self.categories[indexPath.row];
    if (category.subcategories.count > 0) {
        [self createSubcategoriesTableViewControllerForCategory:category];
    } else {
        UIViewController *vcToShow;
        TMListingTableViewController *listingTVC;
        if (self.splitViewController.viewControllers.count > 1) {
            UINavigationController *navController = [self.splitViewController.viewControllers lastObject];
            listingTVC = (TMListingTableViewController *)navController.topViewController;
            vcToShow = navController;
        } else {
            listingTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingTVC"];
            vcToShow = listingTVC;
        }
        [listingTVC injectCategory:category];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.splitViewController showDetailViewController:vcToShow sender:nil];
    }
    
}




@end
