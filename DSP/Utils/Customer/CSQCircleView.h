//
//  CSQCircleView.h
//  DSP
//
//  Created by hk on 2018/6/19.
//  Copyright © 2018年 hk. All rights reserved.
//

/*
 在MLMCircleView基础上封装，添加两个imageView，旋转手势。另外要记住xib中调用封装控件的方法
 */



#import <UIKit/UIKit.h>
#import "MLMProgressHeader.h"
#import <Foundation/Foundation.h>

//上次发送时间戳 *1000
static NSTimeInterval _changeTimeInterval = 0;


@interface CSQCircleView : UIView

//@property(nonatomic,assign)NSTimeInterval changeTimeInterval;

@property(nonatomic,copy)void (^valueChange)(CGFloat level);
@property(nonatomic,copy)void (^valueChangeEnd)();
@property(nonatomic,copy)void (^sendData)();
@property(nonatomic,copy)void (^twoClickBlock)();
///背景图片
@property (nonatomic, strong) UIImageView *bgImage;
///旋转图片
@property (nonatomic, strong) UIImageView *rotateImage;
//最低刻度
@property (nonatomic,assign)CGFloat zeroLevel;
//当前刻度
@property (nonatomic,assign)CGFloat currentLevel;
//满额刻度
@property (nonatomic,assign)CGFloat MainLevel;
///弧度背景色
@property (nonatomic, strong) UIColor *bgColor;
///弧度填充色
@property (nonatomic, strong) UIColor *fillColor;

///弧度线宽
@property (nonatomic, assign) CGFloat bottomWidth;
@property (nonatomic, assign) CGFloat progressWidth;

///光标的背景图片
@property (nonatomic, strong) UIImage *dotImage;

///光标直径
@property (nonatomic, assign) CGFloat dotDiameter;

///边缘间隔
@property (nonatomic, assign) CGFloat edgespace;

///bottom和progress间隔,相对于bottom
@property (nonatomic, assign) CGFloat progressSpace;

///freeWidth
@property (nonatomic, assign, readonly) CGFloat freeWidth;

///是否圆角,默认YES
@property (nonatomic, assign) BOOL capRound;

+(NSTimeInterval)changeTimeInterval;
+(void)setChangeTimeInterval:(NSTimeInterval)newTimeInterval;

- (instancetype)initWithFrame:(CGRect)frame
                   startAngle:(CGFloat)start
                     endAngle:(CGFloat)end;
- (void)initData;
//设置全局level
-(void)setLevel:(CGFloat)level;
//设置关联的level
-(void)setConnectLevel:(CGFloat)level;
///设置进度
- (void)setProgress:(CGFloat)progress;

///图片隐藏
- (void)dotHidden:(BOOL)hidden;

///内外线紧邻(默认是覆盖),YES外接
- (void)bottomNearProgress:(BOOL)outOrIn;

///请务必使用绘制
- (void)drawProgress;
//加一步
- (void)addClick;
//减一步
- (void)deleClick;
@end
