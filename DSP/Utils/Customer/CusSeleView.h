/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>
typedef void(^chouseBlock) (void);


@interface CusSeleView : UIView
@property (weak, nonatomic) IBOutlet UIView *cancelBackView;

@property (weak, nonatomic) IBOutlet UILabel *tipTitle;

@property (weak, nonatomic) IBOutlet UIButton *chouseOneBut;
@property (weak, nonatomic) IBOutlet UIButton *chouseTwoBut;



@property(nonatomic,copy)chouseBlock chouseOneBlock;
@property(nonatomic,copy)chouseBlock chouseTwoBlock;

- (id)init;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showInView:(UIView*) view  withFrame:(CGRect)rect;
- (void)showInView:(UIView*)view
   withCancelClick:(chouseBlock)chouseOneBlock
  withConfirmClick:(chouseBlock)chouseTwoBlock
         withTitle:(NSString*)contentStr;
- (void)showInView:(UIView*)view withOneTitle:(NSString*)oneStr TwoTitle:(NSString *)twoStr withTipTitle:(NSString*)tipTitle withCancelClick:(chouseBlock)chouseOneBlock
  withConfirmClick:(chouseBlock)chouseTwoBlock;
@end
