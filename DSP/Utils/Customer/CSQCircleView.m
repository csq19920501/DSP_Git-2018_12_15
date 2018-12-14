//
//  CSQCircleView.m
//  DSP
//
//  Created by hk on 2018/6/19.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "CSQCircleView.h"
#import "KTOneFingerRotationGestureRecognizer.h"
#define radiansToDegrees(x) (x * 180 / M_PI)
#define CSQ_DISPATCH_AFTER(afterTime,agterQueueBlock) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), agterQueueBlock);
#define MPWeakSelf(type)  __weak typeof(type) weak##type = type;
@interface CSQCircleView ()<UIGestureRecognizerDelegate>
{
    //progress计量单位
    CGFloat circleRadius;//bottom半径
    CGFloat progressRadius;//进度半径
    
    CGFloat _progress;//进度
    
    ///起点
    CGFloat _startAngle;
    ///终点
    CGFloat _endAngle;
    
    CGFloat lastProgress;
    
    //旋转计量单位
    CGFloat MainStartAngle;
    CGFloat MainStopAngle;
    CGFloat MainCurrentAngle;
    
    BOOL isNotFirst;
}
@property(nonatomic,assign)long long changLongTimes;
@property (nonatomic, strong) UIImageView *dotImageView;//光标
@property (nonatomic, strong) CAShapeLayer *bottomLayer;//弧度背景
@property (nonatomic, strong) CAShapeLayer *progressLayer;//进度

@end
@implementation CSQCircleView

+(NSTimeInterval)changeTimeInterval{
    return _changeTimeInterval;
}

+(void)setChangeTimeInterval:(NSTimeInterval)newTimeInterval{
    _changeTimeInterval = newTimeInterval;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame startAngle:150 endAngle:390];
}


- (instancetype)initWithFrame:(CGRect)frame
                   startAngle:(CGFloat)start
                     endAngle:(CGFloat)end {
    if (self = [super initWithFrame:frame]) {
        
        _startAngle = start;
        _endAngle = end;
        //默认数据
        self.changLongTimes = 0;
        [self initData];
        
    }
    return self;
}

-(void)layoutSubviews{
    //调用drawProgress 就会走layoutSubviews
     [self initData];
}

#pragma mark - 默认数据
- (void)initData {
    _zeroLevel = 0.0;
 
    _MainLevel = (_MainLevel == 0.0 || _MainLevel == 30.0)?30.0:_MainLevel;
    _startAngle = 120;
    _endAngle = 420;
    _progressWidth = 2.f;
    _bottomWidth = 2.f;
    _bgColor = [UIColor colorWithWhite:1 alpha:.3];//[UIColor clearColor];
    _fillColor = [UIColor whiteColor];
    _capRound = YES;
    //屏蔽 圆点
//    _dotImage = [UIImage imageNamed:@"brightDot"];
    _dotDiameter = 3.f;
    _edgespace = -1;
    _progressSpace = 0;
    
//    if (self.valueChange) {
//        self.valueChange(_currentLevel);
//    }
}

#pragma mark - 计算光标的起始center
- (void)dotCenter {
    if (_dotImageView) {
        [_dotImageView removeFromSuperview];
    } else {
        _dotImageView = [[UIImageView alloc] init];
    }
    _dotImageView.frame = CGRectMake(0, 0, self.dotDiameter, self.dotDiameter);
    CGFloat centerX = self.width/2 + progressRadius*cosf(DEGREES_TO_RADIANS(_startAngle));
    CGFloat centerY = self.width/2 + progressRadius*sinf(DEGREES_TO_RADIANS(_startAngle));
    _dotImageView.center = CGPointMake(centerX, centerY);
    _dotImageView.layer.cornerRadius = self.dotDiameter/2;
    [_dotImageView setImage:self.dotImage];
    [self addSubview:_dotImageView];
}


