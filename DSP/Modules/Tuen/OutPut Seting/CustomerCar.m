
#import "Header.h"

#import "CustomerCar.h"
#import "DeviceTool.h"


@interface CustomerCar ()
{
}
@property(nonatomic,assign)CGPoint pointBegin;

@end

@implementation CustomerCar
-(void)setModuleType:(NSString *)moduleType{
    _moduleType = moduleType;
    if ([moduleType isEqualToString:EQmoduleType]) {
        self.F_connectButton.selected = !DeviceToolShare.eqF_isConnect;
        self.R_connectButton.selected = !DeviceToolShare.eqR_isConnect;
        self.connectF = DeviceToolShare.eqF_isConnect;
        self.connectR = DeviceToolShare.eqR_isConnect;
    }else if ([moduleType isEqualToString:CrossoverModuleType]){
        self.F_connectButton.selected = !DeviceToolShare.crossoverF_isConnect;
        self.R_connectButton.selected = !DeviceToolShare.crossoverR_isConnect;
        self.connectF = DeviceToolShare.crossoverF_isConnect;
        self.connectR = DeviceToolShare.crossoverR_isConnect;
    }
}

- (IBAction)connectCLickF:(id)sender {
    UIButton *but = (UIButton *)sender;
    if (but.tag == 3000) { //上面关联按钮
        if (!but.selected) {//断开
            but.selected = !but.selected;
            self.connectF = !but.selected;
            
            if ([self.moduleType isEqualToString:EQmoduleType]) {
                DeviceToolShare.eqF_isConnect = self.connectF;
                DeviceToolShare.eqF_connectType = INEQ_connectType_none ;
            }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                DeviceToolShare.crossoverF_isConnect = self.connectF;
                DeviceToolShare.crossoverF_connectType = INEQ_connectType_none ;
            }
            
            UIButton *leftButton = (UIButton *)[self viewWithTag:101];
            UIButton *rightButton = (UIButton *)[self viewWithTag:102];
            if (leftButton.selected && rightButton.selected) {
                if (self.selectArea == selectAreaFL) {
                    rightButton.selected = NO;
                }
                if (self.selectArea == selectAreaFR) {
                    leftButton.selected = NO;
                }
            }
        }else if(but.selected) {//连接
            
            UIButton *leftButton = (UIButton *)[self viewWithTag:101];
            UIButton *rightButton = (UIButton *)[self viewWithTag:102];
            
            if([self.moduleType isEqualToString:EQmoduleType] || [self.moduleType isEqualToString:CrossoverModuleType]){
            CusSeleView *chouseV = [[CusSeleView alloc]init];
            [chouseV showInView:[AppData theTopView] withOneTitle:@"Copy Left to Right" TwoTitle:@"Copy Right to Left" withTipTitle:@"Please select what you want?" withCancelClick:^{
                but.selected = !but.selected;
                self.connectF = !but.selected;
                
                
                if ([self.moduleType isEqualToString:EQmoduleType]) {
                    DeviceToolShare.eqF_isConnect = self.connectF  ;
                    DeviceToolShare.eqF_connectType = INEQ_connectType_top;
                }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                    DeviceToolShare.crossoverF_isConnect = self.connectF ;
                    DeviceToolShare.crossoverF_connectType = INEQ_connectType_top;
                }
                
                if (leftButton.selected || rightButton.selected) {
                    rightButton.selected = YES;
                    leftButton.selected = YES;
                }
            } withConfirmClick:^{
                but.selected = !but.selected;
                self.connectF = !but.selected;
                
                if ([self.moduleType isEqualToString:EQmoduleType]) {
                    DeviceToolShare.eqF_isConnect = self.connectF  ;
                    DeviceToolShare.eqF_connectType = INEQ_connectType_bottom;
                }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                    DeviceToolShare.crossoverF_isConnect = self.connectF ;
                    DeviceToolShare.crossoverF_connectType = INEQ_connectType_bottom;
                }
                if (leftButton.selected || rightButton.selected) {
                    rightButton.selected = YES;
                    leftButton.selected = YES;
                }
            }];
            }else{
                but.selected = !but.selected;
                self.connectF = !but.selected;
                
                if (leftButton.selected || rightButton.selected) {
                    rightButton.selected = YES;
                    leftButton.selected = YES;
                }
            }
        }
    }else if(but.tag == 3001){ //下面关联按钮
        
        if (!but.selected) {
            but.selected = !but.selected;
            self.connectR = !but.selected;
            
            if ([self.moduleType isEqualToString:EQmoduleType]) {
                DeviceToolShare.eqR_isConnect = self.connectR  ;
                DeviceToolShare.eqR_connectType = INEQ_connectType_none;
            }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                DeviceToolShare.crossoverR_isConnect = self.connectR ;
                DeviceToolShare.crossoverR_connectType = INEQ_connectType_none;
            }
            
            
            UIButton *leftButton = (UIButton *)[self viewWithTag:103];
            UIButton *rightButton = (UIButton *)[self viewWithTag:104];
            if (leftButton.selected && rightButton.selected) {
                if (leftButton.selected && rightButton.selected) {
                    if (self.selectArea == selectAreaRL) {
                        rightButton.selected = NO;
                    }
                    if (self.selectArea == selectAreaRR) {
                        leftButton.selected = NO;
                    }
                }
            }
        }else if(but.selected) {//连接
            UIButton *leftButton = (UIButton *)[self viewWithTag:103];
            UIButton *rightButton = (UIButton *)[self viewWithTag:104];
            
            if([self.moduleType isEqualToString:EQmoduleType] || [self.moduleType isEqualToString:CrossoverModuleType]){
            CusSeleView *chouseV = [[CusSeleView alloc]init];
            [chouseV showInView:[AppData theTopView] withOneTitle:@"Copy Left to Right" TwoTitle:@"Copy Right to Left" withTipTitle:@"Please select what you want?" withCancelClick:^{
                but.selected = NO;
                self.connectR = YES;
                
                if ([self.moduleType isEqualToString:EQmoduleType]) {
                    DeviceToolShare.eqR_isConnect = self.connectR  ;
                    DeviceToolShare.eqR_connectType = INEQ_connectType_top;
                }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                    DeviceToolShare.crossoverR_isConnect = self.connectR ;
                    DeviceToolShare.crossoverR_connectType = INEQ_connectType_top;
                }
                
                if (leftButton.selected || rightButton.selected) {
                    rightButton.selected = YES;
                    leftButton.selected = YES;
                }
            } withConfirmClick:^{
                but.selected = NO;
                self.connectR = YES;
                
                if ([self.moduleType isEqualToString:EQmoduleType]) {
                    DeviceToolShare.eqR_isConnect = self.connectR  ;
                    DeviceToolShare.eqR_connectType = INEQ_connectType_bottom;
                }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                    DeviceToolShare.crossoverR_isConnect = self.connectR ;
                    DeviceToolShare.crossoverR_connectType = INEQ_connectType_bottom;
                }
                
                if (leftButton.selected || rightButton.selected) {
                    rightButton.selected = YES;
                    leftButton.selected = YES;
                }
            }];
                
            }else{
                but.selected = !but.selected;
                self.connectR = !but.selected;
                
                if (leftButton.selected || rightButton.selected) {
                    rightButton.selected = YES;
                    leftButton.selected = YES;
                }
            }
        }
    }
    [DeviceToolShare saveInfo];
}

