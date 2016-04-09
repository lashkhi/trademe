//
//  TMDataSerializationManager.h
//  trademe
//
//  Created by David Lashkhi on 09/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMDataSerializationManager : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

- (NSArray *)fetchBaseCategories;

@end
