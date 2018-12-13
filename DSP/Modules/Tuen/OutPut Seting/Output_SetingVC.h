//
//  Output SetingVC.h
//  DSP
//
//  Created by hk on 2018/6/23.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"

@interface Output_SetingVC : RootViewController
@property (weak, nonatomic) IBOutlet UIImageView *woImage;
@property (weak, nonatomic) IBOutlet UIImageView *supWoImage;
@property (weak, nonatomic) IBOutlet UIImageView *midImage;
@property (weak, nonatomic) IBOutlet UIImageView *TweeImage;
@property (weak, nonatomic) IBOutlet UIImageView *coaxImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoWayImage;
+(Output_SetingVC*)shareInstance;
+(void)destoryInstance;
@end
