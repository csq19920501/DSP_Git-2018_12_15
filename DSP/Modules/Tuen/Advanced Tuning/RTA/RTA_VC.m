//
//  RTA_VC.m
//  DSP
//
//  Created by hk on 2018/6/20.
//  Copyright © 2018年 hk. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
//#import "AAChartKit.h"
#import "RTA_VC.h"
#import "CSQ_rtaCollectionCell.h"
#import "CSQ_rtaCollectionView.h"

@interface RTA_VC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSTimer *_timer;
    BOOL AAChartViewDidFinishLoad;
    BOOL _setp1Saved;
    BOOL _setp2Saved;
    BOOL _setp3Saved;
}
@property (weak, nonatomic) IBOutlet CSQ_rtaCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *starStopButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonRightConstraint;
@property (weak, nonatomic) IBOutlet UIView *chartBackView;
//@property (nonatomic,strong)AAChartView *aaChartView;
@property(nonatomic,assign)BOOL isNeedPush;
@property (weak, nonatomic) IBOutlet UIView *changeSeleView;
@property(nonatomic,assign)int stepInt;
@property(nonatomic,assign)int seleTag;
@end

@implementation RTA_VC
- (IBAction)InPutClick:(id)sender {
    self.changeSeleView.hidden = NO;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changeModel:(id)sender {
    self.changeSeleView.hidden = YES;
    for (UIButton *but in self.changeSeleView.subviews) {
        if ([but isKindOfClass:[UIButton class]]) {
            but.backgroundColor = [UIColor lightGrayColor];
            //        but.enabled = YES;
            but.layer.masksToBounds = YES;
            but.layer.cornerRadius = 8;
        }
    }
    UIButton *seleBut = (UIButton*)sender;
    seleBut.backgroundColor = [UIColor greenColor];
//    seleBut.enabled = NO;
    
    int nowSeletag = (int)seleBut.tag;
    if (nowSeletag == self.seleTag){
        
    }else if (self.seleTag/100 != nowSeletag/100 && nowSeletag!= 905) {
        [self setStepInt:1];
    }else if (nowSeletag != self.seleTag){
        if (self.stepInt == 2) {
            if (_setp2Saved) {
                [self setStepInt:3];
            }
        }else if (self.stepInt == 1) {
            if (_setp1Saved) {
                [self setStepInt:2];
            }
        }
    }
    self.seleTag = (int)seleBut.tag;
}

- (IBAction)starStop:(id)sender {
    if (_stepInt != 4) {
        UIButton *but  = (UIButton *)sender;
        if (!but.selected) {
            [_timer setFireDate:[NSDate distantFuture]];
        }else{
            [_timer setFireDate:[NSDate date]];
        }
        but.selected = !but.selected;
    }
}
- (IBAction)saveData:(id)sender {
    if (_stepInt == 1) {
        for (CSQ_rtaModel*model in self.collectionView.data1Array) {
            model.float2 = model.float1 ;
        }
        _setp1Saved = YES;
    }else if (_stepInt == 2) {
        for (CSQ_rtaModel*model in self.collectionView.data1Array) {
            model.float3 = model.float1 ;
        }
        _setp2Saved = YES;
    }else if (_stepInt == 3) {
        self.stepInt = self.stepInt + 1;
        self.starStopButton.selected = YES;
        [_timer setFireDate:[NSDate distantFuture]];
        _setp3Saved = YES;
    }
}
-(void)setStepInt:(int)stepInt{
    _stepInt = stepInt;
    if (_stepInt != 4) {
        self.starStopButton.selected = NO;
        [_timer setFireDate:[NSDate date]];
    }
    if (stepInt == 1) {
        UIButton *but = (UIButton*)[self.view   viewWithTag:1001];
        but.backgroundColor = [UIColor greenColor];
        but.enabled = YES;
        
        UIButton *but2 = (UIButton*)[self.view   viewWithTag:1002];
        but2.enabled = NO;
        UIButton *but3 = (UIButton*)[self.view   viewWithTag:1003];
        but3.enabled = NO;
        but2.backgroundColor = [UIColor grayColor];
        but3.backgroundColor = [UIColor grayColor];
        
        for (CSQ_rtaModel*model in self.collectionView.data1Array) {
            model.float2 = 0 ;
            model.float3 = 0;
        }
        _setp1Saved = NO;
        _setp2Saved = NO;
        _setp3Saved = NO;
        
    }else if (stepInt == 2) {
        UIButton *but = (UIButton*)[self.view   viewWithTag:1002];
        but.backgroundColor = [UIColor greenColor];
        but.enabled = YES;
        
        UIButton *but2 = (UIButton*)[self.view   viewWithTag:1001];
        but2.enabled = NO;
        UIButton *but3 = (UIButton*)[self.view   viewWithTag:1003];
        but3.enabled = NO;
        but2.backgroundColor = [UIColor grayColor];
        but3.backgroundColor = [UIColor grayColor];
    }
    else if (stepInt == 3) {
        UIButton *but = (UIButton*)[self.view   viewWithTag:1003];
        but.backgroundColor = [UIColor greenColor];
        but.enabled = YES;
        
        UIButton *but2 = (UIButton*)[self.view   viewWithTag:1002];
        but2.enabled = NO;
        UIButton *but3 = (UIButton*)[self.view   viewWithTag:1001];
        but3.enabled = NO;
        but2.backgroundColor = [UIColor grayColor];
        but3.backgroundColor = [UIColor grayColor];
    }else {
        UIButton *but = (UIButton*)[self.view   viewWithTag:1003];
        but.backgroundColor = [UIColor grayColor];
        but.enabled = NO;
        
        UIButton *but2 = (UIButton*)[self.view   viewWithTag:1002];
        but2.enabled = NO;
        UIButton *but3 = (UIButton*)[self.view   viewWithTag:1001];
        but3.enabled = NO;
        but2.backgroundColor = [UIColor grayColor];
        but3.backgroundColor = [UIColor grayColor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _isNeedPush = YES;
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];

    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
    if (isIphoneX) {
        self.backButtonRightConstraint.constant = 50.;
    }
    
//    DISPATCH_ON_MAIN_THREAD((^{
//        self.aaChartView =[[AAChartView alloc]initWithFrame:self.chartBackView.bounds];
//        self.aaChartView.contentHeight = self.aaChartView.frame.size.height;
//        self.aaChartView.isClearBackgroundColor = YES;
//        self.aaChartView.delegate = self;
//        [self.chartBackView addSubview:self.aaChartView];
//        self.aaChartView.scrollEnabled = NO;
//
//        AAOptions *aaOptions = [self configureTheNoGapColunmChart];
//        [self.aaChartView aa_drawChartWithOptions:aaOptions];
//    }))
    [self configCollectionView];
}
-(void)configCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(rta_cellWidth , collectHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView.collectionViewLayout = layout;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = _collectionView.bounds.size;
    [_collectionView registerClass:[CSQ_rtaCollectionCell class] forCellWithReuseIdentifier:@"CSQ_rtaCollectionCell"];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionView.data1Array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSQ_rtaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSQ_rtaCollectionCell" forIndexPath:indexPath];
    cell.rtaModel = _collectionView.data1Array[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

//    self.collectionView.moveBackView.frame = self.collectionView.frame;
//    [self.view addSubview:self.collectionView.moveBackView];
    self.collectionView.seleRow = indexPath.row;
    [self.collectionView moveBackViewAddToView:self.view];

    [self.collectionView.moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.collectionView.moveBackView);
        make.width.equalTo(@collectWidth);
        make.centerX.equalTo(self.collectionView.moveBackView.centerX).offset(rta_cellWidth * (indexPath.row - 10 + 0.5));
    }];

}

//使用这里的代码也是oK的。 这里利用 NSInvocation 调用 对象的消息
 - (void) viewWillAppear:(BOOL)animated
 {
    [super viewWillAppear:animated];
     
    getTimer(_timer,1,timerStartWork);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    endTimer(_timer)
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    SDLog(@"修改横屏");
    return   UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)timerStartWork{
    
    for (CSQ_rtaModel*model in self.collectionView.data1Array) {
            model.float1 = arc4random()%200 ;
    }
    [self.collectionView reloadData];
    
}
@end
