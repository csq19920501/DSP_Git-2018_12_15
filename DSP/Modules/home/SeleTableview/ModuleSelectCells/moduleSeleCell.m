//
//  moduleSeleCell.m
//  DSP
//
//  Created by hk on 2018/6/12.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "moduleSeleCell.h"

@implementation moduleSeleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backColorView.layer.cornerRadius = 10;
    _backColorView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        
        NSLog(@" setSelected 1 ");
        
        _titleText.textColor = [UIColor greenColor];
        _leftImage.highlighted  = YES;
    }else{
        _titleText.textColor = [UIColor whiteColor];
        _leftImage.highlighted  = NO;
        NSLog(@" setSelected 2 ");
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
     [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _titleText.textColor = [UIColor greenColor];
        _leftImage.highlighted  = YES;
        NSLog(@" setSelected 3 ");
    }else{
        _titleText.textColor = [UIColor whiteColor];
        _leftImage.highlighted  = NO;
        NSLog(@" setSelected 4 ");
    }
}
@end
