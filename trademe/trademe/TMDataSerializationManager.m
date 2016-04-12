//
//  TMDataSerializationManager.m
//  trademe
//
//  Created by David Lashkhi on 09/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "TMDataSerializationManager.h"
#import "TMCategory.h"
#import "TMListing.h"

@interface TMDataSerializationManager ()

@property (nonatomic, strong) NSMutableArray *baseCategories;

@end

@implementation TMDataSerializationManager

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary {
    
    self = [super init];
    
    NSArray *categoriesArray = jsonDictionary[@"Subcategories"];
    [self createBaseCategoriesFromCategoriesArray:categoriesArray];
    return self;
}

- (void)createBaseCategoriesFromCategoriesArray:(NSArray *)categoriesArray {
    self.baseCategories = [NSMutableArray new];
    for (NSDictionary *baseCategory in categoriesArray) {
        TMCategory * category = [TMCategory new];
        category.name = baseCategory[@"Name"];
        category.path = baseCategory[@"Path"];
        category.number = baseCategory[@"Number"];
        [self.baseCategories addObject:category];
        [self createSubcategoriesForBaseCategory:category withSubcategories:baseCategory[@"Subcategories"]];
    }
}

- (void)createSubcategoriesForBaseCategory:(TMCategory *)category withSubcategories:(NSArray *)subcategories {
    NSMutableArray *tempSubcategoriesArray = [NSMutableArray new];
    for (NSDictionary *subcategoryDict in subcategories) {
        TMCategory * subcategory = [TMCategory new];
        subcategory.name = subcategoryDict[@"Name"];
        subcategory.path = subcategoryDict[@"Path"];
        subcategory.number = subcategoryDict[@"Number"];
        if (subcategoryDict[@"Subcategories"]) {
            [self createSubcategoriesForBaseCategory:subcategory withSubcategories:subcategoryDict[@"Subcategories"]];
        }
        [tempSubcategoriesArray addObject:subcategory];
    }
    category.subcategories = tempSubcategoriesArray;
    
}

- (NSArray *)fetchBaseCategories {
    return self.baseCategories;
}

- (NSArray *)createListingsFromListingsDictionary:(NSDictionary *)listingsDictionary {
    NSArray *listingsArray = listingsDictionary[@"List"];
    NSMutableArray *listingsMutableArray = [NSMutableArray new];
    for (NSDictionary *listingDictionary in listingsArray) {
        TMListing *listing = [TMListing new];
        listing.title = listingDictionary[@"Title"];
        listing.listingId = listingDictionary[@"ListingId"];
        listing.pictureHref = listingDictionary[@"PictureHref"];
        listing.priceDisplay = listingDictionary[@"PriceDisplay"];
        [listingsMutableArray addObject:listing];
    }
    return listingsMutableArray;
}

@end
