//
//  CSQ_rtaCollectionCell.h
//  DSP
//
//  Created by hk on 2018/9/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "CSQ_rtaModel.h"
@interface CSQ_rtaCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UILabel* label1;
@property(nonatomic,strong)UILabel* label2;
@property(nonatomic,strong)UILabel* label3;
@property(nonatomic,strong)CSQ_rtaModel *rtaModel;
@end
