//
//  eqBandModel.h
//  DSP
//
//  Created by hk on 2018/7/19.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSQBandType) {
    bandType_PEQ= 1,
    bandType_HSLF,
    bandType_LSHF,
};
@interface eqBandModel : NSObject
@property(nonatomic,assign)NSInteger bandNumber;
@property(nonatomic,assign)CSQBandType bandType;

@property(nonatomic,assign)CGFloat freq;
@property(nonatomic,assign)CGFloat freqBase;//freqBase是基于bandNumber得出来的 固定
@property(nonatomic,assign)CGFloat freqLevel;//freqLevel需主动用 freqbase和freq算出来对应的band 然后这两个band百分比算出freqlevel
@property(nonatomic,assign)CGFloat bandX;//x轴坐标  须与freq同步
@property(nonatomic,assign)CGFloat bandXBase;//基于bandNumber得出来的 固定



@property(nonatomic,assign)CGFloat gain;//增益
@property(nonatomic,assign)CGFloat Q; //Q值
@property(nonatomic,assign)CGFloat Slf_Q; //hslf lslf的Q值

@property(nonatomic,strong)NSArray *shelfArray;
@property(nonatomic,strong)NSDictionary *shelfDictionary;
-(eqBandModel*)modelDeepCopy;
@end
