/*
 ============================================================================
 Name        : HotlineViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */


#import "CusSeleView.h"



@interface CusSeleView ()
{
}
@end

@implementation CusSeleView

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CusSeleView" owner:self options:nil] objectAtIndex:0];
    self.tipTitle.layer.cornerRadius = 18;
    self.tipTitle.layer.masksToBounds = YES;
    
    self.chouseOneBut.layer.cornerRadius = 18;
    self.chouseOneBut.layer.masksToBounds = YES;
    
    self.chouseTwoBut.layer.cornerRadius = 18;
    self.chouseTwoBut.layer.masksToBounds = YES;
    
    [self.chouseOneBut addTarget:self action:@selector(chouseOneCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.chouseTwoBut addTarget:self action:@selector(chouseTwoClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.cancelBackView addGestureRecognizer:tap];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    return self;
}

- (void)showInView:(UIView*) view
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
    [view addSubview:self];
}

- (void)showInView:(UIView*) view  withFrame:(CGRect)rect
{
    self.frame = rect;
    
    [view addSubview:self];
}
- (void)showInView:(UIView*)view
   withCancelClick:(chouseBlock)chouseOneBlock
  withConfirmClick:(chouseBlock)chouseTwoBlock
         withTitle:(NSString*)contentStr
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
   
    self.chouseOneBlock = chouseOneBlock;
    self.chouseTwoBlock = chouseTwoBlock;
}
- (void)showInView:(UIView*)view withOneTitle:(NSString*)oneStr TwoTitle:(NSString *)twoStr withTipTitle:(NSString*)tipTitle withCancelClick:(chouseBlock)chouseOneBlock
  withConfirmClick:(chouseBlock)chouseTwoBlock
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
    [self.chouseOneBut setTitle:oneStr forState:UIControlStateNormal];
    [self.chouseTwoBut setTitle:twoStr forState:UIControlStateNormal];
    self.tipTitle.text = tipTitle;
    self.chouseOneBlock = chouseOneBlock;
    self.chouseTwoBlock = chouseTwoBlock;
    [view addSubview:self];
}

-(void)chouseOneCLick{
    [self.chouseOneBut setBackgroundColor:[UIColor greenColor]];
    if (self.chouseOneBlock) {
        self.chouseOneBlock();
    }
    [self dismiss];
}
-(void)chouseTwoClick{
    [self.chouseTwoBut setBackgroundColor:[UIColor greenColor]];
    if (self.chouseTwoBlock) {
        self.chouseTwoBlock();
    }
    [self dismiss];
}
- (void)dismiss{
    [UIView animateWithDuration:1.0 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
