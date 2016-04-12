//
//  TMSubcategoriesTableViewController.h
//  trademe
//
//  Created by David Lashkhi on 10/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMCategory;

@interface TMSubcategoriesTableViewController : UITableViewController

@property (nonatomic, strong) TMCategory *parentCategory;

@end
