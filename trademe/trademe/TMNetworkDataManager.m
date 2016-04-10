//
//  TMNetworkDataManager.m
//  trademe
//
//  Created by David Lashkhi on 09/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "TMNetworkDataManager.h"
#import "TMDataSerializationManager.h"

@interface TMNetworkDataManager ()

@property (nonatomic, strong) TMDataSerializationManager *serializationManger;

@end

@implementation TMNetworkDataManager


static NSString * const urlString = @"https://api.tmsandbox.co.nz/v1/Categories.json";

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static TMNetworkDataManager *manager;
    dispatch_once(&onceToken,
                  ^{
                      manager = [TMNetworkDataManager new];
                  });
    return manager;
    
}

- (void)fetchCategoriesWithSuccess:(void (^)(NSArray * categories))success failure:(void (^)(NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            self.serializationManger = [[TMDataSerializationManager alloc] initWithDictionary:jsonDictionary];
            NSArray *baseCategories = [self.serializationManger fetchBaseCategories];
            success (baseCategories);
        } else if (error) {
            //handle error
        } else {
            //handle unknown error
        }
        
    }];
    [dataTask resume];
    
}


@end
