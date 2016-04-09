//
//  TMDataSerializationManager.m
//  trademe
//
//  Created by David Lashkhi on 09/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "TMDataSerializationManager.h"
#import "TMCategory.h"

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
        category.name = [baseCategory objectForKey:@"Name"];
        
        [self.baseCategories addObject:category];
    }
}

- (NSArray *)fetchBaseCategories {
    return self.baseCategories;
}

@end
