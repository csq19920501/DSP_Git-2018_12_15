//
//  SinView.m
//  TestSinCurve
//
//  Created by Gary on 10/12/09.
//  Copyright 2009 Sensky Co., Ltd. All rights reserved.
//

#import "SinView.h"
#import "Header.h"
#define zeroHeight self.height*1/2
#define csqPi 3.14159
#define qPoint 1.0

#define csqChangeBand 6 //修正图形边界不规整问题
@implementation SinView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        _bandArray = [NSMutableArray array];
        _rectArray = [NSMutableArray array];
        self.wigth = frame.size.width;
        self.height = frame.size.height;
        self.CheqshelfCount = 0;
        self.IneqshelfCount = 0;
        self.changCount = 0;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _bandArray = [NSMutableArray array];
        _rectArray = [NSMutableArray array];
        self.CheqshelfCount = 0;
        self.IneqshelfCount = 0;
        self.changCount = 0;
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.wigth = self.size.width;
    self.height = self.size.height;
}
-(void)setBandArray:(NSMutableArray *)bandArray{
    _bandArray = bandArray;
    self.changCount ++ ;
    NSInteger count = self.changCount;
    //默认 时长
    CGFloat timeLong = 0.02;
    int shelfInt = 0;
    for (eqBandModel *model in self.bandArray) {
        if (model.bandType != bandType_PEQ) {
            shelfInt++;
        }
    }
    //shelf数少于2等待时间减少
    if (shelfInt <= 2) {
        timeLong = 0.01;
    }
    for (eqBandModel *model in self.bandArray) {
        if (model.bandX == self.selectBandX && model.bandType == bandType_PEQ) {
            //当前modelType不是shelf减少等待时间
            timeLong = 0;
        }else{
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeLong * NSEC_PER_SEC)), dispatch_get_main_queue(), (^{
        //通过block里面处理全局变量和局部变量的方式不一样来决定是否return   不是最终执行的取消计算
        if (count != self.changCount) {
            return ;
        }
        
        int shelfInt = 0;
        for (eqBandModel *model in self.bandArray) {
            if (model.bandType != bandType_PEQ) {
                shelfInt++;
            }
        }
        if (self.sinViewType == CheqViewType) {
            if (shelfInt != self.CheqshelfCount) {
                if (self.CheqshelfCount == 0) {
                    SDLog(@"beisaier _ 111");
                    for (eqBandModel *model in self.bandArray) {
                        if (model.bandType != bandType_PEQ ) {
                            [self beisaier:model];
                        }else{
                             model.shelfDictionary = nil;
                        }
                    }
                }else{
                    SDLog(@"beisaier _ 222");
                    for (eqBandModel *model in self.bandArray) {
                        if (model.bandX == self.selectBandX && model.bandType != bandType_PEQ) {
                            SDLog(@"beisaier _ 444");
                            [self beisaier:model];
                        }else{
                            if (model.bandType == bandType_PEQ) {
                                model.shelfDictionary = nil;
                            }
                        }
                    }
                }
                self.CheqshelfCount = shelfInt;
            }else{
                SDLog(@"beisaier _ 333");
                for (eqBandModel *model in self.bandArray) {
                    if (model.bandX == self.selectBandX && model.bandType != bandType_PEQ) {
                        SDLog(@"beisaier _ bandNumber = %f",self.selectBandX);
                        [self beisaier:model];
                    }else{
                        if (model.bandType == bandType_PEQ) {
                            model.shelfDictionary = nil;
                        }
                    }
                }
            }
        }else if (self.sinViewType == IneqViewType){
            if (shelfInt != self.IneqshelfCount) {
                if (self.IneqshelfCount == 0) {
                    for (eqBandModel *model in self.bandArray) {
                        if (model.bandType != bandType_PEQ) {
                            [self beisaier:model];
                        }else{
                            model.shelfDictionary = nil;
                        }
                    }
                }else{
                    for (eqBandModel *model in self.bandArray) {
                        if (model.bandX == self.selectBandX && model.bandType != bandType_PEQ) {
                            [self beisaier:model];
                        }else{
                            if (model.bandType == bandType_PEQ) {
                                model.shelfDictionary = nil;
                            }
                        }
                    }
                }
                self.IneqshelfCount = shelfInt;
            }else{
                for (eqBandModel *model in self.bandArray) {
                    if (model.bandX == self.selectBandX && model.bandType != bandType_PEQ) {
                        [self beisaier:model];
                    }else{
                        if (model.bandType == bandType_PEQ) {
                            model.shelfDictionary = nil;
                        }
                    }
                }
            }
        }
        //先计算再回到主线程渲染
        [self.rectArray removeAllObjects];
        float y = 0.0;
        for(int x=0;x<self.size.width;x++){
            y = [self changeViewWithX:x];
            NSString *xStr = [NSString stringWithFormat:@"%d",x];
            NSString *yStr = [NSString stringWithFormat:@"%f",y];
            [self.rectArray addObject:@{xStr:yStr}];
        }
        DISPATCH_ON_MAIN_THREAD(^{
            [self setNeedsDisplay];
        })
    }));
}

