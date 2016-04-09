//
//  TMNetworkDataManager.h
//  trademe
//
//  Created by David Lashkhi on 09/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMNetworkDataManager : NSObject

+ (instancetype)sharedInstance;

- (void)fetchCategoriesWithSuccess:(void (^)(NSArray * categories))success failure:(void (^)(NSError *error))failure;

@end
