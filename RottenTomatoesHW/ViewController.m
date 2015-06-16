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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

CGRect originalHeightFrameThis;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.networkErrView setHidden:YES];
    
    originalHeightFrameThis = self.networkErrView.frame;
    
    CGRect zeroHeightFrame = self.networkErrView.frame;
    zeroHeightFrame.size.height = 0;
    [self.networkErrView setFrame:zeroHeightFrame];
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    [self.synopsisLabel sizeToFit];
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [overlayView show:YES];
    [self.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self convertPosterUrlStringToHighRes:[self.movie valueForKeyPath:@"posters.detailed"]]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [overlayView dismiss:YES];
        self.posterView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [UIView animateWithDuration:1 animations:^{
            [self.networkErrView setFrame:originalHeightFrameThis];
            [self.networkErrView setHidden:NO];
        } completion:^(BOOL finished) {
            
        }];
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

- (void)viewDidAppear:(BOOL)animated
{
    CGSize contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.contentInset.top + self.synopsisLabel.bounds.size.height + self.titleLabel.bounds.size.height * 2);
    self.scrollView.contentSize = contentSize;
}

@end
