/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>
typedef void(^cancelClick) (void);
typedef void(^confirmClick) (void);

@interface CustomerAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *cancelBackView;

@property (weak, nonatomic) IBOutlet UIView *alertBackView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property(nonatomic,copy)cancelClick canClick;
@property(nonatomic,copy)confirmClick confirmClick;

- (id)init;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showOneTFInView:(UIView*) view;
- (void)showInView:(UIView*) view  withFrame:(CGRect)rect;
- (void)showInView:(UIView*)view withCancelTitle:(NSString*)cncelStr confirmTitle:(NSString *)confirmStr
   withCancelClick:(cancelClick)cancelClick
  withConfirmClick:(confirmClick)confirmClick
         withTitle:(NSString*)contentStr;
@end
