/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SelectArea) {
    selectAreaInit = 0,
    selectAreaFL = 1,
    selectAreaFR = 2,
    selectAreaRL = 3,
    selectAreaRR = 4,
    selectCenter = 5,
    selectSoo = 6,
    selectAreaZero = 7,
};


typedef NS_ENUM(NSInteger, CSQAudiotype) {
    woofer = 0, // 低音
    twoWay ,// 2分频
    coax ,// 中轴
    midRange ,//中
    tweeter ,// 高音
    subwoofer ,//低音炮
};


typedef NS_ENUM(NSInteger, CSQAreaType) {
    Center = 300,
    SubWoofer ,
    F_one ,
    F_two ,
    F_three,
    R_one,
    R_two,
    R_three,
    SubWooferL,
    SubWooferR,
};



typedef NS_ENUM(NSInteger, UseImageType) {
    imageNone = 0,
    //FL  FR  前排
    _F_none_WoMidTwCo2w = 1, //none 指没有选择 后面可供选择
    _F_none_Wo2w,
    _F_none_Wo2wCo ,
    _F_none_WoCo,
    _F_none_WoMidTw,
    _F_Wo_MidTw2wCo ,
    _F_Wo_2wCo,
    _F_Wo_MidTw,

    _F_Wo_2w,
    _F_Wo_Co,
    _F_Mid_WoTw ,
    _F_Tw_WoMid ,
    _F_TwMid_Wo ,
    _F_WoMid_Tw ,
    
    _F_Co_Wo,
    _F_2w_Wo ,
    
    _F_WoTw_Mid  ,
    _F_WoMidTw_none,
    _F_WoCo_none  ,
    _F_Wo2w_none  ,
    
    //RL  RR  后排
    _R_none_Co2w,
    _R_none_Co,
    _R_none_2w,
    _R_Co_none,
    _R_2w_none,
    _R_none_none,  //没有已选 没有可选  针对F区三分频的情况
    
    //SUBWoofer Soo  车尾
    _Sub_none_Sub,
    _Sub_Sub_none,
    //center     中控
    _Center_none_Co2w,
    _Center_Co_none,
    _Center_2w_none,
    _Center_none_2w,
};
#define EQmoduleType @"EQmoduleType"
#define CrossoverModuleType @"CrossoverModuleType"

@interface CustomerCar : UIView

@property(nonatomic,copy)NSString *moduleType;

@property(nonatomic,assign)SelectArea selectArea;
@property(nonatomic,assign)UseImageType F_Type;//前左
@property(nonatomic,assign)UseImageType F_Type_R;//前右
@property(nonatomic,assign)UseImageType R_Type;//后左
@property(nonatomic,assign)UseImageType R_Type_R;//后右
@property(nonatomic,assign)UseImageType Sub_Type;//低音炮  车尾
@property(nonatomic,assign)UseImageType Center_Type;//中控
@property (nonatomic,strong)NSMutableArray *selectButtonArray;
@property(nonatomic,copy)void (^setUseImageType)(UseImageType useImageType);
@property(nonatomic,copy)void (^setUseHornWithArray)(NSArray * seleArray,SelectArea seleType);

@property(nonatomic,copy)void (^valueChange)();

@property(nonatomic,copy)void (^hornClick)(int tag);
@property(nonatomic,copy)void (^getSeleHorn)(NSArray *tagArray);

@property(nonatomic,assign,getter = isConnectF) BOOL connectF;

@property(nonatomic,assign,getter = isConnectR) BOOL connectR;

@property (weak, nonatomic) IBOutlet UIButton *FLArea;
@property (weak, nonatomic) IBOutlet UIButton *FRArea;
@property (weak, nonatomic) IBOutlet UIButton *RLArea;

@property (weak, nonatomic) IBOutlet UIButton *RRArea;
@property (weak, nonatomic) IBOutlet UIButton *CenterArea;
@property (weak, nonatomic) IBOutlet UIButton *SooArea;

@property (weak, nonatomic) IBOutlet UIView *buttonBackView;

@property (weak, nonatomic) IBOutlet UIButton *F_connectButton;
@property (weak, nonatomic) IBOutlet UIButton *R_connectButton;


//设置inputsetting页面
- (void)inputSettingViewWith:(NSMutableArray *)selectArr;
- (void)changeButton:(UIButton*)sender;
//设置advacnedTuningView页面
- (void)advacnedTuningViewWith:(NSMutableArray *)selectArr;
//定制outPut页面
-(void)outPutSettingWithArr:(NSMutableArray *)selectArr;

- (void)addButtonTag:(CSQAudiotype )csqAudiotype;
- (id)init;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showOneTFInView:(UIView*) view;
- (void)showInView:(UIView*) view  withFrame:(CGRect)rect;
+ (NSString*)changeTagToHorn:(NSString*)tagStr;
-(void)buttonAddPanges;
@end
