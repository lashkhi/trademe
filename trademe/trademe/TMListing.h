//
//  TMListing.h
//  trademe
//
//  Created by David Lashkhi on 12/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMListing : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *listingId;
@property (nonatomic, strong) NSString *pictureHref;
@property (nonatomic, strong) NSString *priceDisplay;

@end
