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
static NSString * const listingString = @"https://api.tmsandbox.co.nz/v1/Search/General.json?category=";
static NSString * const listingDetails = @"https://api.tmsandbox.co.nz/v1/Listings/";

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static TMNetworkDataManager *manager;
    dispatch_once(&onceToken,
                  ^{
                      manager = [TMNetworkDataManager new];
                  });
    return manager;
    
}

- (NSURLSessionConfiguration *)sessionConfigurationForAuthRequests {
    NSString *username = @"A1AC63F0332A131A78FAC304D007E7D1";
    NSString *secret = @"EC7F18B17A062962C6930A8AE88B16C7";
    NSString *authString = [NSString stringWithFormat:@"oauth_consumer_key=%@, oauth_signature_method=PLAINTEXT, oauth_signature=%@&", username, secret];
    
    
    NSString *authHeader = [NSString stringWithFormat: @"OAuth %@", authString];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:@{
                                              @"Accept": @"application/json",
                                              @"Authorization": authHeader
                                              }];
    return sessionConfig;

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
        }
    }];
    [dataTask resume];
    
}

- (void)fetchListingsForCategoryPath:(NSString *)path andCompletionBlock:(void (^)(NSArray * listings))success failure:(void (^)(NSError *error))failure {
    NSString *newPath = [path substringToIndex:[path length]-1];
    NSMutableString *tempPath = [listingString mutableCopy];
    [tempPath appendString:newPath];
    NSURL *url = [NSURL URLWithString:tempPath];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfigurationForAuthRequests]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSArray *listingsArray = [self.serializationManger createListingsFromListingsDictionary:jsonDictionary];
            success (listingsArray);
        } else if (error) {
            //handle error
        }
    }];
    [dataTask resume];

}

- (void)fetchListingsWith:(NSDictionary *)listing andCompletionBlock:(void (^)(NSDictionary * listings))success failure:(void (^)(NSError *error))failure {
    
    NSDictionary *list = [listing[@"List"] firstObject];
    NSString *listingID = list[@"ListingId"];
    NSMutableString *tempPath = [listingDetails mutableCopy];
    [tempPath appendString:[NSString stringWithFormat:@"%@.json", listingID]];
    
    NSURL *url = [NSURL URLWithString:tempPath];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfigurationForAuthRequests]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            //self.serializationManger = [[TMDataSerializationManager alloc] initWithDictionary:jsonDictionary];
            success (jsonDictionary);
        } else if (error) {
            //handle error
        } else {
            //handle unknown error
        }
        
    }];
    [dataTask resume];

}

#pragma mark Image downloader

-(void)fetchImageFromUrl:(NSString*)urlString onDidLoad:(ImageDidLoadBlock)onImageDidLoad {
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *imageData = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:imageData];
        onImageDidLoad(image);
    }];
    [task resume];
}


@end