- (IBAction)selectArea:(id)sender {
    
    UIButton *selectBut = (UIButton *)sender;
    
    if (selectBut.selected) {
        selectBut.selected = !selectBut.selected;
        self.selectArea = selectAreaInit;

    }else{
        for (UIButton *but in self.buttonBackView.subviews) {
            if (but.tag >= 101 && but.tag <= 106) {
                but.selected =  NO;
            }
        }
        selectBut.selected = YES;
        self.selectArea = selectBut.tag - 100;
    }
    
    if (self.connectF) {
        if (selectBut.tag == 101) {
            UIButton *but = (UIButton *)[self viewWithTag:102];
            but.selected = selectBut.selected;
        }else if (selectBut.tag == 102){
            UIButton *but = (UIButton *)[self viewWithTag:101];
            but.selected = selectBut.selected;
        }
    }
    if (self.connectR) {
        if (selectBut.tag == 103){
            UIButton *but = (UIButton *)[self viewWithTag:104];
            but.selected = selectBut.selected;
        }else if (selectBut.tag == 104){
            UIButton *but = (UIButton *)[self viewWithTag:103];
            but.selected = selectBut.selected;
        }
    }
}

-(void)setSelectArea:(SelectArea)selectArea{

    _selectArea = selectArea;
    
    int F_R_count= 0;
    for (NSString *tagStr in _selectButtonArray) {
        if ([tagStr isEqualToString:@"201"]
            || [tagStr isEqualToString:@"202"]
            || [tagStr isEqualToString:@"203"]
            || [tagStr isEqualToString:@"204"]
            || [tagStr isEqualToString:@"205"]
            || [tagStr isEqualToString:@"206"]
            || [tagStr isEqualToString:@"207"]
            
            || [tagStr isEqualToString:@"251"]
            || [tagStr isEqualToString:@"252"]
            || [tagStr isEqualToString:@"253"]
            || [tagStr isEqualToString:@"254"]
            || [tagStr isEqualToString:@"255"]
            || [tagStr isEqualToString:@"256"]
            || [tagStr isEqualToString:@"257"]
            
            || [tagStr isEqualToString:@"191"]
            || [tagStr isEqualToString:@"192"]
            || [tagStr isEqualToString:@"193"]
            || [tagStr isEqualToString:@"241"]
            || [tagStr isEqualToString:@"242"]
            || [tagStr isEqualToString:@"243"]
            
            ) {
            F_R_count ++;
        }
    }
    if (F_R_count == 0 ) {
        self.F_Type = _F_none_WoMidTwCo2w;
        self.F_Type_R = _F_none_WoMidTwCo2w;
        self.R_Type = _R_none_Co2w;
        self.R_Type_R = _R_none_Co2w;
    }
    
    
    if (selectArea == selectAreaInit) {
            if (self.setUseImageType) {
                _setUseImageType(imageNone);
            }
    }else if (selectArea == selectAreaZero) {
        [self.selectButtonArray removeAllObjects];
        self.F_Type = _F_none_WoMidTwCo2w;
        self.R_Type = _R_none_Co2w;
        self.F_Type_R = _F_none_WoMidTwCo2w;
        self.R_Type_R = _R_none_Co2w;
        self.Sub_Type = _Sub_none_Sub;
        self.Center_Type = _Center_none_Co2w;        
        
        for (UIButton *but in self.buttonBackView.subviews) {
            if ((but.tag >= 201 && but.tag <=212) || (but.tag >= 251 && but.tag <=257 )
                || (but.tag >= 191 && but.tag <=193) || (but.tag >= 241 && but.tag <=243 )) {
                but.hidden = YES;
            }
        }
        if (self.setUseImageType ) {
            _setUseImageType(imageNone);
        }
    }else if (selectArea == selectAreaFL ){
        
        if (self.setUseHornWithArray) {
            _setUseHornWithArray(_selectButtonArray,selectAreaFL);
        }
    }else if(selectArea == selectAreaFR){
        
        if (self.setUseHornWithArray) {
            _setUseHornWithArray(_selectButtonArray,selectAreaFR);
        }
    }
    else if (selectArea == selectAreaRL ){
        if (self.setUseHornWithArray) {
            _setUseHornWithArray(_selectButtonArray,selectAreaRL);
        }
    }

    else if (selectArea == selectAreaRR){
      
        if (self.setUseHornWithArray) {
            _setUseHornWithArray(_selectButtonArray,selectAreaRR);
        }
    }
    
    else if (selectArea == selectCenter){

        if (self.setUseHornWithArray) {
            _setUseHornWithArray(_selectButtonArray,selectCenter);
        }
    }
    else if (selectArea == selectSoo){

        if (self.setUseHornWithArray) {
            _setUseHornWithArray(_selectButtonArray,selectSoo);
        }
    }
}
-(void)addButtonTag:(CSQAudiotype )csqAudiotype{
    NSString *butTag = nil;
    switch (self.selectArea) {
        case selectAreaFL:
        {
            if (csqAudiotype == woofer) {
                butTag = @"201";
                
            }
            else  if (csqAudiotype == midRange) {
                butTag = @"202";
               
            }
            else if (csqAudiotype == tweeter) {
                butTag = @"203";
                
            }
            else if (csqAudiotype == coax) {
                butTag = @"204";
                
            }
            else if (csqAudiotype == twoWay) {
                butTag = @"205";
                
            }
            BOOL isCloude = NO;
            for (NSString *str in _selectButtonArray) {
                if ([str isEqualToString:butTag]) {
                    isCloude = YES;
                }
            }
            if (!isCloude) {
                [_selectButtonArray addObject:butTag];
            }
            
            if (self.connectF) {
               
                
                if (csqAudiotype == woofer) {
                    butTag = @"201";
                   
                }
                else  if (csqAudiotype == midRange) {
                    butTag = @"202";
                    
                }
                else if (csqAudiotype == tweeter) {
                    butTag = @"203";
                    
                }
                else if (csqAudiotype == coax) {
                    butTag = @"204";
                    
                }
                else if (csqAudiotype == twoWay) {
                    butTag = @"205";
                    
                }
                int b = [butTag intValue] + 50;
                BOOL isCloude = NO;
                for (NSString *str in _selectButtonArray) {
                    if ([str isEqualToString:[NSString stringWithFormat:@"%d",b]]) {
                        isCloude = YES;
                    }
                }
                if (!isCloude) {
                    [_selectButtonArray addObject:[NSString stringWithFormat:@"%d",b]];
                }
            }

            if (self.setUseHornWithArray) {
                _setUseHornWithArray(_selectButtonArray,selectAreaFL);
            }
        }
            break;
        case selectAreaFR:
            {
                if (csqAudiotype == woofer) {
                    butTag = @"201";
                    
                }
                else  if (csqAudiotype == midRange) {
                    butTag = @"202";
                    
                }
                else if (csqAudiotype == tweeter) {
                    butTag = @"203";
                    
                }
                else if (csqAudiotype == coax) {
                    butTag = @"204";
                    
                }
                else if (csqAudiotype == twoWay) {
                    butTag = @"205";
                    
                }
                int b = [butTag intValue] + 50;
                BOOL isCloude = NO;
                for (NSString *str in _selectButtonArray) {
                    if ([str isEqualToString:[NSString stringWithFormat:@"%d",b]]) {
                        isCloude = YES;
                    }
                }
                if (!isCloude) {
                    [_selectButtonArray addObject:[NSString stringWithFormat:@"%d",b]];
                }
         
                
                if (self.connectF) {
                    if (csqAudiotype == woofer) {
                        butTag = @"201";
                        
                    }
                    else  if (csqAudiotype == midRange) {
                        butTag = @"202";
                        
                    }
                    else if (csqAudiotype == tweeter) {
                        butTag = @"203";
                        
                    }
                    else if (csqAudiotype == coax) {
                        butTag = @"204";
                        
                    }
                    else if (csqAudiotype == twoWay) {
                        butTag = @"205";
                        
                    }
                    BOOL isCloude = NO;
                    for (NSString *str in _selectButtonArray) {
                        if ([str isEqualToString:butTag]) {
                            isCloude = YES;
                        }
                    }
                    if (!isCloude) {
                        [_selectButtonArray addObject:butTag];
                    }
                }
            }
            if (self.setUseHornWithArray) {
                _setUseHornWithArray(_selectButtonArray,selectAreaFR);
            }
            break;
        case selectAreaRL:
        {
            if (csqAudiotype == twoWay) {
                butTag = @"206";
        
                
            }else if (csqAudiotype == coax) {
                butTag = @"207";
                
            }else if (csqAudiotype == tweeter) {
                butTag = @"193";
            }else if (csqAudiotype == midRange) {
                butTag = @"192";
            }else if (csqAudiotype == woofer) {
                butTag = @"191";
            }
        
            BOOL isCloude = NO;
            for (NSString *str in _selectButtonArray) {
                if ([str isEqualToString:butTag]) {
                    isCloude = YES;
                }
            }
            if (!isCloude) {
                [_selectButtonArray addObject:butTag];
            }
            
            if (self.connectR) {
                if (csqAudiotype == twoWay) {
                    butTag = @"206";
                    
                    
                }else if (csqAudiotype == coax) {
                    butTag = @"207";
                    
                }else if (csqAudiotype == tweeter) {
                    butTag = @"193";
                }else if (csqAudiotype == midRange) {
                    butTag = @"192";
                }else if (csqAudiotype == woofer) {
                    butTag = @"191";
                }
                
                
                int b = [butTag intValue] + 50;
                BOOL isCloude = NO;
                for (NSString *str in _selectButtonArray) {
                    if ([str isEqualToString:[NSString stringWithFormat:@"%d",b]]) {
                        isCloude = YES;
                    }
                }
                if (!isCloude) {
                    [_selectButtonArray addObject:[NSString stringWithFormat:@"%d",b]];
                }
            }

            if (self.setUseHornWithArray) {
                _setUseHornWithArray(_selectButtonArray,selectAreaRL);
            }
        }
            break;
        case selectAreaRR:
        {
            if (csqAudiotype == twoWay) {
                butTag = @"206";
                
                
            }else if (csqAudiotype == coax) {
                butTag = @"207";
               
            }else if (csqAudiotype == tweeter) {
                butTag = @"193";
            }else if (csqAudiotype == midRange) {
                butTag = @"192";
            }else if (csqAudiotype == woofer) {
                butTag = @"191";
            }
           
            int b = [butTag intValue] + 50;
            BOOL isCloude = NO;
            for (NSString *str in _selectButtonArray) {
                if ([str isEqualToString:[NSString stringWithFormat:@"%d",b]]) {
                    isCloude = YES;
                }
            }
            if (!isCloude) {
                [_selectButtonArray addObject:[NSString stringWithFormat:@"%d",b]];
            }
            
            if (self.connectR) {
                if (csqAudiotype == twoWay) {
                    butTag = @"206";
                   
                    
                }else if (csqAudiotype == coax) {
                    butTag = @"207";
                   
                }else if (csqAudiotype == tweeter) {
                    butTag = @"193";
                }else if (csqAudiotype == midRange) {
                    butTag = @"192";
                }else if (csqAudiotype == woofer) {
                    butTag = @"191";
                }
                
                BOOL isCloude = NO;
                for (NSString *str in _selectButtonArray) {
                    if ([str isEqualToString:butTag]) {
                        isCloude = YES;
                    }
                }
                if (!isCloude) {
                    [_selectButtonArray addObject:butTag];
                }
            }
            if (self.setUseHornWithArray) {
                _setUseHornWithArray(_selectButtonArray,selectAreaRR);
            }
        }
            break;
        case selectSoo:
        {
            butTag = @"208";
            self.Sub_Type = _Sub_Sub_none;
            [_selectButtonArray addObject:butTag];
            if (self.setUseImageType ) {
                _setUseImageType(self.Sub_Type);
            }
        }
            break;
        case selectCenter:
        {
            if (csqAudiotype == coax) {
                butTag = @"209";
                
            }else if(csqAudiotype == twoWay) {
                butTag = @"210";
                
            }else if(csqAudiotype == tweeter) {
                butTag = @"211";
                
            }else if(csqAudiotype == midRange) {
                butTag = @"212";
                
            }
            [_selectButtonArray addObject:butTag];

            if (self.setUseHornWithArray) {
                _setUseHornWithArray(_selectButtonArray,selectCenter);
            }
        }
            break;
        default:
            break;
    }
    
    for (NSString *tagStr in _selectButtonArray) {
        int tag = [tagStr intValue];
        UIButton *selectBut = (UIButton *)[self viewWithTag:tag];
        selectBut.hidden = NO;
    }
}
-(void)removeButton:(UIButton *)but CanUseConnect:(BOOL)canUseConnect{
    int butTag = (int)but.tag;
    
    if (self.valueChange) {
        self.valueChange();
    }

    [_selectButtonArray removeObject:[NSString stringWithFormat:@"%d",butTag]];
    but.hidden = YES;
    
    if (but.tag >= 201 && but.tag <= 205) {
        if (self.connectF && canUseConnect) {
                UIButton *connectBut = (UIButton*)[self viewWithTag:butTag + 50];
            if ([_selectButtonArray indexOfObject:[NSString stringWithFormat:@"%d",connectBut.tag]] != NSNotFound) {
                [self removeButton:connectBut CanUseConnect:NO];
            }
        }
    }else if(but.tag >= 251 && but.tag <= 255)
    {
        if (self.connectF && canUseConnect) {
            UIButton *connectBut = (UIButton*)[self viewWithTag:butTag - 50];
            if ([_selectButtonArray indexOfObject:[NSString stringWithFormat:@"%d",connectBut.tag]] != NSNotFound) {
                [self removeButton:connectBut CanUseConnect:NO];
            }
        }
    }else if((but.tag >= 206 && but.tag <= 207) || (but.tag >= 191 && but.tag <= 193))
    {
        if (self.connectR && canUseConnect) {
            UIButton *connectBut = (UIButton*)[self viewWithTag:butTag + 50];
            if ([_selectButtonArray indexOfObject:[NSString stringWithFormat:@"%d",connectBut.tag]] != NSNotFound) {
                [self removeButton:connectBut CanUseConnect:NO];
            }
        }
    }else if((but.tag >= 256 && but.tag <= 257) || (but.tag >= 241 && but.tag <= 243))
    {

        if (self.connectR && canUseConnect) {
            UIButton *connectBut = (UIButton*)[self viewWithTag:butTag - 50];
            if ([_selectButtonArray indexOfObject:[NSString stringWithFormat:@"%d",connectBut.tag]] != NSNotFound) {
                [self removeButton:connectBut CanUseConnect:NO];
            }
        }
    }
    else if(but.tag >= 209 && but.tag <= 212)
    {

    }else if (but.tag == 208)
    {

    }
    if (self.selectArea != selectAreaZero && self.selectArea != selectAreaInit) {
        [self setSelectArea:self.selectArea];
    }
    SDLog(@" _selectButtonArray = %@",_selectButtonArray);
}

