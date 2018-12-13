//
//  CSQ_rtaCollectionView.m
//  DSP
//
//  Created by hk on 2018/9/10.
//  Copyright © 2018年 hk. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "CSQ_rtaCollectionView.h"
#import "CSQ_rtaModel.h"
@implementation CSQ_rtaCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(instancetype)init{
//    if (self = [super init]) {
//        self.data1Array = [NSMutableArray array];
//        self.data2Array = [NSMutableArray array];
//        self.data3Array = [NSMutableArray array];
//        [self setUp];
//    }
//    return self;
//}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.data1Array = [NSMutableArray array];
//        self.data2Array = [NSMutableArray array];
//        self.data3Array = [NSMutableArray array];
        [self setUp];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.data1Array = [NSMutableArray array];
//        self.data2Array = [NSMutableArray array];
//        self.data3Array = [NSMutableArray array];
        [self setUp];
    }
    return self;
}
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self layoutIfNeeded];
//}
-(void)layoutSubviews{
   
    [super layoutSubviews];
    
}
-(void)setUp{
    NSArray *ineqArray = @[@25,@40,@60,@80,@100,@200,@300,@500,@800,@1000,@1200,@1600,@2000,@3000,@4000,@6000,@8000,@10000,@12000,@16000];
    for (int i = 0; i < 20 ; i++) {
        CSQ_rtaModel *model = [[CSQ_rtaModel alloc]init];
        model.float1 = 0 ;
        model.float2 = 0;
        model.float3 = 0;
        model.freqFload = (NSInteger)ineqArray[i];
        [self.data1Array addObject:model];
    }

    
    self.moveBackView = [[UIView alloc]init];
    self.moveBackView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.moveBackView removeFromSuperview];
    }];
    [self.moveBackView addGestureRecognizer:tap];
    
    

    
    self.bandLabel = [[UILabel alloc]init];
    self.bandLabel.textColor = [UIColor whiteColor];
    self.bandLabel.backgroundColor = [UIColor clearColor];
    [self.moveBackView addSubview:self.bandLabel];
    
    self.freqLabel = [[UILabel alloc]init];
    self.freqLabel.backgroundColor = [UIColor clearColor];
    self.freqLabel.textColor = [UIColor whiteColor];
    [self.moveBackView addSubview:self.freqLabel];
    
    self.moveView = [[UIView alloc]init];
    self.moveView.backgroundColor = [UIColor clearColor];
    [self.moveBackView addSubview:self.moveView];
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(doMoveAction:)];
    [self.moveView addGestureRecognizer:panGestureRecognizer];
    
    
    
    
    self.shuLineLabel = [[UILabel alloc]init];
    self.shuLineLabel.backgroundColor = [UIColor redColor];
    [self.moveView addSubview:self.shuLineLabel];
    
    self.henLineLabel = [[UILabel alloc]init];
    self.henLineLabel.backgroundColor = [UIColor redColor];
    [self.moveBackView addSubview:self.henLineLabel];
    
//    [self.moveBackView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.equalTo(self);
//        make.left.right.bottom.top.equalTo(self);
//    }];
}
-(void)moveBackViewAddToView:(UIView*)toView{
    self.moveBackView.frame = self.frame;
    [toView addSubview:self.moveBackView];
    [self addMoveBackView];
}

-(void)addMoveBackView{
    [self.bandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.moveBackView).offset(10);
        make.height.equalTo(@25);
    }];
    
    [self.freqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bandLabel.mas_bottom).offset(10);
        make.height.equalTo(@25);
        make.left.equalTo(self.moveBackView).offset(10);
    }];
    
    [self.moveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.moveBackView);
        make.width.equalTo(@collectWidth);
        make.centerX.equalTo(self.moveBackView.centerX).offset(10);
    }];
    
    [self.shuLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.moveView);
        make.width.equalTo(@1.5);
        make.centerX.equalTo(self.moveView.centerX);
    }];
    
    [self.henLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.moveBackView);
        make.height.equalTo(@1.5);
    }];
}
-(void)reloadData{
    [super reloadData];
    if (self.seleRow >= 0) {
        CSQ_rtaModel *model = _data1Array[self.seleRow];
        [self.henLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.moveBackView);
            make.bottom.equalTo(self.moveBackView).offset(-model.float1);
            make.height.equalTo(@1.5);
        }];
        self.bandLabel.text = [NSString stringWithFormat:@"band:%ld",(long)self.seleRow];
        self.freqLabel.text = [NSString stringWithFormat:@"freq:%.0f",model.float1];
    }
}
-(void)doMoveAction:(UIPanGestureRecognizer *)recognizer{
    // Figure out where the user is trying to drag the view.
    
    CGPoint translation = [recognizer translationInView:self.moveView];
    SDLog(@"translation.x = %f  " , translation.x);
    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                    recognizer.view.center.y );
     //    限制屏幕范围：
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.moveView.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
//    recognizer.view.center = newCenter;
    if (translation.x >= rta_cellWidth || translation.x <= -rta_cellWidth) {
        self.seleRow = self.seleRow + (int)(translation.x/rta_cellWidth);
        self.seleRow = MIN(19, self.seleRow);
        self.seleRow = MAX(0, self.seleRow);
        [self.moveView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.moveBackView.centerX).offset(rta_cellWidth * (self.seleRow - 10 + 0.5));
        }];
        [self reloadData];
        [recognizer setTranslation:CGPointZero inView:self.moveView];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
    }
}

@end
