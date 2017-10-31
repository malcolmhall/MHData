//
//  EventTableViewCell.m
//  MCDDemo
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.objectKeyPathsForViews = @[@"timestamp"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewsForCurrentObject{
    [super updateViewsForCurrentObject];
    self.textLabel.text = [self.fetchedObject.timestamp description];
}

@end
