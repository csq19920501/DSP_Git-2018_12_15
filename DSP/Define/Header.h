//
//  Header.h
//  DSP
//
//  Created by hk on 2018/6/12.
//  Copyright © 2018年 hk. All rights reserved.
//


#ifndef Header_h
#define Header_h
#import "Toast+UIView.h"
#import "AppData.h"
#import "DeviceTool.h"
#import "CusSeleView.h"
#import "UIUtil.h"
#import "AppDelegate.h"
#import "SocketManager.h"
#import "CustomerAlertView.h"
#import "Masonry.h"
#define afterTime 0.7
#define Level120 120
#define Level132 132
#define Q_changeV 16
#define Q_bili 10.0
#define CsqDebug YES


#define SELFVIEW [UIApplication sharedApplication].keyWindow
#define APPURL @"http://www.ifengstar.com/api.do"
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define TabbarHigth ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
#define KAddObserver(selectorName,name_Y,obj_Y)   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectorName) name:name_Y object:obj_Y];


#define mostNunber 10               //发送指令最多次数
#define TFLength  16                //输入限制长度
#define  showLimit(length)  [UIUtil showToast:[NSString stringWithFormat:@"长度不能超过%d位",length] inView:self.view];


#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGB(r, g, b ) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1)]
#define Kcolor(r, g, b , a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HBackColor Kcolor(235, 235, 241 , 1)    //背景颜色
#define HTextColor Kcolor(22, 178, 252 , 1)     //字体颜色

#define  getTimer(Timer,repeatTime,selectorStr)    Timer = [NSTimer scheduledTimerWithTimeInterval:repeatTime target:self selector:@selector(selectorStr) userInfo:nil repeats:YES];
#define endTimer(Timer) [Timer invalidate]; Timer = nil;

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define USERMANAGER [UserManager sharedInstance]
#define USER_PLIST [NSUserDefaults standardUserDefaults]

#define DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

#define DISPATCH_ON_GROUP_THREAD(groupQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), groupQueueBlock);

#define CSQ_DISPATCH_AFTER(afterTime,agterQueueBlock) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), agterQueueBlock);
//DISPATCH_AFTER(1.5,^{  })

#define MPWeakSelf(type)  __weak typeof(type) weak##type = type;
#define MPStrongSelf(type)  __strong typeof(type) type = weak##type;

#define autoHeigthFrame(title,width,sysFont) [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:sysFont]} context:nil]
#define autoWidthFrame(title,heigth,sysFont) [title boundingRectWithSize:CGSizeMake(MAXFLOAT,heigth ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:sysFont]} context:nil]


#define showNewAlert(title,messageText,CancelBlock,OKBlock) UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messageText preferredStyle:  UIAlertControllerStyleAlert];[alert addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleDefault handler:CancelBlock]];[alert addAction:[UIAlertAction actionWithTitle:L(@"OK") style:UIAlertActionStyleDefault handler:OKBlock]];[self presentViewController:alert animated:true completion:nil];
//弱引用showPicure
#define weakShowNewAlert(title,messageText,CancelBlock,OKBlock) UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messageText preferredStyle:  UIAlertControllerStyleAlert];[alert addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleDefault handler:CancelBlock]];[alert addAction:[UIAlertAction actionWithTitle:L(@"OK") style:UIAlertActionStyleDefault handler:OKBlock]];[weakself presentViewController:alert animated:true completion:nil];

#define LOGDATA(a) NSLog(@"data = %@  data.msg = %@   dict= %@",data,data[@"msg"],a);

#define LOG2DATA NSLog(@"data = %@ retDesc = %@",data,data[@"retDesc"]);

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define  isIphone4 [UIScreen mainScreen].bounds.size.height<=490?YES:NO
#define  isIphone5 [UIScreen mainScreen].bounds.size.height==568?YES:NO
#define  isIphone6 [UIScreen mainScreen].bounds.size.height==667?YES:NO
#define  isIphonePLUS [UIScreen mainScreen].bounds.size.height ==736?YES:NO
//#define  isIphone6More ([UIScreen mainScreen].bounds.size.height>=667?YES:NO)
#define isIphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height>20?YES:NO)
//中文字体
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]

//不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5 如果不是则根据实际情况修改）
#define kScreenWidthRatio  (kScreenWidth / 320.0)
#define kScreenHeightRatio (kScreenHeight / 568.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)     CHINESE_SYSTEM(AdaptedWidth(R))

// 是否空对象
#define IS_NULL_CLASS(OBJECT) [OBJECT isKindOfClass:[NSNull class]]

//字符串是否为空
//#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 || [str isEqualToString:@" "]|| [str isEqualToString:@""] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0 ? YES : NO)
#define headImageIsEmpty(str) (kStringIsEmpty(str) || [str isEqualToString:@"0"]?YES :NO)

#define CsqStringIsEmpty(str) kStringIsEmpty(str)?@"":str
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))



// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])


//字体色彩
#define COLOR_WORD_BLACK HEXCOLOR(0x333333)
#define COLOR_WORD_GRAY_1 HEXCOLOR(0x666666)
#define COLOR_WORD_GRAY_2 HEXCOLOR(0x999999)

#define COLOR_UNDER_LINE [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1]

//App版本号
#define appMPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])

#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]

#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#define Main_Screen_Bounds [[UIScreen mainScreen] bounds]
// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width


#ifdef DEBUG
//#   define SDLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
//#   define SDLog  NSLog
#   define SDELog(err) {if(err) DLog(@"%@", err)}
#   define SocLog NSLog
#   define SDLog(...)
//#   define SDELog(err)
#else

#   define SDLog(...)
#   define SDELog(err)
#endif


#endif /* Header_h */
