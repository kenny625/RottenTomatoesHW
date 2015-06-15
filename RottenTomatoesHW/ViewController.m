//
//  ViewController.m
//  RottenTomatoesHW
//
//  Created by Kenny Chu on 2015/6/12.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+AFNetworking.h>
#import <MRProgress/MRProgressOverlayView+AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [overlayView show:YES];
    [self.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self convertPosterUrlStringToHighRes:[self.movie valueForKeyPath:@"posters.detailed"]]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [overlayView dismiss:YES];
        self.posterView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Error Fetching the Image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];
        [overlayView dismiss:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)convertPosterUrlStringToHighRes:(NSString *)urlString {
    NSRange range = [urlString rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *returnValue = urlString;
    if (range.length > 0) {
        returnValue = [urlString stringByReplacingCharactersInRange:range withString:@"https://content6.flixster.com/"];
    }
    return returnValue;
}

@end
