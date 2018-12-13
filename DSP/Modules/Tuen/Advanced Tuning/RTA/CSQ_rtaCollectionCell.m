//
//  CSQ_rtaCollectionCell.m
//  DSP
//
//  Created by hk on 2018/9/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "CSQ_rtaCollectionCell.h"

@implementation CSQ_rtaCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        
       
        
        self.label2 = [[UILabel alloc]init];
        self.label2.backgroundColor = [UIColor grayColor];
//        self.label2.alpha = 0.5;
        [self addSubview:self.label2];
        [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3);
            make.right.equalTo(self).offset(-3);
            make.bottom.equalTo(self);
            make.height.equalTo(@0);
        }];
        
        self.label3 = [[UILabel alloc]init];
        self.label3.backgroundColor = [UIColor whiteColor];
        self.label3.alpha = 0.5;
        [self addSubview:self.label3];
        [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3);
            make.right.equalTo(self).offset(-3);
            make.bottom.equalTo(self);
            make.height.equalTo(@0);
        }];
        
        self.label1 = [[UILabel alloc]init];
        self.label1.backgroundColor = [UIColor greenColor];
        self.label1.alpha = 0.5;
        [self addSubview:self.label1];
        [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3);
            make.right.equalTo(self).offset(-3);
            make.bottom.equalTo(self);
            make.height.equalTo(@0);
        }];
        
    }
    return self;
}
-(void)setRtaModel:(CSQ_rtaModel *)rtaModel{
    _rtaModel = rtaModel;
    [self.label1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(rtaModel.float1));
    }];
    [self.label2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(rtaModel.float2));
    }];
    [self.label3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(rtaModel.float3));
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}


@end

