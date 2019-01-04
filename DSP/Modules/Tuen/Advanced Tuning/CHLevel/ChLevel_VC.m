//
//  ChLevel_VC.m
//  DSP
//
//  Created by hk on 2018/6/20.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "ChLevel_VC.h"
#import "RTA_VC.h"
#import "CYTabBarController.h"
#import "ShowCarView.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "hornDataModel.h"
#import "CustomerCar.h"
#import "SocketManager.h"
@interface ChLevel_VC ()<CYTabBarDelegate,UIScrollViewDelegate>
{
    
}
@property(nonatomic,strong)UIScrollView *CarScrView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet UIView *scrollerBackView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@end

@implementation ChLevel_VC
- (IBAction)backClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
//    [self.tabBarController removeFromParentViewController];
    
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app.homeNavi removeFromParentViewController];
//    app.homeNavi = nil;
//    app.homeNavi = [[RootNavigationController   alloc]initWithRootViewController:[HomeViewController new]];
//    //默认开启系统右划返回
//    app.homeNavi.interactivePopGestureRecognizer.enabled = YES;
    KPostNotification(RemoveAllNotification, nil)
    [APPDELEGATE.homeNavi popToRootViewControllerAnimated:YES];
//    app.window.rootViewController = app.homeNavi;
//    [self.tabBarController removeFromParentViewController];
}
- (IBAction)saveClick:(id)sender {
    NSString *leftStr = [NSString stringWithFormat:@"Save to CH Level %@",[AppData managerAWithTag:503]];
    NSString *rightStr = [NSString stringWithFormat:@"Save to CH Level %@",[AppData managerAWithTag:603]];
    CusSeleView *chouseV = [[CusSeleView alloc]init];

    [chouseV showInView:[AppData theTopView] withOneTitle:leftStr TwoTitle:rightStr withTipTitle:@"Please select where to save?" withCancelClick:^{
        [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:3 withData1Int:0];
    } withConfirmClick:^{
        [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:3 withData1Int:1];
    }];
}
-(void)RemoveAllNotification{
//    SocketManagerShare.EQNeedRefresh = YES;
//    SocketManagerShare.ChlevelNeedRefresh = YES;
//    SocketManagerShare.ChDelayNeedRefresh = YES;
//    SocketManagerShare.CrossoverNeedRefresh = YES;
    SocketManagerShare.AckCurUiIdParameterNeedSecond = NO;
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    SDLog(@"移除通知111");
}
-(void)ChevelRefreshNotificaion{
    DISPATCH_ON_MAIN_THREAD(^{
        [UIUtil hideProgressHUD];
        [self.scrollerBackView removeAllSubviews];
        [self.CarScrView removeFromSuperview];
        [self setViews];
    })
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIphoneX) {
        self.VCBottomConstraint.constant = kTabBarHeight;
        self.naviBarHeight.constant = kTopHeight;
    }