//定制outPut页面
-(void)outPutSettingWithArr:(NSMutableArray *)selectArr{

    self.selectButtonArray = [NSMutableArray arrayWithArray:selectArr];

//修改按钮选中状态
    for (NSString *tagStr in selectArr) {
        int tag = [tagStr intValue];
        UIButton *selectBut = (UIButton *)[self viewWithTag:tag];
        selectBut.hidden = NO;
        selectBut.selected = NO;   //yes时颜色为白色 NO时颜色为绿色
    }
}

//定制intputsetting页面
-(void)inputSettingViewWith:(NSMutableArray *)selectArr{
    self.FLArea.hidden = YES;
    self.FRArea.hidden = YES;
    self.RLArea.hidden = YES;
    self.RRArea.hidden = YES;
    self.SooArea.hidden = YES;
    self.CenterArea.hidden = YES;
    for (UIButton *but in self.buttonBackView.subviews) {
        if ((but.tag >= 201 && but.tag <=212) || (but.tag >= 251 && but.tag <=257)
            || (but.tag >= 191 && but.tag <=193) || (but.tag >= 241 && but.tag <=243)) {
            but.hidden = YES;
        }
    }
    self.selectButtonArray = selectArr;
    for (NSString *tagStr in selectArr) {
        int tag = [tagStr intValue];
        UIButton *selectBut = (UIButton *)[self viewWithTag:tag];
        selectBut.hidden = NO;
        selectBut.selected = YES;   //yes时颜色为白色 NO时颜色为绿色
        [selectBut addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)changeButton:(UIButton*)sender{
    SDLog(@"UIButton.tag = %d",sender.tag);
    for (NSString *tagStr in self.selectButtonArray) {
        int tag = [tagStr intValue];
        UIButton *selectBut = (UIButton *)[self viewWithTag:tag];
        selectBut.selected = YES; //yes为白色
    }
    sender.selected = NO;
    if (self.hornClick) {
        self.hornClick(sender.tag);
    }
}
//定制advanced tuning页面
-(void)advacnedTuningViewWith:(NSMutableArray *)selectArr{
    self.FLArea.hidden = YES;
    self.FRArea.hidden = YES;
    self.RLArea.hidden = YES;
    self.RRArea.hidden = YES;
    self.SooArea.hidden = YES;
    self.CenterArea.hidden = YES;
    for (UIButton *but in self.buttonBackView.subviews) {
        if ((but.tag >= 201 && but.tag <=212) || (but.tag >= 251 && but.tag <=257)
            || (but.tag >= 191 && but.tag <=193) || (but.tag >= 241 && but.tag <=243)) {
            but.hidden = YES;
        }
    }
    self.selectButtonArray = selectArr;
    for (NSString *tagStr in selectArr) {
        int tag = [tagStr intValue];
        UIButton *selectBut = (UIButton *)[self viewWithTag:tag];
        selectBut.hidden = NO;
        selectBut.selected = YES;
        
        [selectBut addTarget:self action:@selector(ancanceTuningClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)ancanceTuningClick:(UIButton*)sender{
    
    SDLog(@"UIButton.tag = %ld",(long)sender.tag);
    NSMutableArray *seleHornArray = [NSMutableArray array];

    if (sender.selected) {
        sender.selected = NO;
        switch (sender.tag) {
            case 203:
            case 201:
            case 202:
            case 204:
            case 205:
            {
                [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag]];
                if (self.connectF) {
                    UIButton *selectBut2 = (UIButton *)[self viewWithTag:sender.tag + 50];
                    selectBut2.selected = NO;
                    [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag + 50]];
                }
            }
                break;
                case 206:
                case 207:
                case 191:
                case 192:
                case 193:
            {
                [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag]];
                if (self.connectR) {
                    UIButton *selectBut2 = (UIButton *)[self viewWithTag:sender.tag + 50];
                    selectBut2.selected = NO;
                    [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag + 50]];
                }
            }
                break;
            case 253:
            case 251:
            case 252:
            case 254:
            case 255:
            {
                [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag]];
                if (self.connectF) {
                    UIButton *selectBut2 = (UIButton *)[self viewWithTag:sender.tag - 50];
                    selectBut2.selected = NO;
                    [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag - 50]];
                }
            }
                break;
            case 256:
            case 257:
            case 241:
            case 242:
            case 243:
                {
                    [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag]];
                    if (self.connectR) {
                        UIButton *selectBut2 = (UIButton *)[self viewWithTag:sender.tag - 50];
                        selectBut2.selected = NO;
                        [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag - 50]];
                    }
                }
                break;
            
            case 208:
            case 209:
            case 210:
                case 211:
                case 212:
            {
                 [seleHornArray addObject:[NSString stringWithFormat:@"%zd",sender.tag]];
            }
                break;
            default:
                break;
        }
        if (sender.tag == 201 || sender.tag == 251
            || sender.tag == 202 || sender.tag == 252
            || sender.tag == 203 || sender.tag == 253
            || sender.tag == 204 || sender.tag == 254
            || sender.tag == 205 || sender.tag == 255) {
            
            if (seleHornArray.count >1) {
                [seleHornArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    
                    if ([self.moduleType isEqualToString:EQmoduleType]) {
                        if (DeviceToolShare.eqF_connectType == INEQ_connectType_top) {
                            return [obj1 integerValue] > [obj2 integerValue];
                        }else if(DeviceToolShare.eqF_connectType == INEQ_connectType_bottom){
                            return [obj1 integerValue] < [obj2 integerValue];
                        }else{
                            return  [obj1 integerValue] > [obj2 integerValue];
                        }
                    }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                        if (DeviceToolShare.crossoverF_connectType == INEQ_connectType_top) {
                            return [obj1 integerValue] > [obj2 integerValue];
                        }else if(DeviceToolShare.crossoverF_connectType == INEQ_connectType_bottom){
                            return [obj1 integerValue] < [obj2 integerValue];
                        }else{
                            return  [obj1 integerValue] > [obj2 integerValue];
                        }
                    }else{
                        return  [obj1 integerValue] > [obj2 integerValue];
                    }
                }];
            }
            
        }else if (sender.tag == 206 || sender.tag == 256
                  || sender.tag == 207 || sender.tag == 257
                  || sender.tag == 193 || sender.tag == 243
                  || sender.tag == 192 || sender.tag == 242
                  || sender.tag == 191 || sender.tag == 241 ) {
            
            if (seleHornArray.count >1) {
                [seleHornArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    
                    if ([self.moduleType isEqualToString:EQmoduleType]) {
                        if (DeviceToolShare.eqR_connectType == INEQ_connectType_top) {
                            return [obj1 integerValue] > [obj2 integerValue];
                        }else if(DeviceToolShare.eqR_connectType == INEQ_connectType_bottom){
                            return [obj1 integerValue] < [obj2 integerValue];
                        }else{
                            return  [obj1 integerValue] > [obj2 integerValue];
                        }
                    }else if ([self.moduleType isEqualToString:CrossoverModuleType]){
                        if (DeviceToolShare.crossoverR_connectType == INEQ_connectType_top) {
                            return [obj1 integerValue] > [obj2 integerValue];
                        }else if(DeviceToolShare.crossoverR_connectType == INEQ_connectType_bottom){
                            return [obj1 integerValue] < [obj2 integerValue];
                        }else{
                            return  [obj1 integerValue] > [obj2 integerValue];
                        }
                    }else{
                        return  [obj1 integerValue] > [obj2 integerValue];
                    }
                }];
            }
            
        }
    }
    CSQ_DISPATCH_AFTER(afterTime, ^{
        if (self.hornClick) {
            self.hornClick((int)sender.tag);
        }
        if (self.getSeleHorn) {
            self.getSeleHorn(seleHornArray);
        }
    })
}
+(NSString*)changeTagToHorn:(NSString*)tagStr{
    switch ([tagStr intValue]) {
        case 201:
        {
            return @"Woofer FL";
        }
            break;
        case 191:
        {
            return @"Woofer RL";
        }
            break;
        case 251:
        {
            return @"Woofer FR";
        }
            break;
        case 241:
        {
            return @"Woofer RR";
        }
            break;
        case 202:
        {
            return @"Mid range FL";
        }
            break;
        case 192:
        {
            return @"Mid range RL";
        }
            break;
        case 204:
        {
            return @"Coax FL";
        }
            break;
        case 205:
        {
            return @"2 Way FL";
        }
            break;
        case 252:
        {
            return @"Mid range FR";
        }
            break;
        case 242:
        {
            return @"Mid range RR";
        }
            break;
        case 254:
        {
            return @"Coax FR";
        }
            break;
        case 255:
        {
            return @"2 Way FR";
        }
            break;
        case 203:
        {
            return @"Tweeter FL";
        }
            break;
        case 193:
        {
            return @"Tweeter RL";
        }
            break;
        case 253:
        {
            return @"Tweeter FR";
        }
            break;
        case 243:
        {
            return @"Tweeter RR";
        }
            break;
        case 206:
        {
            return @"2 Way RL";
        }
            break;
        case 207:
        {
            return @"Coax RL";
        }
            break;
        case 256:
        {
            return @"2 Way RR";
        }
            break;
        case 257:
        {
            return @"Coax RR";
        }
            break;
        case 208:
        {
            return @"Subwoofer";
        }
            break;
        case 209:
        {
            return @"Coax Center";
        }
            break;
        case 210:
        {
            return @"2 Way Center";
        }
            break;
        case 211:
        {
            return @"Tweeter Center";
        }
            break;
        case 212:
        {
            return @"Midrange Center";
        }
            break;
            
        default:
            
            break;
    }
    return nil;
}

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomerCar" owner:self options:nil] objectAtIndex:0];
    self.backgroundColor = [UIColor clearColor];
    self.selectButtonArray = [NSMutableArray array];
    self.connectF = YES;
    self.connectR = YES;

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
-(void)buttonAddPanges{
//    [super awakeFromNib];
        for (UIButton *but in self.buttonBackView.subviews) {

            if ((but.tag >= 201 && but.tag <=212) || (but.tag >= 251 && but.tag <=257)
                || (but.tag >= 191 && but.tag <=193) || (but.tag >= 241 && but.tag <=243)) {

//                but.enabled = NO;
                but.userInteractionEnabled = YES;
                UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                                        action:@selector(doMoveAction:)];
                [but addGestureRecognizer:panGestureRecognizer];
            }
        }

}
-(void)doMoveAction:(UIPanGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.pointBegin = recognizer.view.center;
    }
    
    
    CGPoint translation = [recognizer translationInView:self];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                    recognizer.view.center.y + translation.y);
    //    限制屏幕范围：
