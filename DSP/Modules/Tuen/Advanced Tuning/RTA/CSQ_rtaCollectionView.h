//
//  CSQ_rtaCollectionView.h
//  DSP
//
//  Created by hk on 2018/9/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#define collectWidth (SCREENWIDTH - 20)
#define collectHeight (SCREENHEIGHT - 75)
#define rta_cellWidth (collectWidth/20)
@interface CSQ_rtaCollectionView : UICollectionView
@property(nonatomic,strong)NSMutableArray *data1Array;
//@property(nonatomic,strong)NSMutableArray *data2Array;
//@property(nonatomic,strong)NSMutableArray *data3Array;

@property(nonatomic,strong)UIView *moveBackView;
@property(nonatomic,strong)UIView *moveView;
@property(nonatomic,strong)UILabel *henLineLabel;
@property(nonatomic,strong)UILabel *shuLineLabel;

@property(nonatomic,strong)UILabel *bandLabel;
@property(nonatomic,strong)UILabel *freqLabel;

@property(nonatomic,assign)NSInteger seleRow;
-(void)reloadData;
-(void)setMoveViewHidden:(BOOL)hidden;
-(void)addMoveBackView;
-(void)moveBackViewAddToView:(UIView*)toView;
@end
