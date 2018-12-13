/*
 ============================================================================
 Name        : HotlineViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */
#import "Header.h"
#import "photoTableviewC.h"
#import "moduleSeleCell.h"
#import "moduleRightCell.h"
#import "ConnectSelectCell.h"
#define cellHeight 50
#define tableviewBottomHeight 90
#import "SocketManager.h"
@interface photoTableviewC ()<UIGestureRecognizerDelegate>
{
    NSArray *titleArray;
    NSArray *imageArray;
    NSArray *imageArrayHigth;
    NSArray *selectImageArray;
    int clickInt;
    moduleSeleCell *afterCell;
}
@property (weak, nonatomic) IBOutlet UIView *BigBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeightContrant;



@end

@implementation photoTableviewC

- (id)initWithType:(CellType)cellType
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"photoTableviewC" owner:self options:nil] objectAtIndex:0];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [_BigBackView addGestureRecognizer:tap];
    _cellType = cellType;
    
    switch (_cellType) {
        case MODE:
        {
            titleArray = @[@"ANALOG",@"SPDIF",@"STREAMING"];
            imageArray = @[@"analog_normat",@"streaming_normat",@"spdif_normat"];
            imageArrayHigth = @[@"analog_selected",@"streaming_selected",@"spdif_selected"];
            selectImageArray = @[@"analog_selected",@"streaming_selected",@"spdif_selected"];
            
            
            CSQ_DISPATCH_AFTER(0.2,^{
                switch (DeviceToolShare.DspMode) {
                    case ANALOG:
                    {
                        
                        NSIndexPath *indexP = [NSIndexPath indexPathForRow:ANALOG inSection:0];
                        afterCell = [self->_photoTableview cellForRowAtIndexPath:indexP];
                        afterCell.selected = YES;
                        
                    }
                        break;
                    case SPDIF:
                    {
                        NSIndexPath *indexP = [NSIndexPath indexPathForRow:1 inSection:0];
                        afterCell = [self->_photoTableview cellForRowAtIndexPath:indexP];
                        afterCell.selected = YES;
                    }
                        break;
                    case STREAMING:
                    {
                        NSIndexPath *indexP = [NSIndexPath indexPathForRow:2 inSection:0];
                        afterCell = [self->_photoTableview cellForRowAtIndexPath:indexP];
                        afterCell.selected = YES;
                    }
                        break;
                    default:
                        break;
                }
            })
            
        }
            break;
        case TUNE:
        {
            titleArray = @[@"Input Level",@"Output Setting",@"Advanced tuning"];
            imageArray = @[@"input eq_normat",@"output_normat",@"advanced tuning_normat"];
            imageArrayHigth = @[@"input eq_selected",@"output_selected",@"advanced tuning_selected"];
            selectImageArray = @[@"input eq_selected",@"output_selected",@"advanced tuning_selected"];
        }
            break;
        case SETUP:
        {
            titleArray = @[@"Manager Preset",@"Preferences",@"Setup Wizard"];
            imageArray = @[@"manager_normat",@"preferences_normat",@"setup wizard_normat"];
            imageArrayHigth = @[@"manager_selected",@"preferences_selected",@"setup wizard_selected"];
            selectImageArray = @[@"manager_selected",@"preferences_selected",@"setup wizard_selected"];
        }
            break;
        case CONNECT:
        {
            if (![SocketManagerShare isWiFiEnabled]){ 
                titleArray = @[@"WiFi not enabled please enable WiFi in the phone settings"];
            }else{
                if ([SocketManagerShare isCurrentWIFI]) {
                    titleArray = @[[NSString stringWithFormat:@"Connected\n%@",SocketManagerShare.currentWIFI]];
                }else{
                    
                    titleArray = @[@"WiFi not connected please connect WiFi in the phone settings"];
                }
            }
        }
            break;
        default:
            break;
    }
    
    [_photoTableview registerNib:[UINib nibWithNibName:@"moduleSeleCell" bundle:nil] forCellReuseIdentifier:@"moduleSeleCell"];
    [_photoTableview registerNib:[UINib nibWithNibName:@"moduleRightCell" bundle:nil] forCellReuseIdentifier:@"moduleRightCell"];
    [_photoTableview registerNib:[UINib nibWithNibName:@"ConnectSelectCell" bundle:nil] forCellReuseIdentifier:@"ConnectSelectCell"];
    
    _photoTableview.bounces = NO;
    _photoTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _photoTableview.delegate = self;
    _photoTableview.dataSource = self;
    _photoTableview.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)showInView:(UIView*) view
{
    self.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
    
    
    CSQ_DISPATCH_AFTER(3.0,^{
        if (!self.isSelect) {
            [self dismiss];
        }
    })
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_cellType) {
        case MODE:
        case TUNE:
        case SETUP:
            {
                return cellHeight;
            }
            break;
        case CONNECT:
            {
//                if (indexPath.row == 0) {
//                    return cellHeight;
//                }else {
//                    CGFloat heigth = autoHeigthFrame(titleArray[indexPath.row],kScreenWidth * 0.6 - 20,17).size.height + 12;
//                    return heigth;
//                }
                if ([SocketManagerShare isCurrentWIFI]) {
                    return cellHeight * 1.8;
                }else{
                    CGFloat heigth = autoHeigthFrame(titleArray[indexPath.row],kScreenWidth * 0.6 - 20,17).size.height + 12;
                    return heigth;
                }
            }
            break;
        default:
            return cellHeight;
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"tableView的数量%lu",(unsigned long)titleArray.count);
    return titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (_cellType) {
        case MODE:
        {
            static NSString*identifier = @"moduleSeleCell";
            moduleSeleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.titleText.text = titleArray[indexPath.row];
            cell.leftImage.image = GetImage(imageArray[indexPath.row]);
            cell.leftImage.highlightedImage = GetImage(imageArrayHigth[indexPath.row]);
            
            return cell;
        }
            break;
        case TUNE:
        case SETUP:
        {
            static NSString*identifier2 = @"moduleRightCell";
            moduleRightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            cell.titleLabel.text = titleArray[indexPath.row];
            cell.imageIcon.image = GetImage(imageArray[indexPath.row]);
            cell.imageIcon.highlightedImage = GetImage(imageArrayHigth[indexPath.row]);
            return cell;
        }
            break;
        case CONNECT:
        {
            static NSString*identifier3 = @"ConnectSelectCell";
            ConnectSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            cell.titleLabel.text = titleArray[indexPath.row];
            
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (_cellType) {
        case CONNECT:
            {
                if ([SocketManagerShare isCurrentWIFI]) {
                    return nil;
                }else{
                    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.6, tableviewBottomHeight)];
                    bottomView.backgroundColor = [UIColor clearColor];
                    
                    CGFloat height = bottomView.frame.size.height;
                    CGFloat width = bottomView.frame.size.width;
                    
                    UIButton *OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    OKButton.backgroundColor = [UIColor greenColor];
                    OKButton.frame = CGRectMake((width - cellHeight)/2, (height - cellHeight)/2, cellHeight, cellHeight);
                    [OKButton setTitle:@"OK" forState:UIControlStateNormal];
                    [OKButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    OKButton.layer.masksToBounds = YES;
                    OKButton.layer.cornerRadius = cellHeight/2;
                    [OKButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
                    [bottomView addSubview:OKButton];
                    
                    return bottomView;
                }
            }
            break;
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (_cellType) {
        case CONNECT:
        {
            if ([SocketManagerShare isCurrentWIFI]) {
                return 0;
            }else{
                return tableviewBottomHeight;
            }
            
        }
            break;
            
        default:
            return 0;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDLog(@"indexPath.row = %d", indexPath.row);
    switch (_cellType) {
        case MODE:
        {
            if (!self.isSelect) {
                [afterCell setSelected:NO];
            }
            
            self.isSelect = YES;
            moduleSeleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            
            [cell setSelected:YES];
//            cell.titleText.textColor = [UIColor greenColor];
//            cell.leftImage.image = GetImage(selectImageArray[indexPath.row]);
            
            switch (indexPath.row) {
                case 0:
                {
                    DeviceToolShare.DspMode = ANALOG;
                }
                    break;
                case 1:
                {
                    DeviceToolShare.DspMode = SPDIF;
                }
                    break;
                case 2:
                {
                    DeviceToolShare.DspMode = STREAMING;
                }
                    break;
                    
                default:
                    break;
            }
            MPWeakSelf(self)
            clickInt++;
            int a = clickInt;
            CSQ_DISPATCH_AFTER(1.0,^{
                if (a == self->clickInt) {
                    if (weakself.didClickCell) {
                        weakself.didClickCell(indexPath.row, weakself.cellType);
                    }
                    [self removeFromSuperview];//
                }
            })
        }
            break;
        case TUNE:
        case SETUP:
        {
            moduleRightCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
            [cell setSelected:YES];
//            cell.titleLabel.textColor = [UIColor greenColor];
//            cell.imageIcon.image = GetImage(imageArray[indexPath.row]);
            
            if (self.didClickCell) {
                _didClickCell(indexPath.row, _cellType);
            }
            [self removeFromSuperview];//
            
        }
            break;
        case CONNECT:
        {
            ConnectSelectCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
            [cell setSelected:YES];
            cell.titleLabel.textColor = [UIColor greenColor];
            
            if (self.didClickCell) {
                
                _didClickCell(indexPath.row, _cellType);
            }
            [self removeFromSuperview];//
            
        }
            break;
        default:
            
            break;
    }
    
    
}

-(void)reloadData{
    
    CGFloat connectHeigth = (autoHeigthFrame(titleArray[0],kScreenWidth * 0.6 - 20,17).size.height + 12) + cellHeight + tableviewBottomHeight;
    _tableviewHeightContrant.constant = _cellType == CONNECT? connectHeigth:cellHeight *titleArray.count;
    [_photoTableview reloadData];
}
- (void)dismiss{
    if (self.didClickCell) {
        _didClickCell(-1, _cellType);
    }
    [self removeFromSuperview];
}




//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    // 点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
//    if ([NSStringFromClass([touch.view class])
//         isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//
//
//    return  YES;
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        return YES;
//    }
//    return NO;
//
//}
@end
