/*
 ============================================================================
 Name        : HotlineViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */
#import "Header.h"

#import "CHDelay.h"




@interface CHDelay ()<UITextFieldDelegate>
{
}


@end

@implementation CHDelay

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CHDelay" owner:self options:nil] objectAtIndex:0];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    
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

- (void)showOneTFInView:(UIView*) view{
    self.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
    
//    CGRect rect = _backView.frame;
//    rect.size.height = 150;
//    _backView.frame =  rect;
//    _textFile2.hidden = YES;
//    _textFile3.hidden = YES;
    
}

-(void)setDelayModel:(CHdelayModel *)delayModel{
    _delayModel = delayModel;
    _delayLabel.text = [NSString stringWithFormat:@"%.2fms",(int)(delayModel.delay/2) * 0.02];//delayModel.delay/100.0
    _distentLabel.text = [NSString stringWithFormat:@"%.2fm",delayModel.distance/100.0];
    
    _phaseLabel.text = delayModel.isPhase180?@"180":@"0";
    _muneImage.highlighted = delayModel.isMune;
    NSArray *labelArray = @[_zeroLabel,_oneLabel,_twoLabel,_threeLabel,_fourLabel];
    for (UILabel *label in labelArray) {
        label.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    }
    
    UILabel * lab = labelArray[(int)delayModel.arrayType];
    lab.textColor = [UIColor whiteColor];
}



- (void)dismiss{
    [self removeFromSuperview];
}
- (IBAction)openView:(id)sender {
//    UIButton *but = sender;
//    but.selected = !but.selected;
//    if (but.selected) {
//        
//    }
    NSLog(@"偷偷的执行方法");
}

- (IBAction)cancelButton:(id)sender {
    [self dismiss];
}

- (IBAction)phoneButtonClicked:(id)sender
{
    [self dismiss];
}

@end
