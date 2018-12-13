/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>
#import "CHdelayModel.h"

@interface CHDelay : UIView
@property (weak, nonatomic) IBOutlet UILabel *distentLabel;
@property (weak, nonatomic) IBOutlet UILabel *delayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *muneImage;
@property (weak, nonatomic) IBOutlet UILabel *phaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property(nonatomic,strong)CHdelayModel *delayModel;


- (id)init;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showOneTFInView:(UIView*) view;
- (void)showInView:(UIView*) view  withFrame:(CGRect)rect;
@end
