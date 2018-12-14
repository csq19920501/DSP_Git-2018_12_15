//
//  HomeViewController.m
//  DSP
//
//  Created by hk on 2018/6/12.
//  Copyright © 2018年 hk. All rights reserved.
#import "Output_SetingVC.h"
#import "PreferencesVC.h"
#import "ManagerPresetVC.h"
#import "RTA_VC.h"
#import "EQ_VC.h"
#import "CHCrossover_VC.h"
#import "CHDelay_VC.h"
#import "inputLevelVC.h"
#import "InputSettingSpdifVC.h"
#import "ChLevel_VC.h"

#import "HomeViewController.h"

#import "CustomeCsqButton.h"
#import "photoTableviewC.h"
#import "CYTabBarController.h"
#import "CSQCircleView.h"
#import "RootNavigationController.h"

#import "SocketManager.h"
#define hiddenAlpha  0.3
#define diplayAlpha  1.0
@interface HomeViewController ()<UIGestureRecognizerDelegate>
{
    CGFloat MainStartAngle;
    CGFloat MainStopAngle;
    CGFloat MainCurrentAngle;
}
@property (weak, nonatomic) IBOutlet UIButton *modeBackButton;
@property (weak, nonatomic) IBOutlet UIButton *tuneBackButton;
@property (weak, nonatomic) IBOutlet UIButton *connectBackButton;
@property (weak, nonatomic) IBOutlet UIButton *stttupBackButton;

/*
 使用了封装控件，原来的不用了
 */

@property (weak, nonatomic) IBOutlet CSQCircleView *MainLevelView;
@property (weak, nonatomic) IBOutlet CSQCircleView *SUBLevelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet UIButton *MuneButtom;


@property (weak, nonatomic) IBOutlet UIImageView *SUBLevelBackImageV;//隐藏
@property (weak, nonatomic) IBOutlet UIImageView *SUBLevelRotateV; //隐藏
@property (weak, nonatomic) IBOutlet UILabel *SUBLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@property (weak, nonatomic) IBOutlet UIImageView *MainBackImageV;//隐藏
@property (weak, nonatomic) IBOutlet UIImageView *MainRotateImageV;//隐藏
@property (weak, nonatomic) IBOutlet UILabel *MainLevelLabel;

@end

@implementation HomeViewController

- (IBAction)homeButton:(id)sender {
}
- (IBAction)nextButton:(id)sender {
}

- (IBAction)MuneClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    DeviceToolShare.mune = but.selected;
    [SocketManagerShare sendTipWithType:MainMute withCount:0];
}
-(void)LinkSuccessNotificaion{
    DISPATCH_ON_MAIN_THREAD(^{
        [UIUtil showProgressHUD:nil inView:[AppData theTopView]];
    })
}
-(void)mainRefreshSucces{
   
    [self.MainLevelView setSendData:^(){
        
    }];
//    [self.SUBLevelView setSendData:^(){
//
//    }];
    
    DISPATCH_ON_MAIN_THREAD(^{
       [self refreshMainAndSUBlevel];
        [UIUtil hideProgressHUD];
        self.MuneButtom.selected = DeviceToolShare.mune;
    })
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mainRefreshSucces) name:MainRefreshNotificaion object:nil];
    
    
    KAddObserver(mainRefreshSucces,MainRefreshNotificaion,nil)
    KAddObserver(LinkSuccessNotificaion,LinkSuccessNotificaion,nil)
    
    [self setBottomButtonAndCSQProgress];
    
    if (isIphoneX) {
        self.VCBottomConstraint.constant = 35.;
        self.naviBarHeight.constant = kTopHeight;
    }
    [SocketManagerShare setupSocket];
    
    
    
