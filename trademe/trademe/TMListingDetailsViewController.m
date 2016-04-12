//
//  TMListingDetailsViewController.m
//  trademe
//
//  Created by David Lashkhi on 12/04/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

#import "TMListingDetailsViewController.h"
#import "TMListing.h"

@interface TMListingDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation TMListingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWithData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupWithData {
    self.nameLabel.text = self.listing.title;
    self.priceLabel.text = self.listing.priceDisplay;
    self.listingImageView.image = self.imageInject;
}

@end
