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
    self.resultObjectKeyPathsForViews = @[@"timestamp"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewsForCurrentResultObject{
    [super updateViewsForCurrentResultObject];
    self.textLabel.text = [[self.resultObject valueForKey:@"timestamp"] description];
}

@end