#pragma mark - draw
- (void)drawProgress {
    MainCurrentAngle = 0.0;
    lastProgress = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    _bgImage = [[UIImageView alloc]initWithFrame:self.bounds];
    _bgImage.image = [UIImage imageNamed:@"volume_show_1.png"];
//    _bgImage.center
    [self addSubview:_bgImage];
    
    //
    CGFloat baseRadius = self.width/2 - _edgespace;
    
    //确保边缘距离设置正确
    if (_progressSpace == 0) {
        circleRadius = progressRadius = baseRadius - MAX(_progressWidth, _bottomWidth)/2;
    } else if (_progressSpace < 0) {
        circleRadius = baseRadius + _progressSpace - _progressWidth/2;
        progressRadius = baseRadius - _progressWidth/2;
    } else {
        circleRadius = baseRadius - _bottomWidth/2;
        progressRadius = baseRadius - _bottomWidth/2 - _progressSpace;
    }
    
    //光标位置
    [self drowLayer];
    [self dotCenter];
    
    _rotateImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width/1.15, self.height/1.15)];
    _rotateImage.image = [UIImage imageNamed:@"volume_normat.png"];
    _rotateImage.center = CGPointMake(self.width/2, self.height/2);
    [self addSubview:_rotateImage];
    _rotateImage.userInteractionEnabled = YES;
    _rotateImage.transform = CGAffineTransformMakeRotation(M_PI/2 *6.85/3);
    /* 旋转手势 */
    KTOneFingerRotationGestureRecognizer *rotateTap = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
    [_rotateImage addGestureRecognizer:rotateTap];
    self->MainStartAngle = 0.0;
    self->MainStopAngle = 300.0;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoClick)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_rotateImage addGestureRecognizer:tap];
}
-(void)twoClick{
//    NSLog(@"双击");
    if (self.twoClickBlock) {
        self.twoClickBlock();
    }
}
/*
 旋转手势
 */
- (void)rotated:(KTOneFingerRotationGestureRecognizer *)recognizer
{
    if ([[recognizer view] isEqual:_rotateImage]) {
        CGFloat degrees = radiansToDegrees([recognizer rotation]);
        CGFloat currentAngle = MainCurrentAngle + degrees;
        //        CGFloat relativeAngle = fmodf(currentAngle, 360.0);
        BOOL shouldRotate = NO;
        if (MainStartAngle <= MainStopAngle) {
            shouldRotate = (currentAngle >= MainStartAngle && currentAngle <= MainStopAngle);
        } else if (MainStartAngle > MainStopAngle) {
            //            shouldRotate = (relativeAngle >= MainStartAngle || relativeAngle <= MainStopAngle);
            shouldRotate = NO;
        }
        if (shouldRotate) {
            /*
             //不能主动修改MainCurrentAngle
             MainCurrentAngle = MainStopAngle; 不能主动修改MainCurrentAngle
             */
            
            MainCurrentAngle = currentAngle;
            [_rotateImage setTransform:CGAffineTransformRotate([_rotateImage transform], [recognizer rotation])];
            
            CGFloat level = MainCurrentAngle/MainStopAngle * _MainLevel;
            if (level < 1) {
                level = 0.0;
                _bgImage.image =  [UIImage imageNamed:@"volume_show_1.png"];
                _rotateImage.image = [UIImage imageNamed:@"volume_normat.png"];
                _currentLevel = level;
            }
            else if (level > (_MainLevel - 1 + 0.5)) {
                level = _MainLevel;
                _bgImage.image =  [UIImage imageNamed:@"volume_show_3.png"];
//                _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
                _currentLevel = level;
            }else{
                _bgImage.image =  [UIImage imageNamed:@"volume_show_2.png"];
//                _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
                _currentLevel = level;
            }
//            self.MainLevelLabel.text = [NSString stringWithFormat:@"%d",(int)level];
            
            CGFloat progressValue = MainCurrentAngle/MainStopAngle;
            
            if (progressValue < 0.02) {
                progressValue = 0.0;
            }
            if (progressValue > 0.99) {
                progressValue = 1.0;
            }

            
            
            [self setProgress:progressValue];
            
            if (self.valueChange) {
                self.valueChange(level);
            }
        }
    }
}

