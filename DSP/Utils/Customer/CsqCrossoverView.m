//
//  CsqCrossoverView.m
//  DSP
//
//  Created by hk on 2018/7/24.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "CsqCrossoverView.h"
#import "Header.h"
#define zeroHeight self.height*1/6
@implementation CsqCrossoverView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.wigth = frame.size.width;
        self.height = frame.size.height;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    self.wigth = rect.size.width;
    self.height = rect.size.height;
    
    CGContextRef cgctx=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cgctx, 2.00f);
    CGContextSetStrokeColorWithColor(cgctx, [UIColor greenColor].CGColor);
    float y = 0.0;

    for(float x=0;x<rect.size.width;x++){
        
        y = [self changeViewWithX:x];
        CGContextAddLineToPoint(cgctx,x,y);
        CGContextStrokePath(cgctx);
        CGContextMoveToPoint(cgctx,x,y);
    }
    //必须等上面绘制完成后才能绘制下面 所以不能放在一个循环里面
    for(float x=0;x<rect.size.width;x++){
        y = [self changeViewWithX:x];
        //绘制直线区域
        [self drawLineX:x Y:y+1];
    }
}
//不需要创建路径
-(void)drawLineX:(CGFloat)x Y:(CGFloat)y{
    //1、创建路径
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    //2、设置起点
    [path1 moveToPoint:CGPointMake(x, y)];
    //设置终点
    [path1 addLineToPoint:CGPointMake(x, self.height)];
    
    [path1 setLineWidth:0.5];
    [path1 setLineJoinStyle:kCGLineJoinRound];
    [path1 setLineCapStyle:kCGLineCapRound];
    [[[UIColor greenColor]colorWithAlphaComponent:0.4] setStroke];
    //3、渲染上下文到View的layer
    [path1 stroke];
}
-(void)setHornDataModel:(hornDataModel *)hornDataModel{
    _hornDataModel = hornDataModel;
    [self setNeedsDisplay];
}

-(CGFloat)changeViewWithX:(CGFloat)x{
    CGFloat Y = 0.0;
    
    switch ((int)self.hornDataModel.CrossoverFilterType) {
        case AllPass:
        {
            
        }
            break;
        case HighPassFilter:
        {
            CGFloat hiBandx = self.hornDataModel.CrossoverHifreq;//后面要根据频率/和x通过算法计算
            CGFloat hiQ = (self.hornDataModel.CrossoverHiSlope + 1)/(10*(6*2 ));//后面要根据斜率通过算法计算
            if ( x >= hiBandx) {
                
            }else{
                Y =  hiQ * (x - hiBandx) * (x - hiBandx);
            }
        }
            break;
        case LowPassFIlter:
        {
            CGFloat loBandx = self.hornDataModel.CrossoverLoFreq;//后面要根据频率/和x通过算法计算
            CGFloat loQ =  (self.hornDataModel.CrossoverLoSlope + 1)/(10*(6*2 ));//后面要根据斜率通过算法计算
            if ( x <= loBandx) {
                
            }else{
                Y =  loQ * (x - loBandx) * (x - loBandx);
            }
        }
            break;
        case BandFilter:
        {
            CGFloat hiBandx = self.hornDataModel.CrossoverHifreq;//后面要根据频率/和x通过算法计算
            CGFloat hiQ = (self.hornDataModel.CrossoverHiSlope + 1)/(10*(6*2 ));//后面要根据斜率通过算法计算
            if ( x >= hiBandx) {
                
            }else{
                Y =  hiQ * (x - hiBandx) * (x - hiBandx);
            }
            CGFloat loBandx = self.hornDataModel.CrossoverLoFreq;//后面要根据频率/和x通过算法计算
            CGFloat loQ =  (self.hornDataModel.CrossoverLoSlope + 1)/(10*(6*2 ));//后面要根据斜率通过算法计算
            if ( x <= loBandx) {
                
            }else{
                Y =  loQ * (x - loBandx) * (x - loBandx) + Y;
            }
        }
            break;
        default:
            break;
    }
    return Y+ zeroHeight;
}
@end
