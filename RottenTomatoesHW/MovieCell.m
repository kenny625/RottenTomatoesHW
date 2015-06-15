//
//  MovieCell.m
//  RottenTomatoesHW
//
//  Created by Kenny Chu on 2015/6/15.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.posterView.image = nil;
}

@end
