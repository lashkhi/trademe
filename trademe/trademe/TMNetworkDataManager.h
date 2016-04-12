//
//  TMNetworkDataManager.h
//  trademe
//
//  Created by David Lashkhi on 09/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TMNetworkDataManager : NSObject

typedef void (^ImageDidLoadBlock)(UIImage *image);


+ (instancetype)sharedInstance;

-(void)fetchImageFromUrl:(NSString*)urlString onDidLoad:(ImageDidLoadBlock)onImageDidLoad;

- (void)fetchCategoriesWithSuccess:(void (^)(NSArray * categories))success failure:(void (^)(NSError *error))failure;

- (void)fetchListingsForCategoryPath:(NSString *)path andCompletionBlock:(void (^)(NSArray * listings))success failure:(void (^)(NSError *error))failure;

@end