-(void)beisaier:(eqBandModel*)model{
    SDLog(@"beisaier");
//    return;
    NSMutableArray *myPointArray = [[NSMutableArray alloc] init];
    
    CGPoint pointL3;
    CGPoint pointL2;
    CGPoint pointL1;
    CGPoint pointR1;
    CGPoint pointR2;
    CGPoint pointR3;
    CGPoint pointL4;
    CGPoint pointR4;
    
            CGFloat q = model.Slf_Q * Q_changeV;
            CGFloat gain = self.height/24*model.gain;
            CGFloat gainA = sqrt(gain * gain);
            gainA = gainA/2.0;
            CGFloat bandX = model.bandX;
    
        if (q <= qPoint) {
            q = 0.6 + q/2.0;
            pointL3 = CGPointMake(bandX - 50/(q*q), 0);
            pointL2 = CGPointMake((pointL3.x + bandX)/2.0, gainA*1/3);
            pointR3 = CGPointMake(bandX + 50/(q*q), gainA * 2);
            pointR2 = CGPointMake((pointR3.x + bandX)/2.0, gainA*2/3 + gainA);
            
            if (gain < 0) {
                pointL3 = CGPointMake(pointL3.x, -pointL3.y);
                pointL2 = CGPointMake(pointL2.x, -pointL2.y);
                pointR3 = CGPointMake(pointR3.x, -pointR3.y);
                pointR2 = CGPointMake(pointR2.x, -pointR2.y);
            }
            
            if (model.bandType == bandType_LSHF) {
                CGPoint pointCopy1, pointCopy2;
                pointCopy1 = pointL3;
                pointCopy2 = pointL2;
                
                pointL3.y = pointR3.y;
                pointL2.y = pointR2.y;
                
                pointR3.y = pointCopy1.y;
                pointR2.y = pointCopy2.y;
            }
            
            [myPointArray addObject:NSStringFromCGPoint(pointL3)];
            [myPointArray addObject:NSStringFromCGPoint(pointL2)];
            
            [myPointArray addObject:NSStringFromCGPoint(pointR2)];
            [myPointArray addObject:NSStringFromCGPoint(pointR3)];
            
        }else {
            if(q >= 3){
                CGFloat changeStep = 0.3;
                if (q<=8.3) {
                    changeStep = 0.4;
                }
                CGFloat gainChange = (q-2.9)*changeStep;
                if(model.gain >= -8.5 && model.gain <= 8.5  ){
                    if (q <= 4.0) {
                        changeStep =  changeStep + (4.5-q)*1.6;
                    }
                    else if (q <= 5.0) {
                        changeStep =  changeStep + 0.8;
                    }else if (q <= 10){
                        changeStep =  changeStep + 0.2;
                    }else if (q <= 20){
                        changeStep =  changeStep + 0.1;
                    }
                    gainChange = (q-2.9)*changeStep;
                    if (q >= 3.0 && q <= 3.2) {
                        gainChange = 0.6;
                    }
                }
                pointL3 = CGPointMake(bandX - 60, 0 + gainChange);
                pointL2 = CGPointMake(bandX - 25,  (60 +(q-3)*10));
                pointL1 = CGPointMake((pointL3.x + pointL2.x)/2 ,  (pointL3.y + pointL2.y)/2 ) ;
                pointL4 = CGPointMake(bandX - 80, 0);
            
            
                pointR2 = CGPointMake(bandX + 25,-gainA*2 - (60 +(q-3)*10));
                pointR3 = CGPointMake(bandX + 60, -gainA*2 -gainChange);
                pointR1 = CGPointMake((pointR3.x + pointR2.x)/2,  (pointR3.y + pointR2.y)/2 );
                pointR4 = CGPointMake(bandX + 80, -gainA*2 );
            }else{
                CGFloat changeStep = 0.0;
                CGFloat gainChange = (3 -q)*changeStep;
                if(model.gain >= -8.5 && model.gain <= 8.5){
                    changeStep = 0.2;
                    gainChange = (3 -q)*changeStep;
                    if (q >= 2.4) {
                        gainChange = 0.6;
                    }
                }
                pointL3 = CGPointMake(bandX - 60, 0 + gainChange);
                pointL2 = CGPointMake(bandX - 25,  (q-1)*30);
                pointL1 = CGPointMake((pointL3.x + pointL2.x)/2 ,  (pointL3.y + pointL2.y)/2 ) ;
                pointL4 = CGPointMake(bandX - 80, 0);
                
                pointR2 = CGPointMake(bandX + 25,-gainA*2 - (q-1)*30);
                pointR3 = CGPointMake(bandX + 60, -gainA*2 - gainChange);
                pointR1 = CGPointMake((pointR3.x + pointR2.x)/2,  (pointR3.y + pointR2.y)/2 );
                pointR4 = CGPointMake(bandX + 80, -gainA*2 );
            }
            
            if (gain < 0) {
                pointL3.y = - pointL3.y;
                pointL2.y = - pointL2.y;
                pointL1.y = - pointL1.y;
                pointL4.y = - pointL4.y;
                
                pointR2.y = - pointR2.y;
                pointR3.y = - pointR3.y;
                pointR1.y = - pointR1.y;
                pointR4.y = - pointR4.y;
            }
            if (model.bandType == bandType_LSHF) {
                CGPoint pointCopy1, pointCopy2,pointCopy3, pointCopy4;
                pointCopy3 = pointL3;
                pointCopy2 = pointL2;
                pointCopy1 = pointL1;
                pointCopy4 = pointL4;
                
                pointL3.y = pointR3.y;
                pointL2.y = pointR2.y;
                pointL1.y = pointR1.y;
                pointL4.y = pointR4.y;
                
                pointR3.y = pointCopy3.y;
                pointR2.y = pointCopy2.y;
                pointR1.y = pointCopy1.y;
                pointR4.y = pointCopy4.y;
            }
            [myPointArray addObject:NSStringFromCGPoint(pointL4)];
            [myPointArray addObject:NSStringFromCGPoint(pointL3)];
            [myPointArray addObject:NSStringFromCGPoint(pointL1)];
            [myPointArray addObject:NSStringFromCGPoint(pointL2)];
            
            [myPointArray addObject:NSStringFromCGPoint(pointR2)];
            [myPointArray addObject:NSStringFromCGPoint(pointR1)];
            [myPointArray addObject:NSStringFromCGPoint(pointR3)];
            [myPointArray addObject:NSStringFromCGPoint(pointR4)];
        }

    model.shelfDictionary = [self createCurveWith:myPointArray withCount:myPointArray.count];
}

