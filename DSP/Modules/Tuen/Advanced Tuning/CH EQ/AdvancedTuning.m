//
//  AdvancedTuning.m
//  DSP
//
//  Created by hk on 2018/7/4.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "AdvancedTuning.h"
#import "CustomerCar.h"
@interface AdvancedTuning ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet UIView *showCarBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property(nonatomic,strong)CustomerCar  *customerCar;
@end

@implementation AdvancedTuning
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (isIphoneX) {
        self.naviBarHeight.constant = kTopHeight;
        self.VCBottomConstraint.constant = 35.;
    }
    MPWeakSelf(self)
    DISPATCH_ON_MAIN_THREAD((^{
        self.customerCar = [[CustomerCar alloc]init];
        [self.customerCar showInView:self.showCarBackView withFrame:self.showCarBackView.bounds];
        self.customerCar.moduleType = weakself.moduleType;
        [self.customerCar advacnedTuningViewWith:DeviceToolShare.selectHornArray];
        if ([self.goToType isEqualToString:@"EQ_VC"]) {
            [self.customerCar setHornClick:^(int tag){
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [self.customerCar setGetSeleHorn:^(NSArray* tagArray){
                if (weakself.changeSeleHorn) {
                    weakself.changeSeleHorn(tagArray);
                }
                SDLog(@"tagArray = %@",[tagArray modelDescription]);
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }
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