-(void)setLevel:(CGFloat)level {
        if (level < 1) {
            level = 0.0;
            _bgImage.image =  [UIImage imageNamed:@"volume_show_1.png"];
            _rotateImage.image = [UIImage imageNamed:@"volume_normat.png"];
            _currentLevel = level;
        }else if (level > (_MainLevel - 1 + 0.5)) {
            level = _MainLevel;
            _currentLevel = level;
            
            _bgImage.image =  [UIImage imageNamed:@"volume_show_3.png"];
//            _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
        }else{
            _currentLevel = level;
            
            _bgImage.image =  [UIImage imageNamed:@"volume_show_2.png"];
//            _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
        }
//        self.MainLevelLabel.text = [NSString stringWithFormat:@"%d",(int)level];
        
        CGFloat progressValue = level/_MainLevel;

        if (progressValue < 0.02) {
            progressValue = 0.0;
        }
        if (progressValue > 0.99) {
            progressValue = 1.0;
        }
        [self setProgress:progressValue];
        
        [_rotateImage setTransform:CGAffineTransformRotate([_rotateImage transform],(MainStopAngle * level/_MainLevel - MainCurrentAngle) * (M_PI/180.0))];
        MainCurrentAngle = MainStopAngle * level/_MainLevel;
    if (self.valueChange) {
        self.valueChange(level);
    }

}
//因为设置频率时，最大值时不能调整频率所以特意增加一个方法
-(void)setCrossLevel:(CGFloat)level {
    if (level < 1) {
        level = 0.0;
        _bgImage.image =  [UIImage imageNamed:@"volume_show_1.png"];
        _rotateImage.image = [UIImage imageNamed:@"volume_normat.png"];
        _currentLevel = level;
    }else if (level > (_MainLevel - 1 + 0.5)) {
//        level = _MainLevel;
        _currentLevel = level;
        
        _bgImage.image =  [UIImage imageNamed:@"volume_show_3.png"];
        //            _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
    }else{
        _currentLevel = level;
        
        _bgImage.image =  [UIImage imageNamed:@"volume_show_2.png"];
        //            _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
    }
    //        self.MainLevelLabel.text = [NSString stringWithFormat:@"%d",(int)level];
    
    CGFloat progressValue = level/_MainLevel;
    
    if (progressValue < 0.02) {
        progressValue = 0.0;
    }
    if (progressValue > 0.99) {
    
        progressValue = 1.0;
    }
    [self setProgress:progressValue];
    
    [_rotateImage setTransform:CGAffineTransformRotate([_rotateImage transform],(MainStopAngle * level/_MainLevel - MainCurrentAngle) * (M_PI/180.0))];
    MainCurrentAngle = MainStopAngle * level/_MainLevel;
    if (self.valueChange) {
        self.valueChange(level);
    }
    
}

-(void)setConnectLevel:(CGFloat)level {
    
    if (level < 1) {
        level = 0.0;
        _bgImage.image =  [UIImage imageNamed:@"volume_show_1.png"];
        _rotateImage.image = [UIImage imageNamed:@"volume_normat.png"];
        _currentLevel = level;
    }else if (level > (_MainLevel - 1 + 0.5)) {
        level = _MainLevel;
        _currentLevel = level;
        
        _bgImage.image =  [UIImage imageNamed:@"volume_show_3.png"];
//        _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
    }else{
        _currentLevel = level;
        
        _bgImage.image =  [UIImage imageNamed:@"volume_show_2.png"];
//        _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
    }
    //        self.MainLevelLabel.text = [NSString stringWithFormat:@"%d",(int)level];
    
    CGFloat progressValue = level/_MainLevel;
    
    if (progressValue < 0.02) {
        progressValue = 0.0;
    }
    if (progressValue > 0.99) {
        progressValue = 1.0;
    }
    [self setProgress:progressValue];
    
    [_rotateImage setTransform:CGAffineTransformRotate([_rotateImage transform],(MainStopAngle * level/_MainLevel - MainCurrentAngle) * (M_PI/180.0))];
    MainCurrentAngle = MainStopAngle * level/_MainLevel;
//    if (self.valueChange) {
//        self.valueChange(level);
//    }
    
}
#pragma mark - layer
- (void)drowLayer {
    [self drowBottom];
    [self drowProgress];
}


//背景
- (void)drowBottom {
    //刷新时删除原有的
    if (self.bottomLayer) {
        [self.bottomLayer removeFromSuperlayer];
    }
    
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2)
                                                              radius:circleRadius
                                                          startAngle:DEGREES_TO_RADIANS(_startAngle)
                                                            endAngle:DEGREES_TO_RADIANS(_endAngle)
                                                           clockwise:YES];
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = CGRectMake(0, 0, self.width, self.height);
    self.bottomLayer.fillColor = [UIColor clearColor].CGColor;
    self.bottomLayer.strokeColor = self.bgColor.CGColor;
    if (_capRound) {
        self.bottomLayer.lineCap = kCALineCapRound;
    }
    self.bottomLayer.lineWidth = self.bottomWidth;
    self.bottomLayer.path = [bottomPath CGPath];
    [self.layer addSublayer:self.bottomLayer];
}

- (void)drowProgress {
    if (self.progressLayer) {
        [self.progressLayer removeFromSuperlayer];
    }
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2)
                                                                radius:progressRadius
                                                            startAngle:DEGREES_TO_RADIANS(_startAngle)
                                                              endAngle:DEGREES_TO_RADIANS(_endAngle)
                                                             clockwise:YES];
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = CGRectMake(0, 0, self.width, self.height);
    self.progressLayer.fillColor =  [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor  = self.fillColor.CGColor;
    if (_capRound) {
        self.progressLayer.lineCap = kCALineCapRound;
    }
    self.progressLayer.lineWidth = self.progressWidth;
    self.progressLayer.path = [progressPath CGPath];
    self.progressLayer.strokeEnd = 0;
    [self.layer addSublayer:self.progressLayer];
    //add image.layer to progressLayer
}



