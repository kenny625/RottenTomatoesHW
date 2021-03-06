//
//  MovieViewController.m
//  RottenTomatoesHW
//
//  Created by Kenny Chu on 2015/6/12.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import "ViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

CGRect originalHeightFrame;

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    originalHeightFrame = self.networkErrView.frame;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self refreshData];
}

- (void)refreshData {
    [self.networkErrView setHidden:YES];
    CGRect zeroHeightFrame = self.networkErrView.frame;
    zeroHeightFrame.size.height = 0;
    [self.networkErrView setFrame:zeroHeightFrame];
    self.movies = nil;
    [self.tableView reloadData];
    
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&page_limit=20";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = dict[@"movies"];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        
        if (connectionError != nil) {
            [UIView animateWithDuration:1 animations:^{
                [self.networkErrView setFrame:originalHeightFrame];
                [self.networkErrView setHidden:NO];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSString *posterURLString = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterURLString]];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *movie = self.movies[indexPath.row];
    ViewController *destinationVC = segue.destinationViewController;
    destinationVC.movie = movie;
    
}

@end
