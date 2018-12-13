//
//  SinView.h
//  TestSinCurve
//
//  Created by Gary on 10/12/09.
//  Copyright 2009 Sensky Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eqBandModel.h"
#include <math.h>


typedef NS_ENUM(NSInteger, CSQ_sinViewType) {
    CheqViewType = 0,//当前显示cheq波形图
    IneqViewType,//当前显示ineq波形图
};

@interface SinView : UIView {

}
@property(nonatomic,assign)CGFloat wigth;
@property(nonatomic,assign)CGFloat height;

@property(nonatomic,assign)NSInteger CheqshelfCount;
@property(nonatomic,assign)NSInteger IneqshelfCount;
@property(nonatomic,assign)CSQ_sinViewType sinViewType;

@property(nonatomic,strong)NSMutableArray *bandArray;
@property(nonatomic,strong)NSMutableArray *rectArray;
@property(nonatomic,assign)CGFloat selectBandX;
@property(nonatomic,assign)NSInteger changCount;
@end
