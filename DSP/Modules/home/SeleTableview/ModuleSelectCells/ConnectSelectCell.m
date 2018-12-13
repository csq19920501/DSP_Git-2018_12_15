//
//  ConnectSelectCell.m
//  DSP
//
//  Created by hk on 2018/6/13.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "ConnectSelectCell.h"

@implementation ConnectSelectCell

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
    if (selected) {
        _titleLabel.textColor = [UIColor greenColor];
    }else{
        _titleLabel.textColor = [UIColor whiteColor];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _titleLabel.textColor = [UIColor greenColor];
    }else{
        _titleLabel.textColor = [UIColor whiteColor];
    }
}
@end
