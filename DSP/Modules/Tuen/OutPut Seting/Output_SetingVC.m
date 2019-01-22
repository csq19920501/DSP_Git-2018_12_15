//
//  Output SetingVC.m
//  DSP
//
//  Created by hk on 2018/6/23.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "Output_SetingVC.h"
#import "CustomerCar.h"
#import "CustomerAlertView.h"
#import "InputSettingVC.h"
@interface Output_SetingVC ()
{
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midHeight;
@property(nonatomic,assign)CGPoint supWoCenter;
@property(nonatomic,assign)CGPoint midCenter;
@property(nonatomic,assign)CGPoint woCenter;
@property(nonatomic,assign)CGPoint twoWayCenter;
@property(nonatomic,assign)CGPoint tweeCenter;
@property(nonatomic,assign)CGPoint coaxCenter;
@property(nonatomic,strong)CustomerCar  *customerCar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *showCarBackView;
@property (weak, nonatomic) IBOutlet UIImageView *hornBackView;

@property(nonatomic,assign)BOOL isChange;
@end

@implementation Output_SetingVC
static Output_SetingVC *_instance;
//static dispatch_once_t onceToken;
+(Output_SetingVC*)shareInstance{
    if (_instance == nil) {
        _instance = [[Output_SetingVC alloc ]init];
    }
    return _instance;
}
+(void)destoryInstance{
    if (_instance != nil) {
        _instance = nil;
    }
}

- (IBAction)backClick:(id)sender {
   BOOL isNotEnd = !kArrayIsEmpty(self.customerCar.selectButtonArray);
    if (self.isChange && isNotEnd) {
        CustomerAlertView *alert = [[CustomerAlertView alloc]init];
        [alert showInView:[AppData theTopView] withCancelTitle:@"No" confirmTitle:@"Yes" withCancelClick:^{
            SDLog(@"点击了Cancel");
//            [Output_SetingVC destoryInstance];
            [self.navigationController popViewControllerAnimated:YES];
        } withConfirmClick:^{
            SDLog(@"点击了OK");
            [self changeDeviceToolHornArray];
            
//            [Output_SetingVC destoryInstance];
            [self.navigationController popViewControllerAnimated:YES];
        } withTitle:@"Save current settings or not"];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)nextClick:(id)sender {

    BOOL isEnd = !kArrayIsEmpty(self.customerCar.selectButtonArray);
    if (isEnd) {
        if (self.isChange) {
            CustomerAlertView *alert = [[CustomerAlertView alloc]init];
            [alert showInView:[AppData theTopView] withCancelTitle:@"Back" confirmTitle:@"OK" withCancelClick:^{
                SDLog(@"点击了BACK");
            } withConfirmClick:^{
                SDLog(@"点击了OK");
                [self changeDeviceToolHornArray];
                InputSettingVC *vc = [[InputSettingVC alloc]init];
                vc.selectCarArray = self.customerCar.selectButtonArray;
                [DeviceToolShare saveInfo];
                [self.navigationController pushViewController:vc animated:YES];
            } withTitle:@"Output setup complete \n Please confirm go to input seting"];
        }else{
            InputSettingVC *vc = [[InputSettingVC alloc]init];
            vc.selectCarArray = DeviceToolShare.selectHornArray;
            [DeviceToolShare saveInfo];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        CustomerAlertView *alert = [[CustomerAlertView alloc]init];
        [alert showInView:[AppData theTopView] withCancelTitle:@"Back" confirmTitle:@"OK" withCancelClick:nil
         withConfirmClick:^{
            SDLog(@"点击了OK");
        } withTitle:@" Please confirm continue output seting"];
    }
}

-(void)changeDeviceToolHornArray{
    DeviceToolShare.selectHornArray = [NSMutableArray arrayWithArray:self.customerCar.selectButtonArray];
    [DeviceToolShare.hornDataArray removeAllObjects];
    [DeviceToolShare.crossoverSeleHornDataArray removeAllObjects];
    [DeviceToolShare.eqSeleHornDataArray removeAllObjects];
    
    
    int outCH_count = 0;
    NSMutableString *tipStr = [NSMutableString string];
    
    [tipStr appendFormat:@"00%@",SendSpeakerAssignAdr];
    NSString *Ch1L = @"00"; //area
    NSString *Ch1R = @"00"; //hornType
    NSString *Ch2L = @"00";
    NSString *Ch2R = @"00";
    NSString *Ch3L = @"00";
    NSString *Ch3R = @"00";
    NSString *Ch4L = @"00";
    NSString *Ch4R = @"00";
    NSString *Ch5L = @"00";
    NSString *Ch5R = @"00";
    NSString *Ch6L = @"00";
    NSString *Ch6R = @"00";
    NSString *Ch7L = @"00";
    NSString *Ch7R = @"00";
    NSString *Ch8L = @"00";
    NSString *Ch8R = @"00";
    
    for(int i = 0; i < DeviceToolShare.selectHornArray.count; i++) {
        hornDataModel *model = [[hornDataModel alloc]init];
        model.hornType = DeviceToolShare.selectHornArray[i];
        
        if ([model.hornType isEqualToString:@"201"]) {
            model.outCh = CH3;
            Ch3L = @"02";
            Ch3R = @"01";
        }else if ([model.hornType isEqualToString:@"191"]) {
            model.outCh = CH3;
            Ch3L = @"04";
            Ch3R = @"01";
        }else if ([model.hornType isEqualToString:@"241"]) {
            model.outCh = CH4;
            Ch4L = @"05";
            Ch4R = @"01";
        }else if ([model.hornType isEqualToString:@"251"]) {
            model.outCh = CH4;
            Ch4L = @"03";
            Ch4R = @"01";
        }else if ([model.hornType isEqualToString:@"208"] || [model.hornType isEqualToString:@"214"]) {
            model.outCh = CH8;
            Ch8L = @"06";
            Ch8R = @"06";
        }else if ([model.hornType isEqualToString:@"209"]
                  || [model.hornType isEqualToString:@"210"]
                  || [model.hornType isEqualToString:@"211"]
                  || [model.hornType isEqualToString:@"212"]
                  || [model.hornType isEqualToString:@"213"]) {
            model.outCh = CH7;
            if ([model.hornType isEqualToString:@"209"]) {
                Ch7L = @"01";
                Ch7R = @"04";
            }else if ([model.hornType isEqualToString:@"210"]) {
                Ch7L = @"01";
                Ch7R = @"05";
            }else if ([model.hornType isEqualToString:@"211"]) {
                Ch7L = @"01";
                Ch7R = @"03";
            }else if ([model.hornType isEqualToString:@"212"]) {
                Ch7L = @"01";
                Ch7R = @"02";
            }else if ([model.hornType isEqualToString:@"213"]) {
                Ch7L = @"06";
                Ch7R = @"06";
            }
        }else{
            if (outCH_count == 0) {
                model.outCh = CH1;
                if ([model.hornType isEqualToString:@"202"]) {
                    Ch1L = @"02";
                    Ch1R = @"02";
                }else if ([model.hornType isEqualToString:@"252"]) {
                    Ch1L = @"03";
                    Ch1R = @"02";
                }else if ([model.hornType isEqualToString:@"203"]) {
                    Ch1L = @"02";
                    Ch1R = @"03";
                }else if ([model.hornType isEqualToString:@"253"]) {
                    Ch1L = @"03";
                    Ch1R = @"03";
                }else if ([model.hornType isEqualToString:@"204"]) {
                    Ch1L = @"02";
                    Ch1R = @"04";
                }else if ([model.hornType isEqualToString:@"254"]) {
                    Ch1L = @"03";
                    Ch1R = @"04";
                }else if ([model.hornType isEqualToString:@"205"]) {
                    Ch1L = @"02";
                    Ch1R = @"05";
                }else if ([model.hornType isEqualToString:@"255"]) {
                    Ch1L = @"03";
                    Ch1R = @"05";
                }else if ([model.hornType isEqualToString:@"206"]) {
                    Ch1L = @"04";
                    Ch1R = @"05";
                }else if ([model.hornType isEqualToString:@"191"]) {
                    Ch1L = @"04";
                    Ch1R = @"01";
                }
                else if ([model.hornType isEqualToString:@"192"]) {
                    Ch1L = @"04";
                    Ch1R = @"02";
                }
                else if ([model.hornType isEqualToString:@"193"]) {
                    Ch1L = @"04";
                    Ch1R = @"03";
                }else if ([model.hornType isEqualToString:@"241"]) {
                    Ch1L = @"05";
                    Ch1R = @"01";
                }
                else if ([model.hornType isEqualToString:@"242"]) {
                    Ch1L = @"05";
                    Ch1R = @"02";
                }
                else if ([model.hornType isEqualToString:@"243"]) {
                    Ch1L = @"05";
                    Ch1R = @"03";
                }
                else if ([model.hornType isEqualToString:@"256"]) {
                    Ch1L = @"05";
                    Ch1R = @"05";
                }else if ([model.hornType isEqualToString:@"207"]) {
                    Ch1L = @"04";
                    Ch1R = @"04";
                }else if ([model.hornType isEqualToString:@"257"]) {
                    Ch1L = @"05";
                    Ch1R = @"04";
                }
                
            }else if (outCH_count == 1) {
                model.outCh = CH2;
                if ([model.hornType isEqualToString:@"202"]) {
                    Ch2L = @"02";
                    Ch2R = @"02";
                }else if ([model.hornType isEqualToString:@"252"]) {
                    Ch2L = @"03";
                    Ch2R = @"02";
                }else if ([model.hornType isEqualToString:@"203"]) {
                    Ch2L = @"02";
                    Ch2R = @"03";
                }else if ([model.hornType isEqualToString:@"253"]) {
                    Ch2L = @"03";
                    Ch2R = @"03";
                }else if ([model.hornType isEqualToString:@"204"]) {
                    Ch2L = @"02";
                    Ch2R = @"04";
                }else if ([model.hornType isEqualToString:@"254"]) {
                    Ch2L = @"03";
                    Ch2R = @"04";
                }else if ([model.hornType isEqualToString:@"205"]) {
                    Ch2L = @"02";
                    Ch2R = @"05";
                }else if ([model.hornType isEqualToString:@"255"]) {
                    Ch2L = @"03";
                    Ch2R = @"05";
                }else if ([model.hornType isEqualToString:@"206"]) {
                    Ch2L = @"04";
                    Ch2R = @"05";
                }else if ([model.hornType isEqualToString:@"256"]) {
                    Ch2L = @"05";
                    Ch2R = @"05";
                }else if ([model.hornType isEqualToString:@"207"]) {
                    Ch2L = @"04";
                    Ch2R = @"04";
                }else if ([model.hornType isEqualToString:@"257"]) {
                    Ch2L = @"05";
                    Ch2R = @"04";
                }else if ([model.hornType isEqualToString:@"191"]) {
                    Ch2L = @"04";
                    Ch2R = @"01";
                }
                else if ([model.hornType isEqualToString:@"192"]) {
                    Ch2L = @"04";
                    Ch2R = @"02";
                }
                else if ([model.hornType isEqualToString:@"193"]) {
                    Ch2L = @"04";
                    Ch2R = @"03";
                }else if ([model.hornType isEqualToString:@"241"]) {
                    Ch2L = @"05";
                    Ch2R = @"01";
                }
                else if ([model.hornType isEqualToString:@"242"]) {
                    Ch2L = @"05";
                    Ch2R = @"02";
                }
                else if ([model.hornType isEqualToString:@"243"]) {
                    Ch2L = @"05";
                    Ch2R = @"03";
                }
            }else if (outCH_count == 2) {
                model.outCh = CH5;
                if ([model.hornType isEqualToString:@"202"]) {
                    Ch5L = @"02";
                    Ch5R = @"02";
                }else if ([model.hornType isEqualToString:@"252"]) {
                    Ch5L = @"03";
                    Ch5R = @"02";
                }else if ([model.hornType isEqualToString:@"203"]) {
                    Ch5L = @"02";
                    Ch5R = @"03";
                }else if ([model.hornType isEqualToString:@"253"]) {
                    Ch5L = @"03";
                    Ch5R = @"03";
                }else if ([model.hornType isEqualToString:@"204"]) {
                    Ch5L = @"02";
                    Ch5R = @"04";
                }else if ([model.hornType isEqualToString:@"254"]) {
                    Ch5L = @"03";
                    Ch5R = @"04";
                }else if ([model.hornType isEqualToString:@"205"]) {
                    Ch5L = @"02";
                    Ch5R = @"05";
                }else if ([model.hornType isEqualToString:@"255"]) {
                    Ch5L = @"03";
                    Ch5R = @"05";
                }else if ([model.hornType isEqualToString:@"206"]) {
                    Ch5L = @"04";
                    Ch5R = @"05";
                }else if ([model.hornType isEqualToString:@"256"]) {
                    Ch2L = @"05";
                    Ch2R = @"05";
                }else if ([model.hornType isEqualToString:@"207"]) {
                    Ch5L = @"04";
                    Ch5R = @"04";
                }else if ([model.hornType isEqualToString:@"257"]) {
                    Ch5L = @"05";
                    Ch5R = @"04";
                }else if ([model.hornType isEqualToString:@"191"]) {
                    Ch5L = @"04";
                    Ch5R = @"01";
                }
                else if ([model.hornType isEqualToString:@"192"]) {
                    Ch5L = @"04";
                    Ch5R = @"02";
                }
                else if ([model.hornType isEqualToString:@"193"]) {
                    Ch5L = @"04";
                    Ch5R = @"03";
                }else if ([model.hornType isEqualToString:@"241"]) {
                    Ch5L = @"05";
                    Ch5R = @"01";
                }
                else if ([model.hornType isEqualToString:@"242"]) {
                    Ch5L = @"05";
                    Ch5R = @"02";
                }
                else if ([model.hornType isEqualToString:@"243"]) {
                    Ch5L = @"05";
                    Ch5R = @"03";
                }
            }else if (outCH_count == 3) {
                model.outCh = CH6;
                if ([model.hornType isEqualToString:@"202"]) {
                    Ch6L = @"02";
                    Ch6R = @"02";
                }else if ([model.hornType isEqualToString:@"252"]) {
                    Ch6L = @"03";
                    Ch6R = @"02";
                }else if ([model.hornType isEqualToString:@"203"]) {
                    Ch6L = @"02";
                    Ch6R = @"03";
                }else if ([model.hornType isEqualToString:@"253"]) {
                    Ch6L = @"03";
                    Ch6R = @"03";
                }else if ([model.hornType isEqualToString:@"204"]) {
                    Ch6L = @"02";
                    Ch6R = @"04";
                }else if ([model.hornType isEqualToString:@"254"]) {
                    Ch6L = @"03";
                    Ch6R = @"04";
                }else if ([model.hornType isEqualToString:@"205"]) {
                    Ch6L = @"02";
                    Ch6R = @"05";
                }else if ([model.hornType isEqualToString:@"255"]) {
                    Ch6L = @"03";
                    Ch6R = @"05";
                }else if ([model.hornType isEqualToString:@"206"]) {
                    Ch6L = @"04";
                    Ch6R = @"05";
                }else if ([model.hornType isEqualToString:@"256"]) {
                    Ch6L = @"05";
                    Ch6R = @"05";
                }else if ([model.hornType isEqualToString:@"207"]) {
                    Ch6L = @"04";
                    Ch6R = @"04";
                }else if ([model.hornType isEqualToString:@"257"]) {
                    Ch6L = @"05";
                    Ch6R = @"04";
                }else if ([model.hornType isEqualToString:@"191"]) {
                    Ch6L = @"04";
                    Ch6R = @"01";
                }
                else if ([model.hornType isEqualToString:@"192"]) {
                    Ch6L = @"04";
                    Ch6R = @"02";
                }
                else if ([model.hornType isEqualToString:@"193"]) {
                    Ch6L = @"04";
                    Ch6R = @"03";
                }else if ([model.hornType isEqualToString:@"241"]) {
                    Ch6L = @"05";
                    Ch6R = @"01";
                }
                else if ([model.hornType isEqualToString:@"242"]) {
                    Ch6L = @"05";
                    Ch6R = @"02";
                }
                else if ([model.hornType isEqualToString:@"243"]) {
                    Ch6L = @"05";
                    Ch6R = @"03";
                }
            }
            outCH_count++;
        }
        [DeviceToolShare.hornDataArray addObject:model];
    }
    
    [tipStr appendFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",Ch1L,Ch1R,Ch2L,Ch2R,Ch3L,Ch3R,Ch4L,Ch4R,Ch5L,Ch5R,Ch6L,Ch6R,Ch7L,Ch7R,Ch8L,Ch8R];
    [SocketManagerShare seneTipWithType:SendSpeakerAssign WithStr:tipStr Count:0];
}

-(void)doMoveAction:(UIPanGestureRecognizer *)recognizer{
    // Figure out where the user is trying to drag the view.
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                    recognizer.view.center.y + translation.y);
    //    限制屏幕范围：
    newCenter.y = MAX(recognizer.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.view.frame.size.height - recognizer.view.frame.size.height/2, newCenter.y);
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.view.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    
    CGFloat width = self.showCarBackView.frame.size.width;
    CGFloat height = self.showCarBackView.frame.size.height;
    
    CGFloat originX = self.showCarBackView.frame.origin.x  + width/22;
    CGFloat originY = self.showCarBackView.frame.origin.y + (height - width/1.1)*2/3;
    
    width = width/1.1;
    height = height;
    
    CGFloat moveX_L = 0.0;
    CGFloat moveX_R = 0.0;
    CGFloat moveY_Top = 0.0;
    CGFloat moveY_Bottom = 0.0;
    switch (self.customerCar.selectArea) {
        case selectAreaFL:
            {
                moveX_L = originX;
                moveX_R = originX + width/2;
                moveY_Top = originY;
                moveY_Bottom = originY + height/2;
                if (self.customerCar.connectF) {
                    moveX_R = originX + width;
                }
            }
            break;
        case selectAreaFR:
        {
            moveX_L = originX + width/2;
            moveX_R = originX + width;
            moveY_Top = originY;
            moveY_Bottom = originY + height/2;
            if (self.customerCar.connectF) {
                moveX_L = originX;
            }
        }
            break;
        case selectAreaRR:
        {
            moveX_L = originX + width/2;
            moveX_R = originX + width;
            moveY_Top = originY + height*2/5;
            moveY_Bottom = originY + height;
            if (self.customerCar.connectR) {
                moveX_L = originX;
            }
        }
            break;
        case selectAreaRL:
        {
            moveX_L = originX ;
            moveX_R = originX + width/2;
            moveY_Top = originY + height*2/5;
            moveY_Bottom = originY + height;
            if (self.customerCar.connectF) {
                moveX_R = originX + width;
            }
        }
            break;
        case selectSoo:
        {
            moveX_L = originX + width/4 ;
            moveX_R = originX + width*3/4;
            moveY_Top = originY + height*3/5;
            moveY_Bottom = originY + height;
        }
            break;
        case selectCenter:
        {
            moveX_L = originX + width/4 ;
            moveX_R = originX + width*3/4;
            moveY_Top = originY ;
            moveY_Bottom = originY + height/4;
        }
            break;
        default:
            break;
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
     
        if (recognizer.view.center.x >= moveX_L
            && recognizer.view.center.x <= moveX_R
            && recognizer.view.center.y >= moveY_Top
            && recognizer.view.center.y <= moveY_Bottom
            ) {
            SDLog(@"移动到目标区域");
            if ([recognizer.view isEqual:self.supWoImage]) {
                [self.customerCar addButtonTag:subwoofer];
                
            }else if ([recognizer.view isEqual:self.woImage]) {
                [self.customerCar addButtonTag:woofer];
             }
            else if ([recognizer.view isEqual:self.midImage]) {
                [self.customerCar addButtonTag:midRange];
            }
            else if ([recognizer.view isEqual:self.TweeImage]) {
                [self.customerCar addButtonTag:tweeter];
            }
            else if ([recognizer.view isEqual:self.twoWayImage]) {
                [self.customerCar addButtonTag:twoWay];
            }
            else if ([recognizer.view isEqual:self.coaxImage]) {
                [self.customerCar addButtonTag:coax];
            }
            self.isChange = YES;
        }else{
            SDLog(@"移动到目标区域之外");
        }
        if ([recognizer.view isEqual:self.supWoImage]) {
            recognizer.view.center = _supWoCenter;
        }else if ([recognizer.view isEqual:self.woImage]) {
            recognizer.view.center = _woCenter;
        }
        else if ([recognizer.view isEqual:self.midImage]) {
            recognizer.view.center = _midCenter;
        }
        else if ([recognizer.view isEqual:self.TweeImage]) {
            recognizer.view.center = _tweeCenter;
        }
        else if ([recognizer.view isEqual:self.twoWayImage]) {
            recognizer.view.center = _twoWayCenter;
        }
        else if ([recognizer.view isEqual:self.coaxImage]) {
            recognizer.view.center = _coaxCenter;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (isIphoneX) {
        self.naviBarHeight.constant = kTopHeight;
        self.VCBottomConstraint.constant = 35.;
        self.midHeight.constant = 70;
    }
    
    
    
    
    MPWeakSelf(self)
    DISPATCH_ON_MAIN_THREAD((^{
        weakself.hornBackView.layer.borderColor = [UIColor whiteColor].CGColor;
        weakself.hornBackView.layer.borderWidth = 0.7;
        
        NSArray *imageArray = @[weakself.supWoImage,weakself.woImage,weakself.midImage,weakself.TweeImage,weakself.twoWayImage,weakself.coaxImage];
        for (NSObject *ob in imageArray) {
            UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
            action:@selector(doMoveAction:)];
            [(UIImageView *)ob addGestureRecognizer:panGestureRecognizer];
        }
        weakself.supWoCenter =  weakself.supWoImage.center;
        weakself.woCenter =  weakself.woImage.center;
        weakself.midCenter =  weakself.midImage.center;
        weakself.tweeCenter =  weakself.TweeImage.center;
        weakself.twoWayCenter =  weakself.twoWayImage.center;
        weakself.coaxCenter =  weakself.coaxImage.center;
        
        self.customerCar = [[CustomerCar alloc]init];
        [self.customerCar setValueChange:^{
            weakself.isChange = YES;
        }];
        
        [self.customerCar setSetUseHornWithArray:^(NSArray *seleArray, SelectArea seleType) {
            if (seleType == selectAreaFL || seleType == selectAreaFR) {
                int F_R_count= 0;
                for (NSString *tagStr in seleArray) {
                    if ([tagStr isEqualToString:@"201"]
                        || [tagStr isEqualToString:@"202"]
                        || [tagStr isEqualToString:@"203"]
                        || [tagStr isEqualToString:@"204"]
                        || [tagStr isEqualToString:@"205"]
                        || [tagStr isEqualToString:@"206"]
                        || [tagStr isEqualToString:@"207"]
                        || [tagStr isEqualToString:@"191"]
                        || [tagStr isEqualToString:@"192"]
                        || [tagStr isEqualToString:@"193"]
                        ) {
                        F_R_count ++;
                    }
                }
                BOOL isFindWoo = NO;
                for (NSString *tagStr in seleArray) {
                    if ([tagStr isEqualToString:@"201"]
                        || [tagStr isEqualToString:@"191"]
                        
                        ) {
                        isFindWoo = YES;
                    }
                }
                
                if (F_R_count >= 3) {
                    if (weakself.customerCar.setUseImageType) {
                        weakself.customerCar.setUseImageType(imageNone);
                    }
                }else if (F_R_count == 2 && !isFindWoo){
                    weakself.customerCar.setUseImageType(imageNone);
                    weakself.woImage.userInteractionEnabled =  YES;
                    weakself.woImage.highlighted  = YES;
                }
                else{
                    weakself.woImage.userInteractionEnabled =  YES;
                    weakself.woImage.highlighted  = YES;
                    weakself.supWoImage.userInteractionEnabled =  NO;
                    weakself.supWoImage.highlighted  = NO;
                    weakself.midImage.userInteractionEnabled =  YES;
                    weakself.midImage.highlighted  = YES;
                    weakself.TweeImage.userInteractionEnabled =  YES;
                    weakself.TweeImage.highlighted  = YES;
                    weakself.twoWayImage.userInteractionEnabled =  YES;
                    weakself.twoWayImage.highlighted  = YES;
                    weakself.coaxImage.userInteractionEnabled =  YES;
                    weakself.coaxImage.highlighted  = YES;
                    
                    for (NSString *tagStr in seleArray) {
                        switch (tagStr.integerValue) {
                            case 201:
                                case 191:
                                {
                                    weakself.woImage.userInteractionEnabled =  NO;
                                    weakself.woImage.highlighted  = NO;
                                }
                                break;
                            case 202:
                            {
                                weakself.midImage.userInteractionEnabled =  NO;
                                weakself.midImage.highlighted  = NO;
                            }
                                break;
                            case 203:
                            {
                                weakself.TweeImage.userInteractionEnabled =  NO;
                                weakself.TweeImage.highlighted  = NO;
                            }
                                break;
                            case 204:
                            {
                                weakself.coaxImage.userInteractionEnabled =  NO;
                                weakself.coaxImage.highlighted  = NO;
                            }
                                break;
                            case 205:
                            {
                                weakself.twoWayImage.userInteractionEnabled =  NO;
                                weakself.twoWayImage.highlighted  = NO;
                            }
                                break;
                            default:
                                break;
                        }
                    }
                }
                
            }
            if (seleType == selectAreaRL || seleType == selectAreaRR) {
                int F_R_count= 0;
                for (NSString *tagStr in seleArray) {
                    if ([tagStr isEqualToString:@"201"]
                        || [tagStr isEqualToString:@"202"]
                        || [tagStr isEqualToString:@"203"]
                        || [tagStr isEqualToString:@"204"]
                        || [tagStr isEqualToString:@"205"]
                        || [tagStr isEqualToString:@"206"]
                        || [tagStr isEqualToString:@"207"]
                        || [tagStr isEqualToString:@"191"]
                        || [tagStr isEqualToString:@"192"]
                        || [tagStr isEqualToString:@"193"]
                        ) {
                        F_R_count ++;
                    }
                }
                BOOL isFindWoo = NO;
                for (NSString *tagStr in seleArray) {
                    if ([tagStr isEqualToString:@"201"]
                        || [tagStr isEqualToString:@"191"]
                        
                        ) {
                        isFindWoo = YES;
                    }
                }
                if (F_R_count >= 3) {
                    if (weakself.customerCar.setUseImageType) {
                        weakself.customerCar.setUseImageType(imageNone);
                    }
                }else if (F_R_count == 2 && !isFindWoo){
                    weakself.customerCar.setUseImageType(imageNone);
                    weakself.woImage.userInteractionEnabled =  YES;
                    weakself.woImage.highlighted  = YES;
                }
                else{
                    weakself.woImage.userInteractionEnabled =  YES;
                    weakself.woImage.highlighted  = YES;
                    weakself.supWoImage.userInteractionEnabled =  NO;
                    weakself.supWoImage.highlighted  = NO;
                    weakself.midImage.userInteractionEnabled =  YES;
                    weakself.midImage.highlighted  = YES;
                    weakself.TweeImage.userInteractionEnabled =  YES;
                    weakself.TweeImage.highlighted  = YES;
                    weakself.twoWayImage.userInteractionEnabled =  YES;
                    weakself.twoWayImage.highlighted  = YES;
                    weakself.coaxImage.userInteractionEnabled =  YES;
                    weakself.coaxImage.highlighted  = YES;
                    
                    for (NSString *tagStr in seleArray) {
                        switch (tagStr.integerValue) {
                            case 191:
                                case 201:
                            {
                                weakself.woImage.userInteractionEnabled =  NO;
                                weakself.woImage.highlighted  = NO;
                            }
                                break;
                            case 192:
                            {
                                weakself.midImage.userInteractionEnabled =  NO;
                                weakself.midImage.highlighted  = NO;
                            }
                                break;
                            case 193:
                            {
                                weakself.TweeImage.userInteractionEnabled =  NO;
                                weakself.TweeImage.highlighted  = NO;
                            }
                                break;
                            case 207:
                            {
                                weakself.coaxImage.userInteractionEnabled =  NO;
                                weakself.coaxImage.highlighted  = NO;
                            }
                                break;
                            case 206:
                            {
                                weakself.twoWayImage.userInteractionEnabled =  NO;
                                weakself.twoWayImage.highlighted  = NO;
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
                
            }
            if (seleType == selectCenter ) {
                int sub_count = 0;
                for (NSString *tagStr in seleArray) {
                    if ([tagStr isEqualToString:@"208"]
                        || [tagStr isEqualToString:@"213"]
                        || [tagStr isEqualToString:@"214"]
                        ) {
                        sub_count ++;
                    }
                }
                
                int F_R_count= 0;
                for (NSString *tagStr in seleArray) {
                    if ([tagStr isEqualToString:@"209"]
                        || [tagStr isEqualToString:@"210"]
                        || [tagStr isEqualToString:@"211"]
                        || [tagStr isEqualToString:@"212"]
                        
                        ) {
                        F_R_count ++;
                    }
                }
                if (sub_count != 2) {
                    if (F_R_count >= 1) {
                        if (weakself.customerCar.setUseImageType) {
                            weakself.customerCar.setUseImageType(imageNone);
                        }
                    }else{
                        weakself.woImage.userInteractionEnabled =  NO;
                        weakself.woImage.highlighted  = NO;
                        weakself.supWoImage.userInteractionEnabled =  NO;
                        weakself.supWoImage.highlighted  = NO;
                        weakself.midImage.userInteractionEnabled =  YES;
                        weakself.midImage.highlighted  = YES;
                        weakself.TweeImage.userInteractionEnabled =  YES;
                        weakself.TweeImage.highlighted  = YES;
                        weakself.twoWayImage.userInteractionEnabled =  YES;
                        weakself.twoWayImage.highlighted  = YES;
                        weakself.coaxImage.userInteractionEnabled =  YES;
                        weakself.coaxImage.highlighted  = YES;
                        
                    }
                }else{
                    if (weakself.customerCar.setUseImageType) {
                        weakself.customerCar.setUseImageType(imageNone);
                    }
                }
                
                
            }
            if (seleType == selectSoo ) {
                int F_R_count= 0;
                int Center_count = 0;
                for (NSString *tagStr in seleArray) {
                    if ([tagStr isEqualToString:@"209"]
                        || [tagStr isEqualToString:@"210"]
                        || [tagStr isEqualToString:@"211"]
                        || [tagStr isEqualToString:@"212"]
                        ) {
                        Center_count ++;
                    }
                }
                for (NSString *tagStr in seleArray) {   
                    if ([tagStr isEqualToString:@"208"]
                        || [tagStr isEqualToString:@"213"]
                        || [tagStr isEqualToString:@"214"]
                        ) {
                        F_R_count ++;
                    }
                }
                if (Center_count >= 1) {
                    if (F_R_count >= 1) {
                        if (weakself.customerCar.setUseImageType) {
                            weakself.customerCar.setUseImageType(imageNone);
                        }
                    }else{
                        weakself.woImage.userInteractionEnabled =  NO;
                        weakself.woImage.highlighted  = NO;
                        weakself.supWoImage.userInteractionEnabled =  YES;
                        weakself.supWoImage.highlighted  = YES;
                        weakself.midImage.userInteractionEnabled =  NO;
                        weakself.midImage.highlighted  = NO;
                        weakself.TweeImage.userInteractionEnabled =  NO;
                        weakself.TweeImage.highlighted  = NO;
                        weakself.twoWayImage.userInteractionEnabled =  NO;
                        weakself.twoWayImage.highlighted  = NO;
                        weakself.coaxImage.userInteractionEnabled =  NO;
                        weakself.coaxImage.highlighted  = NO;
                    }
                }else{
                    if ([DeviceToolShare isBH_A180A]) {
                        if (F_R_count > 1) {
                            if (weakself.customerCar.setUseImageType) {
                                weakself.customerCar.setUseImageType(imageNone);
                            }
                        }else{
                            weakself.woImage.userInteractionEnabled =  NO;
                            weakself.woImage.highlighted  = NO;
                            weakself.supWoImage.userInteractionEnabled =  YES;
                            weakself.supWoImage.highlighted  = YES;
                            weakself.midImage.userInteractionEnabled =  NO;
                            weakself.midImage.highlighted  = NO;
                            weakself.TweeImage.userInteractionEnabled =  NO;
                            weakself.TweeImage.highlighted  = NO;
                            weakself.twoWayImage.userInteractionEnabled =  NO;
                            weakself.twoWayImage.highlighted  = NO;
                            weakself.coaxImage.userInteractionEnabled =  NO;
                            weakself.coaxImage.highlighted  = NO;
                        }
                    }else{
                        if (F_R_count >= 1) {
                            if (weakself.customerCar.setUseImageType) {
                                weakself.customerCar.setUseImageType(imageNone);
                            }
                        }else{
                            weakself.woImage.userInteractionEnabled =  NO;
                            weakself.woImage.highlighted  = NO;
                            weakself.supWoImage.userInteractionEnabled =  YES;
                            weakself.supWoImage.highlighted  = YES;
                            weakself.midImage.userInteractionEnabled =  NO;
                            weakself.midImage.highlighted  = NO;
                            weakself.TweeImage.userInteractionEnabled =  NO;
                            weakself.TweeImage.highlighted  = NO;
                            weakself.twoWayImage.userInteractionEnabled =  NO;
                            weakself.twoWayImage.highlighted  = NO;
                            weakself.coaxImage.userInteractionEnabled =  NO;
                            weakself.coaxImage.highlighted  = NO;
                        }
                    }
                    
                }
            }
        }];
        
        [self.customerCar setSetUseImageType:^(UseImageType useImageType){
            switch (useImageType) {
                case imageNone:
                case _F_WoMidTw_none:
                case _F_WoCo_none:
                case _F_Wo2w_none:
                case _R_2w_none:
                case _R_none_none:
                case _R_Co_none:
                case _Sub_Sub_none:
                case _Center_Co_none:
                case _Center_2w_none:
                    {
                        weakself.woImage.userInteractionEnabled =  NO;
                        weakself.woImage.highlighted  = NO;
                        weakself.supWoImage.userInteractionEnabled =  NO;
                        weakself.supWoImage.highlighted  = NO;
                        weakself.midImage.userInteractionEnabled =  NO;
                        weakself.midImage.highlighted  = NO;
                        weakself.TweeImage.userInteractionEnabled =  NO;
                        weakself.TweeImage.highlighted  = NO;
                        weakself.twoWayImage.userInteractionEnabled =  NO;
                        weakself.twoWayImage.highlighted  = NO;
                        weakself.coaxImage.userInteractionEnabled =  NO;
                        weakself.coaxImage.highlighted  = NO;
                    }
                    break;
                default:
                    break;
            }
        }];
        
        [self.customerCar showInView:self.showCarBackView withFrame:self.showCarBackView.bounds];
        self.customerCar.selectArea = selectAreaZero;
        [self.customerCar outPutSettingWithArr:DeviceToolShare.selectHornArray];
        [self.customerCar buttonAddPanges];
        self.customerCar.F_connectButton.enabled = NO;
        self.customerCar.R_connectButton.enabled = NO;
    }))
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
