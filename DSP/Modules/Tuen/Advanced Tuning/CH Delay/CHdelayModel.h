//
//  CHdelayModel.h
//  DSP
//
//  Created by hk on 2018/7/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHdelayModel : NSObject
@property(nonatomic,assign)CGFloat distance;//单位厘米
@property(nonatomic,assign)CGFloat delay;   // 单位毫秒/100
@property(nonatomic,assign)CGFloat phase;//无用
@property(nonatomic,assign)BOOL isMune;
@property(nonatomic,assign)BOOL isPhase180;
@property(nonatomic,assign)NSInteger arrayType;
@property(nonatomic,assign)NSInteger outCH;
@end
