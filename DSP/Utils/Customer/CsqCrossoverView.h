//
//  CsqCrossoverView.h
//  DSP
//
//  Created by hk on 2018/7/24.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <math.h>
#import "hornDataModel.h"
@interface CsqCrossoverView : UIView
@property(nonatomic,assign)CGFloat wigth;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,strong)hornDataModel *hornDataModel;
@end