#pragma mark - 动画
- (void)createAnimation {
    CGFloat centerX = self.width/2 + progressRadius*cosf(DEGREES_TO_RADIANS(_endAngle - _startAngle)*lastProgress);
    CGFloat centerY = self.width/2 + progressRadius*sinf(DEGREES_TO_RADIANS(_endAngle - _startAngle)*lastProgress);
    _dotImageView.center = CGPointMake(centerX, centerY);
    
    //设置动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;//使得动画均匀进行
    //动画结束不被移除
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.rotationMode = kCAAnimationRotateAuto;
    pathAnimation.duration = kAnimationTime;
    pathAnimation.repeatCount = 1;
    
    //设置动画路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path,
                 NULL,
                 self.width/2,
                 self.height/2,
                 progressRadius,
                 DEGREES_TO_RADIANS(_endAngle - _startAngle)*lastProgress + DEGREES_TO_RADIANS(_startAngle),
                 DEGREES_TO_RADIANS(_endAngle - _startAngle)*_progress + DEGREES_TO_RADIANS(_startAngle), lastProgress > _progress);
    pathAnimation.path = path;
    CGPathRelease(path);
    [self.dotImageView.layer addAnimation:pathAnimation forKey:@"moveMarker"];
}

#pragma mark - 弧度
- (void)setProgress:(CGFloat)progress {
    if (isNotFirst) {
        if (_progress != 0) {
            _rotateImage.image = [UIImage imageNamed:@"volume_selected.png"];
        }
        _fillColor = [UIColor greenColor];
        [self drowProgress];
    }
    BOOL isNotFirstCopy = isNotFirst;
//    NSLog(@"isNotFirstCopy = %d",isNotFirstCopy);
    
    isNotFirst = YES;

    _progress = progress;
    [self setProgressAnimation:YES];
    
    
    
    self.changLongTimes++;
    long long a = self.changLongTimes;
    MPWeakSelf(self)
    CSQ_DISPATCH_AFTER(2.0,^{
//        NSLog(@"++++++++++a = %lld weakself == %lld",a,weakself.changLongTimes);
        if (a == self.changLongTimes) {
            weakself.fillColor = [UIColor whiteColor];
            [weakself drowProgress];
            [weakself createAnimation];
            [weakself circleAnimation];
//            NSLog(@"++++++++++CSQ_DISPATCH_AFTER ");
            weakself.rotateImage.image = [UIImage imageNamed:@"volume_normat.png"];
            if (self.valueChangeEnd) {
                self.valueChangeEnd();
            }
        }
    })
    
    CSQ_DISPATCH_AFTER(0.2,^{
        if (a == self.changLongTimes) {
            if (isNotFirstCopy) {
//                NSLog(@"isNotFirstCopy CSQ_DISPATCH_AFTER= %d",isNotFirstCopy);
                if (self.sendData) {
                    self.sendData();
                }
            }
        }
    })
}

- (void)setProgressAnimation:(BOOL)animation {
//    if (_progress == lastProgress) {
//        return;
//    }
    [self createAnimation];
    [self circleAnimation];
    //降低了动画持续时间
}


- (void)circleAnimation {
    //开启事务
    [CATransaction begin];
    //关闭动画
    [CATransaction setDisableActions:YES];
    self.progressLayer.strokeEnd = lastProgress;
    [CATransaction commit];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = kAnimationTime;
    animation.repeatCount = 1;
    animation.fromValue = @(lastProgress);
    animation.toValue = @(_progress);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
//    self.progressLayer.strokeColor  = self.fillColor.CGColor;
    [self.progressLayer addAnimation:animation forKey:@"strokeEndAni"];
    lastProgress = _progress;
}

- (void)dotHidden:(BOOL)hidden {
    _dotImageView.hidden = hidden;
}

- (CGFloat)freeWidth {
    //最小半径
    CGFloat cirle = circleRadius - _bottomWidth/2;
    CGFloat progress = progressRadius - _progressWidth/2;
    
    return MIN(cirle, progress)*2;
    
}

- (void)bottomNearProgress:(BOOL)outOrIn {
    CGFloat nearSpace = (self.bottomWidth+self.progressWidth)/2;
    if (outOrIn) {
        self.progressSpace = -nearSpace;
    } else {
        self.progressSpace = nearSpace;
    }
}
- (void)addClick {
    CGFloat nowLevel = self.currentLevel + 1;
    if (nowLevel <=  self.MainLevel) {
        [self setLevel:nowLevel];
    }
}
- (void)deleClick {
    CGFloat nowLevel = self.currentLevel - 1;
    if (nowLevel >=  self.zeroLevel) {
        [self setLevel:nowLevel];
    }
}
@end
