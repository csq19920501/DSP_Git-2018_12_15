//
//  AdvancedTuning.h
//  DSP
//
//  Created by hk on 2018/7/4.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"

@interface AdvancedTuning : RootViewController
@property(nonatomic,copy)void(^changeSeleHorn)(NSArray *seleArray);
@property(nonatomic,copy)NSString *goToType;
@property(nonatomic,copy)NSString *moduleType;
@end
