//
//  TMListingDetailsViewController.h
//  trademe
//
//  Created by David Lashkhi on 12/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMListing;

@interface TMListingDetailsViewController : UIViewController
@property (nonatomic, strong) TMListing *listing;
@property (nonatomic, strong) UIImage *imageInject;
@end
