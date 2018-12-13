/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>
#import "CSQCircleView.h"
typedef NS_ENUM(NSInteger,HiddenType) {
    noneHidden = 0,
    upHidden = 1,
    downHidden ,
    allHidden,
};
@interface ShowCarView : UIView
@property (weak, nonatomic) IBOutlet CSQCircleView *upProgressView;
@property (weak, nonatomic) IBOutlet UIButton *upJianButton;
@property (weak, nonatomic) IBOutlet UIButton *upJiaButton;
@property (weak, nonatomic) IBOutlet UILabel *upTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *upLevelLabel;


@property (weak, nonatomic) IBOutlet CSQCircleView *downProgressView;
@property (weak, nonatomic) IBOutlet UIButton *downJianButton;
@property (weak, nonatomic) IBOutlet UIButton *downJiaButton;
@property (weak, nonatomic) IBOutlet UILabel *downTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLevelLabel;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property(nonatomic,assign)HiddenType hiddentype;


-(void)setButtonEnableWithType:(HiddenType)tag;
- (id)init;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showOneTFInView:(UIView*) view;
- (void)showInView:(UIView*) view  withFrame:(CGRect)rect;
@end
