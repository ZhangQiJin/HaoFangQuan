//
//  Header.h
//
//
//  Created by 高山 on 14-10-25.
//  Copyright (c) 2014年 高山. All rights reserved.
//

#ifndef _____Header_h
#define _____Header_h


//******屏幕高度
#define LCDH [[UIScreen mainScreen]bounds].size.height
//******屏幕宽度
#define LCDW [[UIScreen mainScreen]bounds].size.width
//******本地读取图片
#define  App_ContentFile(aFileName,aFileType) [[NSBundle mainBundle]pathForResource:aFileName ofType:aFileType]
//判断设备是否是iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//#import "Reachability.h"
#endif