//    DeviceToolShare.eqF_isConnect = YES;
//    DeviceToolShare.eqR_isConnect = YES;
//    DeviceToolShare.crossoverF_isConnect = YES;
//    DeviceToolShare.crossoverR_isConnect = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    SDLog(@"viewWillAppear = %@",[SocketManager getBinaryByDecimal:7])

    if (!DeviceToolShare.ExternalRemodeControl) {
        self.subTitleLabel.alpha = diplayAlpha;
        self.SUBLevelLabel.alpha = diplayAlpha;
        self.SUBLevelView.alpha = diplayAlpha;
        self.SUBLevelView.userInteractionEnabled = YES;
//        [self.SUBLevelView setLevel:DeviceToolShare.SUBLevel];
    }else{
        self.subTitleLabel.alpha = hiddenAlpha;
        self.SUBLevelLabel.alpha = hiddenAlpha;
        self.SUBLevelView.alpha = hiddenAlpha;
        self.SUBLevelView.userInteractionEnabled = NO;
        self.SUBLevelView.userInteractionEnabled = NO;
//        [self.SUBLevelView setLevel:0];

    }
     self.MuneButtom.selected = DeviceToolShare.mune;
    
    [self.SUBLevelView setSendData:^(){
    }];
    if (DeviceToolShare.SUBLevel != self.SUBLevelView.currentLevel) {
        [self.SUBLevelView setLevel:DeviceToolShare.SUBLevel];
    }

    CSQ_DISPATCH_AFTER(0.5, ^{
        [self.SUBLevelView setSendData:^(){
            [SocketManagerShare sendTipWithType:SUBSoundLevle withCount:0];
            for (hornDataModel *hornModel in DeviceToolShare.hornDataArray) {
                if (hornModel.outCh == 8) {
                    hornModel.CHLevelFloat = DeviceToolShare.SUBLevel;
                    //Nslog(@"%f = slider",hornModel.CHLevelFloat);
                }
            }
        }];
    })
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(void)setBottomButtonAndCSQProgress{
    DISPATCH_ON_MAIN_THREAD((^{
        NSArray *buttomArray = @[self.modeBackButton,_tuneBackButton,_connectBackButton,_stttupBackButton];
        NSArray *imageArray = @[@"mode_normat",@"tuen_normat",@"connect_normat",@"setup_normat"];
        NSArray *seleImageArr = @[@"mode_selected",@"tuen_selected",@"connect_selected",@"setup_selected"];
        NSArray *titleArray = @[@"MODE",@"TUNING",@"CONNECT",@"SETUP"];
        for (UIButton *backButton in buttomArray) {
            CGRect backButtonRect = backButton.bounds;
            int i = (int)[buttomArray indexOfObject:backButton];
            MPWeakSelf(self)
            CustomeCsqButton *csqButtom  = [[CustomeCsqButton alloc]initWithFrame:backButtonRect normalImageStr:imageArray[i] seleImageStr:seleImageArr[i] higligthImageStr:seleImageArr[i] titleStr:titleArray[i] numberStr:nil ClickBlock:^(NSInteger number){

                            CellType clickCellType = number - 99;
                            CellType storeayCellType = number - 99;
                
//wifi未连接状态不进入其他页面
                if (!CsqDebug) {
                    if (![SocketManagerShare isWiFiEnabled]){
                        clickCellType = CONNECT;
                    }else{
                        if (![SocketManagerShare isCurrentWIFI]) {
                            clickCellType = CONNECT;
                        }else{
                            
                        }
                    }
                }
                

                            photoTableviewC * photoTableview = [[photoTableviewC alloc]initWithType:clickCellType];
                            [photoTableview showInView:[AppData theTopView]];
                            [photoTableview reloadData];
                            [photoTableview setDidClickCell:^(NSInteger indexRow,CellType cellType){
                                
                                CustomeCsqButton *clickButton = (CustomeCsqButton *)[weakself.view viewWithTag:100 + (storeayCellType - 1)];
                                clickButton.selected = NO;
                                SDLog(@"setDidClickCellBlock_cellType = %ld_index = %ld",(long)cellType,(long)indexRow);
                                switch (cellType) {
                                    case MODE:
                                        {
                                            if (indexRow >= 0) {
                                                [SocketManagerShare sendTipWithType:InputSource withCount:0];
                                            }
                                        }
                                        break;
                                    case TUNE:
                                    {
                                        if (indexRow == 0) {
                                            inputLevelVC *vc = [inputLevelVC new];
                                            if (DeviceToolShare.DspMode == ANALOG) {
                                                vc.inputType = Ana;
                                            }else{
                                                vc.inputType = Dig;
                                            }
                                            [self.navigationController pushViewController:vc animated:YES];
                                        }
                                        if (indexRow == 1) {
                                            Output_SetingVC *VC = [Output_SetingVC new];
                                            [self.navigationController pushViewController:VC animated:YES];
                                        }
                                        if (indexRow == 2) {
                                            [self gotoAdvanced];
                                        }
                                    }
                                        break;
                                    case  SETUP:{
                                        
                                        if (indexRow == 0) {
                                            ManagerPresetVC *VC = [[ManagerPresetVC alloc]init];
                                            [self.navigationController pushViewController:VC animated:YES];
                                        }if (indexRow == 2) {
                                            InputSettingSpdifVC *VC = [[InputSettingSpdifVC alloc]init];
                                            [self.navigationController pushViewController:VC animated:YES];
                                        }
                                        if (indexRow == 1) {
                                            PreferencesVC *VC = [[PreferencesVC alloc]init];
                                            [VC setClickButton:^(PreferenceButtonType preferenceType,BOOL isFirst){
                                                
                                                
                                                if (preferenceType == MaxOutput) {
                                                    if (!isFirst) {
                                                        DeviceToolShare.MaxOutputLevelAdd6 = NO;
                                                        self.MainLevelView.MainLevel = 120;
                                                        [self.MainLevelView drawProgress];
                                                        DeviceToolShare.MainLevel = DeviceToolShare.MainLevel > 120 ? 120 : DeviceToolShare.MainLevel;
                                                        [self.MainLevelView setLevel:DeviceToolShare.MainLevel];
                                                    }else{
                                                        DeviceToolShare.MaxOutputLevelAdd6 = YES;
                                                        self.MainLevelView.MainLevel = 132;
                                                        [self.MainLevelView drawProgress];
                                                        [self.MainLevelView setLevel:DeviceToolShare.MainLevel];
                                                    }
                                                }
                                                    
                                                
                                            }];
                                            [self.navigationController pushViewController:VC animated:YES];
                                        }
                                    }
                                        break;
                                    default:
                                        break;
                                }
                            }];
                
                }];
            csqButtom.tag = 100 + i;
            [backButton addSubview:csqButtom];
        }        
        [self refreshMainAndSUBlevel];
    }))
}
-(void)refreshMainAndSUBlevel{
    if (!DeviceToolShare.MaxOutputLevelAdd6) {
        self.MainLevelView.MainLevel = 120;
        [self.MainLevelView drawProgress];
        DeviceToolShare.MainLevel = DeviceToolShare.MainLevel > 120 ? 120 : DeviceToolShare.MainLevel;
    }else{
        self.MainLevelView.MainLevel = 132;
        [self.MainLevelView drawProgress];
    }
    
    [self.MainLevelView setValueChange:^(CGFloat level){
        SDLog(@"levelChange = %f",level);
        self.MainLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)level - 120)/2.0];
        DeviceToolShare.MainLevel = level;
        self.MainLevelLabel.textColor = [UIColor greenColor];
        
        //过滤掉部分值 保证发送指令不太频繁
        suiJiFaSong([SocketManagerShare sendTipWithType:MainSoundLevle withCount:maxCount];)
    }];
    [self.MainLevelView setValueChangeEnd:^(){
        self.MainLevelLabel.textColor = [UIColor whiteColor];
    }];
    [self.MainLevelView setLevel:DeviceToolShare.MainLevel];
    
    
    self.SUBLevelView.MainLevel = 120;
    [self.SUBLevelView drawProgress];
    
    [self.SUBLevelView setValueChange:^(CGFloat level){
        SDLog(@"levelChange = %f",level);
        DeviceToolShare.SUBLevel = level;
        self.SUBLevelLabel.text = [NSString stringWithFormat:@"%.1f",((int)level - 120)/2.0];
        self.SUBLevelLabel.textColor = [UIColor greenColor];
        suiJiFaSong([SocketManagerShare sendTipWithType:SUBSoundLevle withCount:maxCount];)
    }];
    [self.SUBLevelView setValueChangeEnd:^(){
        self.SUBLevelLabel.textColor = [UIColor whiteColor];
    }];
    [self.SUBLevelView setLevel:DeviceToolShare.SUBLevel];
    
    CSQ_DISPATCH_AFTER(0.5, ^{
        [self.MainLevelView setSendData:^(){
            [SocketManagerShare sendTipWithType:MainSoundLevle withCount:0];
        }];
        //转移到viewwillappear
//        [self.SUBLevelView setSendData:^(){
//            [SocketManagerShare sendTipWithType:SUBSoundLevle withCount:0];
//
//            for (hornDataModel *hornModel in DeviceToolShare.hornDataArray) {
//                if (hornModel.outCh == 8) {
//                    hornModel.CHLevelFloat = DeviceToolShare.SUBLevel;
//                }
//            }
//        }];
    })
}
-(void)gotoAdvanced{
    CYTabBarController *AdvancedTarbar = [[CYTabBarController alloc]init];
    [CYTabBarConfig shared].selectedTextColor = [UIColor greenColor];
    
    RootNavigationController *nav1 = [[RootNavigationController alloc]initWithRootViewController:[ChLevel_VC new]];
    RootNavigationController *nav2 = [[RootNavigationController alloc]initWithRootViewController:[CHDelay_VC new]];
    RootNavigationController *nav3 = [[RootNavigationController alloc]initWithRootViewController:[CHCrossover_VC new]];
    RootNavigationController *nav4 = [[RootNavigationController alloc]initWithRootViewController:[EQ_VC new]];
//    RootNavigationController *nav5 = [[RootNavigationController alloc]initWithRootViewController:[RTA_VC new]];
    
    [AdvancedTarbar addChildController:nav1 title:@"CH Level" imageName:@"ch level_normat.png" selectedImageName:@"ch level_selected.png"];
    [AdvancedTarbar addChildController:nav2 title:@"CH Delay" imageName:@"ch delay_normat.png"  selectedImageName:@"ch delay_selected.png"];
    [AdvancedTarbar addChildController:nav3 title:@"Crossover" imageName:@"crossover_normat.png"  selectedImageName:@"crossover_selected.png"];
    [AdvancedTarbar addChildController:nav4 title:@"EQ" imageName:@"eq_normat.png"  selectedImageName:@"eq_selected.png"];
//    [AdvancedTarbar addChildController:nav5 title:@"RTA" imageName:@"rtarta_normat.png"  selectedImageName:@"rta_selected.png"];
    [AdvancedTarbar addCenterController:nil bulge:YES title:@"RTA" imageName:@"rtarta_normat.png" selectedImageName:@"rta_selected.png"];
    [self.navigationController pushViewController:AdvancedTarbar animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    [self presentViewController:AdvancedTarbar animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return YES;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return UIInterfaceOrientationPortrait;
}

@end
