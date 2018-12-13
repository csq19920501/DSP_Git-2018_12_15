//
//  ENEQ_VC.h
//  DSP
//
//  Created by hk on 2018/7/5.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"
#import "DeviceTool.h"
typedef NS_ENUM(NSInteger,HornINEQtype) {
    analog1 = 118,
    analog2 = 119,
    analog3 = 120,
    digital = 208,
    analog1_new = 300,
    analog2_new = 301,
    analog3_new = 302,
    digital_new = 303,
};

@interface ENEQ_VC : RootViewController
@property(nonatomic,copy)void   (^clickTypeBack)(HornINEQtype clickType);
@property(nonatomic,copy)void   (^clickTypeBackNew)(NSArray *clickArray);
@property(nonatomic,assign)INEQ_connectType analog1_2_connectType;
@property(nonatomic,assign)INEQ_connectType analog3_4_connectType;
@property(nonatomic,assign)INEQ_connectType analog5_6_connectType;
@property(nonatomic,assign)INEQ_connectType diglital_r_l_connectType;
@property(nonatomic,strong)NSArray *seleArray;
@end