- (void)drawRect:(CGRect)rect {
    
//    DISPATCH_ON_GROUP_THREAD((^{
//        self.wigth = rect.size.width;
//        self.height = rect.size.height;
//
////        CGContextRef cgctx=UIGraphicsGetCurrentContext();
////        CGContextSetLineWidth(cgctx, 1.50f);
////        CGContextSetStrokeColorWithColor(cgctx, [UIColor greenColor].CGColor);
//        float y = 0.0;
//        for(int x=0;x<rect.size.width;x++){
//            y = [self changeViewWithX:x];
//
//            NSString *xStr = [NSString stringWithFormat:@"%d",x];
//            NSString *yStr = [NSString stringWithFormat:@"%f",y];
//            [rectArray addObject:@{xStr:yStr}];
////            if (x == (int)self.selectBandX) {
////                CGContextAddLineToPoint(cgctx,x,y);
////                CGContextStrokePath(cgctx);
////                CGContextMoveToPoint(cgctx,x,y);
////
////                CGContextSetLineWidth(cgctx, 2.5f);
////                if (y > zeroHeight - 1) { //初始圆点停在 zeroHeight-1 的位置
////                    CGContextAddEllipseInRect(cgctx, CGRectMake((x - 1), y-0.8, 2.5, 2.5));
////                }else if ( y < zeroHeight-1){//初始圆点停在 zeroHeight-1 的位置
////
////                    CGContextAddEllipseInRect(cgctx, CGRectMake((x - 1), y -1.2 , 2.5, 2.5));
////                }else{
////                    CGContextAddEllipseInRect(cgctx, CGRectMake((x - 1), y-1.5, 2.5, 2.5));
////                }
////            }else{
////                CGContextSetLineWidth(cgctx, 1.5f);
////            }
////
////            CGContextAddLineToPoint(cgctx,x,y);
////            CGContextStrokePath(cgctx);
////            CGContextMoveToPoint(cgctx,x,y);
//        }
//        DISPATCH_ON_MAIN_THREAD(^{
            CGContextRef cgctx=UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(cgctx, 1.50f);
            CGContextSetStrokeColorWithColor(cgctx, [UIColor greenColor].CGColor);
            
            for (NSDictionary *dict in self.rectArray) {
                NSString *xStr = dict.allKeys.firstObject;
                NSString *yStr = dict[xStr];
                int x = xStr.intValue;
                CGFloat y = yStr.floatValue;
                if (x == (int)self.selectBandX) {
                    CGContextAddLineToPoint(cgctx,x,y);
                    CGContextStrokePath(cgctx);
                    CGContextMoveToPoint(cgctx,x,y);
                    
                    CGContextSetLineWidth(cgctx, 2.5f);
                    if (y > zeroHeight - 1) { //初始圆点停在 zeroHeight-1 的位置
                        CGContextAddEllipseInRect(cgctx, CGRectMake((x - 1), y-0.8, 2.5, 2.5));
                    }else if ( y < zeroHeight-1){//初始圆点停在 zeroHeight-1 的位置
                        
                        CGContextAddEllipseInRect(cgctx, CGRectMake((x - 1), y -1.2 , 2.5, 2.5));
                    }else{
                        CGContextAddEllipseInRect(cgctx, CGRectMake((x - 1), y-1.5, 2.5, 2.5));
                    }
                }else{
                    CGContextSetLineWidth(cgctx, 1.5f);
                }
                
                CGContextAddLineToPoint(cgctx,x,y);
                CGContextStrokePath(cgctx);
                CGContextMoveToPoint(cgctx,x,y);
            }
            //必须等上面绘制完成后才能绘制下面 所以不能放在一个循环里面
            for (NSDictionary *dict in self.rectArray) {
                NSString *xStr = dict.allKeys.firstObject;
                NSString *yStr = dict[xStr];
                int x = xStr.intValue;
                CGFloat y = yStr.floatValue;
                [self drawLineX:x Y:y+1];
            }
//        })
    
        //必须等上面绘制完成后才能绘制下面 所以不能放在一个循环里面
        //        for(float x=0;x<rect.size.width;x++){
        //            y = [self changeViewWithX:x];
        //            //绘制直线区域
        //            [self drawLineX:x Y:y+1];
        //        }
//    }))
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
-(CGFloat)changeViewWithX:(int)x{
    CGFloat Y = 0.0;
    if (kArrayIsEmpty(self.bandArray)) {
    }else{
        for (eqBandModel *model in self.bandArray) {
            Y = Y + [self Y_WithX:x withBandX:model.bandX withGain:self.height/24*model.gain withQ:model.Q withBandType:model.bandType withModel:model];
        }
    }
    return Y+ zeroHeight;
}

- (void)dealloc {

}
-(CGFloat)Y_WithX:(int)x withBandX:(CGFloat)bandX withGain:(CGFloat)gain withQ:(CGFloat)q withBandType:(CSQBandType)bandType withModel:(eqBandModel*)eqBandModel{
    CGFloat y = 0;
    bandX = (int)bandX;
    if (bandType == bandType_PEQ) {
        if (gain < 0) {
            gain = sqrt(gain * gain);
            if (x< (bandX - sqrt(gain/q))) {
            }else if(x > (bandX + sqrt(gain/q)))
            {
            }else if (x > (bandX - sqrt(gain/q)) && x <= bandX){
                y = q *  (x - (bandX - sqrt(gain/q))) * (x - (bandX - sqrt(gain/q)));
            }else {
                y = q *  (x - (bandX + sqrt(gain/q))) * (x - (bandX + sqrt(gain/q)));
            }
        }else{
            if (x< (bandX - sqrt(gain/q))) {
            }else if(x > (bandX + sqrt(gain/q)))
            {
            }else if (x > (bandX - sqrt(gain/q)) && x <= bandX){
                y = q *  (x - (bandX - sqrt(gain/q))) * (x - (bandX - sqrt(gain/q)));
                y = -y;
            }else {
                y = q *  (x - (bandX + sqrt(gain/q))) * (x - (bandX + sqrt(gain/q)));
                y = -y;
            }
        }
    }else if(bandType == bandType_HSLF || bandType == bandType_LSHF){

        CGFloat q = eqBandModel.Slf_Q * Q_changeV;
        CGFloat gainA = self.height/24*eqBandModel.gain;
        if (eqBandModel.gain <= 0.1 && eqBandModel.gain >= -0.1) {
            return y;
        }
        gainA = gainA/2.0;
        CGFloat bandX = eqBandModel.bandX;
    if (CsqDebug) {
        if (q <= qPoint) {
            CGFloat csqChangeZero = 6;
            if ( q< 0.5) {
                csqChangeZero = 9;
            }else if (q > 0.7 && q < 1.0){
                csqChangeZero = 5;
            }else if(q == 1.0){
                csqChangeZero = 5.5;
            }
            
            
                q = 0.6 + q/2.0;
                if (x < bandX - 50/(q*q) + csqChangeZero) {
                    if (bandType == bandType_HSLF ) {
                         y = 0;
                    }else{
                        y = gainA * 2;
                    }
                   
                }else if (x > bandX + 50/(q*q) - csqChangeZero){
                    if (bandType == bandType_HSLF ) {
                        y = gainA * 2;
                    }else{
                        y = 0;
                    }
                }else{
                    y = [self getY_fromX:x model:eqBandModel];
//                    for (id object in eqBandModel.shelfArray) {
//                        CGPoint retrievedPoint = CGPointFromString(object);
//                        if (x == (int)retrievedPoint.x) {
//                            y = retrievedPoint.y;
//                            break;
//                        }
//                    }
                }
            
            y = - y;
        }else{
            CGFloat csqChangeZero = 65;
            
            if ( q == 1.1) {
                csqChangeZero = 62;
            }else if (q <= 2.4){
                csqChangeZero = 59;
            }
//            else if (q >= 3.0){
//                csqChangeZero = 59;
//            }
                if (x < bandX - csqChangeZero) {
                    if (bandType == bandType_HSLF ) {
                        y = 0;
                    }else{
                        y = -gainA * 2;
                    }
                }else if (x > bandX + csqChangeZero){
                    if (bandType == bandType_HSLF ) {
                        y = -gainA * 2;
                    }else{
                        y = 0;
                    }
                }else{
                    y = [self getY_fromX:x model:eqBandModel];
                }
        }
    }
        
        
    }
    return  y ;
}
//#define originPoint[i] CGPointFromString([originPoint objectAtIndex:i]
//void createCurve(CGPoint *originPoint,int originCount){
-(instancetype)createCurveWith:(NSArray*)originPoint withCount:(int)originCount{
//    NSMutableArray *pointArray = [NSMutableArray array];
    NSMutableDictionary *pointDictionary = [NSMutableDictionary dictionary];
//    NSMutableArray *addArray = [NSMutableArray array];
    //控制点收缩系数 ，经调试0.6较好，CvPoint是<a href="http://lib.csdn.net/base/opencv" class='replace_word' title="OpenCV知识库" target='_blank' style='color:#df3434; font-weight:bold;'>OpenCV</a>的，可自行定义结构体(x,y)
    float scale = 0.6;
    CGPoint midpoints[originCount];
    //生成中点
    for(int i = 0 ;i < originCount ; i++){
        int nexti = (i + 1) % originCount;
        CGPoint retrievedPoint = CGPointFromString([originPoint objectAtIndex:i]);
        CGPoint retrievedPointNexti = CGPointFromString([originPoint objectAtIndex:nexti]);
        
        midpoints[i].x = (retrievedPoint.x + retrievedPointNexti.x)/2.0;
        midpoints[i].y = (retrievedPoint.y + retrievedPointNexti.y)/2.0;
    }
    
    //平移中点
    CGPoint extrapoints[2 * originCount];
    for(int i = 0 ;i < originCount ; i++){
//        int nexti = (i + 1) % originCount;
        int backi = (i + originCount - 1) % originCount;
        
        CGPoint retrievedPoint = CGPointFromString([originPoint objectAtIndex:i]);
//        CGPoint retrievedPointNexti = CGPointFromString([originPoint objectAtIndex:nexti]);
        
        CGPoint midinmid;
        midinmid.x = (midpoints[i].x + midpoints[backi].x)/2.0;
        midinmid.y = (midpoints[i].y + midpoints[backi].y)/2.0;
        int offsetx = retrievedPoint.x - midinmid.x;
        int offsety = retrievedPoint.y - midinmid.y;
        int extraindex = 2 * i;
        extrapoints[extraindex].x = midpoints[backi].x + offsetx;
        extrapoints[extraindex].y = midpoints[backi].y + offsety;
        //朝 originPoint[i]方向收缩
        int addx = (extrapoints[extraindex].x - retrievedPoint.x) * scale;
        int addy = (extrapoints[extraindex].y - retrievedPoint.y) * scale;
//        addx = -addx;
//        addy= - addy;
        extrapoints[extraindex].x = retrievedPoint.x + addx;
        extrapoints[extraindex].y = retrievedPoint.y + addy;
        
        int extranexti = (extraindex + 1)%(2 * originCount);
        extrapoints[extranexti].x = midpoints[i].x + offsetx;
        extrapoints[extranexti].y = midpoints[i].y + offsety;
        //朝 originPoint[i]方向收缩
//        addx = -addx;
//        addy= - addy;
        addx = (extrapoints[extranexti].x - retrievedPoint.x) * scale;
        addy = (extrapoints[extranexti].y - retrievedPoint.y) * scale;
        extrapoints[extranexti].x = retrievedPoint.x + addx;
        extrapoints[extranexti].y = retrievedPoint.y + addy;
    }
    
    CGPoint controlPoint[4];
    //生成4控制点，产生贝塞尔曲线
    for(int i = 0 ;i < originCount ; i++){
        CGPoint retrievedPoint = CGPointFromString([originPoint objectAtIndex:i]);
        int nexti = (i + 1) % originCount;
        CGPoint retrievedPointNexti = CGPointFromString([originPoint objectAtIndex:nexti]);
        controlPoint[0] = retrievedPoint;
        int extraindex = 2 * i;
        controlPoint[1] = extrapoints[extraindex + 1];
        int extranexti = (extraindex + 2) % (2 * originCount);
        controlPoint[2] = extrapoints[extranexti];
       
        controlPoint[3] = retrievedPointNexti;
        float u = 1;
        float step = 0.01;
        while(u >= 0){
            int px = bezier3funcX(u,controlPoint);

            if ([pointDictionary.allKeys containsObject:[NSString stringWithFormat:@"%d",px]]) {
                u -= step;
//                SDLog(@"beisaier_continue");
                continue;
            }
            
            CGFloat py = bezier3funcY(u,controlPoint);
            //u的步长决定曲线的疏密 0.005
            u -= step;
            [pointDictionary setObject:[NSString stringWithFormat:@"%f",py] forKey:[NSString stringWithFormat:@"%d",px]];
//            CGPoint tempP = CGPointMake( px, py);
//             [pointArray addObject:NSStringFromCGPoint(tempP)];

        }
    }
    return pointDictionary;
}
//三次贝塞尔曲线
float bezier3funcX(float uu,CGPoint *controlP){
    float part0 = controlP[0].x * uu * uu * uu;
    float part1 = 3 * controlP[1].x * uu * uu * (1 - uu);
    float part2 = 3 * controlP[2].x * uu * (1 - uu) * (1 - uu);
    float part3 = controlP[3].x * (1 - uu) * (1 - uu) * (1 - uu);
    return part0 + part1 + part2 + part3;
}
float bezier3funcY(float uu,CGPoint *controlP){
    float part0 = controlP[0].y * uu * uu * uu;
    float part1 = 3 * controlP[1].y * uu * uu * (1 - uu);
    float part2 = 3 * controlP[2].y * uu * (1 - uu) * (1 - uu);
    float part3 = controlP[3].y * (1 - uu) * (1 - uu) * (1 - uu);
    return part0 + part1 + part2 + part3;
}





-(CGFloat )getY_fromX:(int)x model:(eqBandModel*)eqBandModel{
    CGFloat y = 0;
    NSString *keyX = [NSString stringWithFormat:@"%d",x];
    if ([eqBandModel.shelfDictionary.allKeys containsObject:keyX]) {
        y = [(NSString*)[eqBandModel.shelfDictionary objectForKey:keyX] floatValue];
    }else{
        CGFloat addY = 0,deleY = 0;
        
        BOOL addContains = NO ;
        NSInteger addX = x;
        while (!addContains && addX < self.width) {
            addX++;
            NSString *addKeyX = [NSString stringWithFormat:@"%d",addX];
            if ([eqBandModel.shelfDictionary.allKeys containsObject:addKeyX]) {
                addContains = YES;
                addY = [(NSString*)[eqBandModel.shelfDictionary objectForKey:addKeyX] floatValue];
                break;
            }
        }
        
        BOOL deleContains = NO ;
        NSInteger deleX = x;
        while (!deleContains && deleX > 0) {
            deleX--;
            NSString *deleKeyX = [NSString stringWithFormat:@"%d",deleX];
            if ([eqBandModel.shelfDictionary.allKeys containsObject:deleKeyX]) {
                deleContains = YES;
                deleY = [(NSString*)[eqBandModel.shelfDictionary objectForKey:deleKeyX] floatValue];
                break;
            }
        }
        if (!deleContains) {
            if (addContains) {
                y = addY/(addX - x);
            }
        }else{
            if (!addContains) {
                y = deleY/(x - deleX);
            }else{
                y =  ((deleY + addY)/2)*((x-deleX)/(addX - x));
            }
        }
    }
    return y;
}

@end
