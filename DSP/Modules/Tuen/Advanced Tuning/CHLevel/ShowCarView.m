/*
 ============================================================================
 Name        : HotlineViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */
#import "Header.h"
#import "ShowCarView.h"




@interface ShowCarView ()<UITextFieldDelegate>
{
}


@end

@implementation ShowCarView
-(void)setHiddentype:(HiddenType )hiddentype{
    _hiddentype = hiddentype;
    [self setButtonEnableWithType:hiddentype];
}
-(void)setButtonEnableWithType:(HiddenType)tag{
    CGFloat hiddenAlpha = 0.3;
    CGFloat diplayAlpha = 1.0;
    if (tag == upHidden) {
        _upProgressView.alpha = hiddenAlpha;
        _upTypeLabel.alpha = hiddenAlpha;
        _upLevelLabel.alpha = hiddenAlpha;
        _upJianButton.enabled = NO;
        _upJiaButton.enabled = NO;
        _upProgressView.userInteractionEnabled = NO;
        
        _downProgressView.alpha = diplayAlpha;
        _downTypeLabel.alpha = diplayAlpha;
        _downLevelLabel.alpha = diplayAlpha;
        _downJianButton.enabled = YES;
        _downJiaButton.enabled = YES;
        _downProgressView.userInteractionEnabled = YES;
        
        _connectButton.selected = NO;
        _connectButton.enabled = NO;
    }else if (tag == downHidden){
        _upProgressView.alpha = diplayAlpha;
        _upTypeLabel.alpha = diplayAlpha;
        _upLevelLabel.alpha = diplayAlpha;
        _upJianButton.enabled = YES;
        _upJiaButton.enabled = YES;
        _upProgressView.userInteractionEnabled = YES;
        
        _downProgressView.alpha = hiddenAlpha;
        _downTypeLabel.alpha = hiddenAlpha;
        _downLevelLabel.alpha = hiddenAlpha;
        _downJianButton.enabled = NO;
        _downJiaButton.enabled = NO;
        _downProgressView.userInteractionEnabled = NO;
        
        _connectButton.selected = NO;
        _connectButton.enabled = NO;
    }else if(tag == allHidden){
        _upProgressView.alpha = hiddenAlpha;
        _upTypeLabel.alpha = hiddenAlpha;
        _upLevelLabel.alpha = hiddenAlpha;
        _upJianButton.enabled = NO;
        _upJiaButton.enabled = NO;
        _upProgressView.userInteractionEnabled = NO;
        
        _downProgressView.alpha = hiddenAlpha;
        _downTypeLabel.alpha = hiddenAlpha;
        _downLevelLabel.alpha = hiddenAlpha;
        _downJianButton.enabled = NO;
        _downJiaButton.enabled = NO;
        _downProgressView.userInteractionEnabled = NO;
        
        _connectButton.selected = NO;
        _connectButton.enabled = NO;
    }
    
}

- (IBAction)upJian:(id)sender {
    CGFloat nowLevel = self.upProgressView.currentLevel - 1;
    if (nowLevel >=  self.upProgressView.zeroLevel) {
        [self.upProgressView setLevel:nowLevel];
    }
}
- (IBAction)upJia:(id)sender {
   
    CGFloat nowLevel = self.upProgressView.currentLevel + 1;

    if (nowLevel <=  self.upProgressView.MainLevel) {
        [self.upProgressView setLevel:nowLevel];
    }
}
- (IBAction)downJIan:(id)sender {
    CGFloat nowLevel = self.downProgressView.currentLevel - 1;
    if (nowLevel >=  self.downProgressView.zeroLevel) {
        [self.downProgressView setLevel:nowLevel];
    }
}
- (IBAction)downJia:(id)sender {
    CGFloat nowLevel = self.downProgressView.currentLevel + 1;
    
    if (nowLevel <=  self.downProgressView.MainLevel) {
        [self.downProgressView setLevel:nowLevel];
    }
}
- (IBAction)connectClick:(id)sender {
    UIButton *sen = (UIButton *)sender;
    sen.selected = !sen.selected;
}

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ShowCarView" owner:self options:nil] objectAtIndex:0];
    self.hiddentype = noneHidden;
//    DISPATCH_ON_MAIN_THREAD((^{
//        [self.upProgressView setMainLevel:120];
//        [self.upProgressView drawProgress];
//        [self.upProgressView setValueChange:^(CGFloat level){
//           
//            self.upLevelLabel.text = [NSString stringWithFormat:@"%.1f",(level - 120)/2.0];
//        }];
//        
//        [self.downProgressView setMainLevel:120];
//        [self.downProgressView drawProgress];
//        [self.downProgressView setValueChange:^(CGFloat level){
//            
//            self.downLevelLabel.text = [NSString stringWithFormat:@"%.1f",(level - 120)/2.0];
//        }];
//    }))
    
    [self.upProgressView setValueChangeEnd:^(){
        self.upLevelLabel.textColor = [UIColor whiteColor];
    }];
    [self.downProgressView setValueChangeEnd:^(){
        self.downLevelLabel.textColor = [UIColor whiteColor];
    }];
    
//    [self.upProgressView setSendData:^(){
//        [SocketManagerShare sendTipWithType:SUBSoundLevle withCount:0];
//    }];
    if (FSystemVersion >= 10.0) {
        self.downTypeLabel.adjustsFontSizeToFitWidth = YES;
        self.upTypeLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    
    self.backgroundColor = [UIColor clearColor];
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

- (void)showOneTFInView:(UIView*) view{
    self.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);

    [view addSubview:self];
    
//    CGRect rect = _backView.frame;
//    rect.size.height = 150;
//    _backView.frame =  rect;
//    _textFile2.hidden = YES;
//    _textFile3.hidden = YES;
    
}
- (void)dismiss{
    [self removeFromSuperview];
}
- (IBAction)openView:(id)sender {

}

- (IBAction)cancelButton:(id)sender {
    
    [self dismiss];
}

- (IBAction)phoneButtonClicked:(id)sender
{
    [self dismiss];
}

@end
