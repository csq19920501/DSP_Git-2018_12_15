//
//  inputLevelVC.h
//  DSP
//
//  Created by hk on 2018/6/19.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"
#import "CSQCircleView.h"
typedef NS_ENUM(NSInteger, InputType) {
    Ana = 1,
    Dig = 2,
};
@interface inputLevelVC : RootViewController
@property(nonatomic,assign)InputType inputType;
@end