//    newCenter.y = MAX(recognizer.view.frame.size.height/2, newCenter.y);
//    newCenter.y = MIN(self.view.frame.size.height - recognizer.view.frame.size.height/2, newCenter.y);
//    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
//    newCenter.x = MIN(self.view.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self];
    
    CGFloat moveX_L = 0.0;
    CGFloat moveX_R = 0.0;
    CGFloat moveY_Top = 0.0;
    CGFloat moveY_Bottom = 0.0;
    
    UIButton *but = (UIButton*)recognizer.view;
    if (but.tag >= 201 && but.tag <= 205) {
        moveX_L = self.FLArea.left;
        moveX_R = self.FLArea.right;
        moveY_Top = self.FLArea.top;
        moveY_Bottom = self.FLArea.bottom;
    }else if(but.tag >= 251 && but.tag <= 255)
    {
        moveX_L = self.FRArea.left;
        moveX_R = self.FRArea.right;
        moveY_Top = self.FRArea.top;
        moveY_Bottom = self.FRArea.bottom;
    }else if((but.tag >= 206 && but.tag <= 207) || (but.tag >= 191 && but.tag <= 193))
    {
        moveX_L = self.RLArea.left;
        moveX_R = self.RLArea.right;
        moveY_Top = self.RLArea.top;
        moveY_Bottom = self.RLArea.bottom;
    }else if((but.tag >= 256 && but.tag <= 257) || (but.tag >= 241 && but.tag <= 243))
    {
        moveX_L = self.RRArea.left;
        moveX_R = self.RRArea.right;
        moveY_Top = self.RRArea.top;
        moveY_Bottom = self.RRArea.bottom;
    }
    else if(but.tag >= 209 && but.tag <= 212)
    {
        moveX_L = self.CenterArea.left;
        moveX_R = self.CenterArea.right;
        moveY_Top = self.CenterArea.top;
        moveY_Bottom = self.CenterArea.bottom;
    }else if (but.tag == 208)
    {
        moveX_L = self.SooArea.left;
        moveX_R = self.SooArea.right;
        moveY_Top = self.SooArea.top;
        moveY_Bottom = self.SooArea.bottom;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (recognizer.view.right <= moveX_L
            || recognizer.view.left >= moveX_R
            || recognizer.view.bottom <= moveY_Top
            || recognizer.view.top >= moveY_Bottom
            ) {
            SDLog(@"移出目标区域");
            [self removeButton:but CanUseConnect:YES];
        }else{
            SDLog(@"未移出目标区域");
        }
        recognizer.view.center = self.pointBegin;
    }
}

//-(void)setF_Type:(UseImageType)F_Type{
//    _F_Type = F_Type;
//    SDLog(@"setF_Type  F_Type = %d",F_Type);
//}
//-(void)setF_Type_R:(UseImageType)F_Type_R{
//    _F_Type_R = F_Type_R;
//    SDLog(@"setF_Type F_Type_R = %d",F_Type_R);
//}
//-(void)setR_Type:(UseImageType)R_Type{
//    _R_Type = R_Type;
//    SDLog(@"setF_Type R_Type = %d",R_Type);
//}
//-(void)setR_Type_R:(UseImageType)R_Type_R{
//    _R_Type_R = R_Type_R;
//    SDLog(@"setF_Type R_Type_R = %d",R_Type_R);
//}

- (void)dismiss{
    [self removeFromSuperview];
}
@end
