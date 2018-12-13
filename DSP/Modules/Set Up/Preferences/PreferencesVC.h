//
//  PreferencesVC.h
//  DSP
//
//  Created by hk on 2018/6/22.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSInteger,PreferenceButtonType) {
    External = 0,
    MaxInput ,
    MaxOutput,
};
@interface PreferencesVC : RootViewController
@property(nonatomic,copy)void (^clickButton)(PreferenceButtonType preference,BOOL isFirst);
@end