//    MPWeakSelf(self)
//    [[NSNotificationCenter defaultCenter]addObserverForName:@"CHLEVEL" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//        NSDictionary *dcit = note.userInfo;
//        int num = [dcit[@"address"] intValue];
//        for (ShowCarView  *carView in self.CarScrView.subviews) {
//            if ([carView.upTypeLabel.text containsString:[NSString stringWithFormat:@"CH%d",num]]) {
//                [carView.upProgressView setSendData:^(){
//
//                }];
//                for ( hornDataModel *objc1  in DeviceToolShare.hornDataArray ) {
//                    if (objc1.outCh == num) {
//                        SDLog(@"接收数据处理%d",num);
//                        [carView.upProgressView setLevel:objc1.CHLevelFloat];
//                        CSQ_DISPATCH_AFTER(0.3, ^{
//                            [carView.upProgressView setSendData:^(){
//                                [weakself sendTipWithModel:objc1 WithCount:0];
//                                if (objc1.outCh == 8) {
//                                    DeviceToolShare.SUBLevel = objc1.CHLevelFloat;
//                                }
//                            }];
//
//                        })
//                    }
//                }
//            }else if ([carView.downTypeLabel.text containsString:[NSString stringWithFormat:@"CH%d",num]]) {
//                [carView.downProgressView setSendData:^(){
//
//                }];
//                for ( hornDataModel *objc1  in DeviceToolShare.hornDataArray ) {
//                    if (objc1.outCh == num) {
//                        [carView.downProgressView setLevel:objc1.CHLevelFloat];
//                        SDLog(@"接收数据处理%d",num);
//                        CSQ_DISPATCH_AFTER(0.3, ^{
//                            [carView.downProgressView setSendData:^(){
//                                [weakself sendTipWithModel:objc1 WithCount:0];
//                                if (objc1.outCh == 8) {
//                                    DeviceToolShare.SUBLevel = objc1.CHLevelFloat;
//                                }
//                            }];
//
//                        })
//                    }
//                }
//            }
//        }
//    }];
    
    KAddObserver(RemoveAllNotification, RemoveAllNotification, nil)
    KAddObserver(ChevelRefreshNotificaion, ChevelRefreshNotificaion, nil)
    if (SocketManagerShare.ChlevelNeedRefresh && SocketManagerShare.isCurrentWIFI) {
        [UIUtil showProgressHUD:nil inView:self.view];
//        [SocketManagerShare sendTwoDataTipWithType:AckCurUiIdParameter withCount:0 withData0Int:1 withData1Int:1];
    }else{
        [self.scrollerBackView removeAllSubviews];
        [self.CarScrView removeFromSuperview];
        [self setViews];
    }
}
-(void)setViews{
    
    
    DISPATCH_ON_MAIN_THREAD((^{
        NSArray *modelType ;
        if (DeviceToolShare.selectHornArray.count == 0) {
            modelType = @[@"204",@"254",@"201",@"251",@"206",@"256",@"209",@"208",];
            DeviceToolShare.selectHornArray = [NSMutableArray arrayWithArray:modelType];
        }else{
            modelType = DeviceToolShare.selectHornArray;
           
        }
        
        if (DeviceToolShare.hornDataArray.count == 0){
            //模拟数据
            for (int i = 0; i < modelType.count; i++) {
                hornDataModel *model = [[hornDataModel alloc]init];
                model.hornType = modelType[i];
                model.outCh = i + 1;
                [DeviceToolShare.hornDataArray addObject:model];
            }
        }else if(DeviceToolShare.hornDataArray.count >= 1){
            SDLog(@"DeviceToolShare.hornDataArray.count = %d",DeviceToolShare.hornDataArray.count);
        }

        //排序
        NSMutableArray *hornArray = [NSMutableArray arrayWithArray:DeviceToolShare.hornDataArray];
        [hornArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            hornDataModel *objc1 = (hornDataModel*)obj1;
            hornDataModel *objc2 = (hornDataModel*)obj2;
            return objc1.outCh  > objc2.outCh ;//简写方式
        }];
        //分组
        NSMutableArray *seleHornArray = [NSMutableArray array];
        while (hornArray.count != 0) {
       
            NSMutableArray * objcArray = [NSMutableArray array];
            hornDataModel * model = hornArray[0];
            [objcArray addObject:model];
            if (([model.hornType intValue] >= 201 && [model.hornType intValue] <= 207)
                || ([model.hornType intValue] >= 191 && [model.hornType intValue] <= 193)) {
                NSMutableArray *copyArray = [hornArray copy];
                for (hornDataModel * mod in copyArray) {
                    if ([mod.hornType intValue] == [model.hornType intValue] + 50) {
                        [objcArray addObject:mod];
                        [hornArray removeObject:mod];
                    }
                }
         
            }else if (([model.hornType intValue] >= 251 && [model.hornType intValue] <= 257)
                      || ([model.hornType intValue] >= 241 && [model.hornType intValue] <= 243)) {
                NSMutableArray *copyArray = [hornArray copy];
                for (hornDataModel * mod in copyArray) {
                    if ([mod.hornType intValue] == [model.hornType intValue] - 50) {
                        [objcArray addObject:mod];
                        [hornArray removeObject:mod];
                    }
                }
            }else if ([model.hornType intValue] == 208) {
                NSMutableArray *copyArray = [hornArray copy];
                for (hornDataModel * mod in copyArray) {
                    if ([mod.hornType intValue] == 209
                        || [mod.hornType intValue] == 210
                        || [mod.hornType intValue] == 211
                        || [mod.hornType intValue] == 212) {
                        [objcArray addObject:mod];
                        [hornArray removeObject:mod];
                    }
                }
            }else if ([model.hornType intValue] == 209
                      || [model.hornType intValue] == 210
                      || [model.hornType intValue] == 211
                      || [model.hornType intValue] == 212) {
                NSMutableArray *copyArray = [hornArray copy];
                for (hornDataModel * mod in copyArray) {
                    if ([mod.hornType intValue] == 208 ) {
                        [objcArray addObject:mod];
                        [hornArray removeObject:mod];
                    }
                }
            }else if ([model.hornType intValue] == 213) {
                NSMutableArray *copyArray = [hornArray copy];
                for (hornDataModel * mod in copyArray) {
                    if ([mod.hornType intValue] == 214) {
                        [objcArray addObject:mod];
                        [hornArray removeObject:mod];
                    }
                }
            }else if ([model.hornType intValue] == 214) {
                NSMutableArray *copyArray = [hornArray copy];
                for (hornDataModel * mod in copyArray) {
                    if ([mod.hornType intValue] == 213) {
                        [objcArray addObject:mod];
                        [hornArray removeObject:mod];
                    }
                }
            }
   
            [hornArray removeObject:model];
            [seleHornArray addObject:objcArray];
        }
        self.pageController.numberOfPages = seleHornArray.count;
        
        CGFloat height = self.scrollerBackView.bounds.size.height;
        CGFloat width = self.scrollerBackView.bounds.size.width;
        self.CarScrView = [[UIScrollView alloc]initWithFrame:self.scrollerBackView.bounds];
        self.CarScrView.contentSize = CGSizeMake(width * seleHornArray.count, height);
        self.CarScrView.showsHorizontalScrollIndicator = NO;
        self.CarScrView.pagingEnabled = YES;
        self.CarScrView.delegate = self;
        self.CarScrView.bounces = NO;
        [self.scrollerBackView addSubview:self.CarScrView];
        
        
        
        for (int i = 0;  i < seleHornArray.count; i++) {
            
            
            
            NSMutableArray * objcArray = seleHornArray[i];
            hornDataModel *model = objcArray[0];
            SDLog(@"hornDataModel %@  outch = %d",model,model.outCh);
            
            
            ShowCarView  *carView= [[ShowCarView alloc]init];
            carView.tag = 1000 + i;
            [carView showInView:self.CarScrView withFrame:CGRectMake(i *width, 0, width, height)];
            hornDataModel *upDeviceHornModel;
            hornDataModel *downDeviceHornModel;
            if (objcArray.count == 1) {
                
                hornDataModel *model = objcArray[0];
                
                
                
                if (([model.hornType intValue] >=201 && [model.hornType intValue] <= 207)
                    || ([model.hornType intValue] >=191 && [model.hornType intValue] <= 193)
                    || ([model.hornType intValue] >=209 && [model.hornType intValue] <= 212)
                    || [model.hornType intValue] == 213) {
    
                    carView.upTypeLabel.text = [NSString stringWithFormat:@"%@ CH%d",[CustomerCar changeTagToHorn:model.hornType],model.outCh];
                    
                    for (hornDataModel *deviceHornModel in DeviceToolShare.hornDataArray) {
                        if ([deviceHornModel.hornType isEqualToString:model.hornType]) {
                            upDeviceHornModel = deviceHornModel;
                        }
                    }
                    DISPATCH_ON_MAIN_THREAD((^{
                        [carView.upProgressView setMainLevel:Level120];
                        [carView.upProgressView drawProgress];
                        [carView.upProgressView setValueChange:^(CGFloat level){
                            
                            upDeviceHornModel.CHLevelFloat = level;
                            carView.upLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
                            carView.upLevelLabel.textColor = [UIColor greenColor];
                            
//                            suiJiFaSong([self sendTipWithModel:upDeviceHornModel WithCount:maxCount];)
                        }];
                        [carView.upProgressView setLevelNoNetwork:upDeviceHornModel.CHLevelFloat];
                        
                                [carView.downProgressView setMainLevel:120];
                                [carView.downProgressView drawProgress];
                                [carView.downProgressView setValueChange:^(CGFloat level){
                                    carView.downLevelLabel.text = [NSString stringWithFormat:@"%.1f",(level - 120)/2.0];
                                    carView.downLevelLabel.textColor = [UIColor greenColor];
                                    
                                    
//                                    suiJiFaSong([self sendTipWithModel:downDeviceHornModel WithCount:maxCount];)
                                }];
                        
                        carView.hiddentype = downHidden;
                    }))
                }else{
                    carView.downTypeLabel.text = [NSString stringWithFormat:@"%@ CH%d",[CustomerCar changeTagToHorn:model.hornType],model.outCh];
                    
                    for (hornDataModel *deviceHornModel in DeviceToolShare.hornDataArray) {
                        if ([deviceHornModel.hornType isEqualToString:model.hornType]) {
                            downDeviceHornModel = deviceHornModel;
                        }
                    }
                    DISPATCH_ON_MAIN_THREAD((^{
                        [carView.upProgressView setMainLevel:120];
                        [carView.upProgressView drawProgress];
                        [carView.upProgressView setValueChange:^(CGFloat level){
                                    carView.upLevelLabel.text = [NSString stringWithFormat:@"%.1f",(level - 120)/2.0];
                                    carView.upLevelLabel.textColor = [UIColor greenColor];
                                    
//                                    suiJiFaSong([self sendTipWithModel:upDeviceHornModel WithCount:maxCount];)
                        }];

                        [carView.downProgressView setMainLevel:Level120];
                        [carView.downProgressView drawProgress];
                        [carView.downProgressView setValueChange:^(CGFloat level){
                            downDeviceHornModel.CHLevelFloat = level;
                            carView.downLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
                            carView.downLevelLabel.textColor = [UIColor greenColor];
                            
//                            suiJiFaSong([self sendTipWithModel:downDeviceHornModel WithCount:maxCount];)
                        }];
                        [carView.downProgressView setLevelNoNetwork:downDeviceHornModel.CHLevelFloat];
                        carView.hiddentype = upHidden;
                    }))
                }
            }else if (objcArray.count == 2)
            {
                
                hornDataModel *upModel = objcArray[0];
                if (upModel.outCh >= CH1 && upModel.outCh <= CH6) {
                    carView.connectButton.selected = YES;
                }
                
                
//                carView.upTypeLabel.text = [CustomerCar changeTagToHorn:[NSString stringWithFormat:@"%d",upModel.outCh]];;
                carView.upTypeLabel.text = [NSString stringWithFormat:@"%@ CH%d",[CustomerCar changeTagToHorn:upModel.hornType],upModel.outCh];
                
                for (hornDataModel *deviceHornModel in DeviceToolShare.hornDataArray) {
                    if ([deviceHornModel.hornType isEqualToString:upModel.hornType]) {
                        upDeviceHornModel = deviceHornModel;
                    }
                }
                
                hornDataModel *downModel = objcArray[1];
               carView.downTypeLabel.text = [NSString stringWithFormat:@"%@ CH%d",[CustomerCar changeTagToHorn:downModel.hornType],downModel.outCh];
            
                for (hornDataModel *deviceHornModel in DeviceToolShare.hornDataArray) {
                    if ([deviceHornModel.hornType isEqualToString:downModel.hornType]) {
                        downDeviceHornModel = deviceHornModel;
                    }
                }
                
                DISPATCH_ON_MAIN_THREAD((^{
                [carView.upProgressView setMainLevel:Level120];
                [carView.upProgressView drawProgress];
                [carView.upProgressView setValueChange:^(CGFloat level){
                    
                    if (carView.connectButton.selected) {
                        SDLog(@"carView.upProgressView setValueChang");
                        CGFloat nowLevel = downDeviceHornModel.CHLevelFloat  + (level -upDeviceHornModel.CHLevelFloat );
                        nowLevel = nowLevel < 0 ? 0:nowLevel > Level120?Level120:nowLevel;
                        [carView.downProgressView setConnectLevel:nowLevel];
                        downDeviceHornModel.CHLevelFloat = nowLevel;
                        carView.downLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)downDeviceHornModel.CHLevelFloat - Level120)/2.0];
//                        suiJiFaSong([self sendTipWithModel:downDeviceHornModel WithCount:maxCount];)
                    }
                    upDeviceHornModel.CHLevelFloat = level;
                    carView.upLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
                    carView.upLevelLabel.textColor = [UIColor greenColor];
//                    suiJiFaSong([self sendTipWithModel:upDeviceHornModel WithCount:maxCount];)
                }];
                [carView.upProgressView setLevelNoNetwork:upDeviceHornModel.CHLevelFloat];
                
                [carView.downProgressView setMainLevel:Level120];
                [carView.downProgressView drawProgress];
                [carView.downProgressView setValueChange:^(CGFloat level){
                    
                    if (carView.connectButton.selected) {
                        SDLog(@"carView.downProgressView setValueChang");
                        CGFloat nowLevel = upDeviceHornModel.CHLevelFloat  + (level -downDeviceHornModel.CHLevelFloat );
                        nowLevel = nowLevel < 0 ? 0:nowLevel > Level120?Level120:nowLevel;
                        [carView.upProgressView setConnectLevel:nowLevel];
                        upDeviceHornModel.CHLevelFloat = nowLevel;
                        carView.upLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)upDeviceHornModel.CHLevelFloat - Level120)/2.0];
                        
//                        suiJiFaSong([self sendTipWithModel:upDeviceHornModel WithCount:maxCount];)
                    }
                    downDeviceHornModel.CHLevelFloat = level;
                    carView.downLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
                    carView.downLevelLabel.textColor = [UIColor greenColor];
                    
//                    suiJiFaSong([self sendTipWithModel:downDeviceHornModel WithCount:maxCount];)
                }];
                [carView.downProgressView setLevelNoNetwork:downDeviceHornModel.CHLevelFloat];
                }))
            }

            CSQ_DISPATCH_AFTER(1.0, ^{
                [carView.upProgressView setSendData:^(){
                    [self sendTipWithModel:upDeviceHornModel WithCount:0];
                    
                    if (upDeviceHornModel.outCh == 8) {
                        DeviceToolShare.SUBLevel = upDeviceHornModel.CHLevelFloat;
                    }
                }];
                [carView.downProgressView setSendData:^(){
                    [self sendTipWithModel:downDeviceHornModel WithCount:0];
                    
                    if (downDeviceHornModel.outCh == 8) {
                        DeviceToolShare.SUBLevel = downDeviceHornModel.CHLevelFloat;
                    }
                }];
            })
        }
    }))
}

-(void)sendTipWithModel:(hornDataModel*)model WithCount:(int)count{
    NSInteger type = model.outCh+100;
    [SocketManagerShare sendTwoDataTipWithType:type withCount:count withData0Int:0 withData1Int:model.CHLevelFloat];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     CYTABBARCONTROLLER.tabbar.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CYTabBarDelegate
//中间按钮点击
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton{
    
    [self.navigationController pushViewController:[RTA_VC new] animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 当前视图中有N多UIScrollView
    if (scrollView == self.CarScrView) {
        int seleCount  = scrollView.contentOffset.x / (kScreenWidth);
        [self.pageController setCurrentPage:seleCount];
    }
}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}
@end
