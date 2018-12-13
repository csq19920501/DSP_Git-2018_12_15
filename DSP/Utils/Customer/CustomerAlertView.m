/*
 ============================================================================
 Name        : HotlineViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */
#import "Header.h"

#import "CustomerAlertView.h"



@interface CustomerAlertView ()
{
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonLeftConstrant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBackViewHeigthConstraint;

@end

@implementation CustomerAlertView

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomerAlertView" owner:self options:nil] objectAtIndex:0];
    self.alertBackView.layer.cornerRadius = 8;
    self.alertBackView.layer.masksToBounds = YES;
    [self.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton addTarget:self action:@selector(confirmCLick) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)showInView:(UIView*) view
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
}

- (void)showInView:(UIView*) view  withFrame:(CGRect)rect
{
    self.frame = rect;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
}

- (void)showInView:(UIView*)view withCancelTitle:(NSString*)cncelStr confirmTitle:(NSString *)confirmStr
       withCancelClick:(cancelClick)cancelClick
       withConfirmClick:(confirmClick)confirmClick
         withTitle:(NSString*)contentStr
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];

    [self.cancelBackView addGestureRecognizer:tap];

    
    [self.cancelButton setTitle:cncelStr forState:UIControlStateNormal];
    [self.confirmButton setTitle:confirmStr forState:UIControlStateNormal];
    self.canClick = cancelClick;
    self.confirmClick = confirmClick;
    
    
    if (cancelClick == nil) {
        self.cancelButton.hidden = YES;
        self.confirmButtonLeftConstrant.constant = -(self.confirmButton.width/2);
    }
    
    self.buttonBackViewHeigthConstraint.constant = autoHeigthFrame(contentStr,kScreenWidth - 80,17).size.height + 110;
    self.contentLabel.text = contentStr;
    
    [view addSubview:self];
}

-(void)cancelClick{
    if (self.canClick) {
        self.canClick();
    }
    [self dismiss];
}
-(void)confirmCLick{
    if (self.confirmClick) {
        self.confirmClick();
    }
    [self dismiss];
}
- (void)dismiss{
    [self removeFromSuperview];
}


@end
