/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSInteger,CellType){
    MODE = 1,
    TUNE,
    CONNECT,
    SETUP,
};
@interface photoTableviewC : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *photoTableview;
@property (nonatomic,assign)CellType cellType;
@property (nonatomic,assign)BOOL isSelect;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,copy)void (^didClickCell)(NSInteger deleNumber,CellType cellType);
- (id)initWithType:(CellType)cellType;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showOneTFInView:(UIView*) view;
-(void)setH:(NSString*)str;
-(void)reloadData;
@end
