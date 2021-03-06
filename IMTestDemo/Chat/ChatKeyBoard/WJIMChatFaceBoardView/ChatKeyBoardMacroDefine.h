//
//  Macrol.h
//  FaceKeyboard
//
//  Created by ruofei on 16/3/31.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#ifndef ChatKeyBoardMacroDefine_h
#define ChatKeyBoardMacroDefine_h

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

//ChatKeyBoard背景颜色
#define kChatKeyBoardColor              [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0f]

//键盘上面的工具条
#define kChatToolBarHeight              (49+50)

//表情模块高度
#define kFacePanelHeight                216
#define kFacePanelBottomToolBarHeight   40 //表情模版的高度：40写成0，让它显示不了底部
#define kFacePanelBottomToolBarItemWidth   60 //表情模版的高度：40写成0，让它显示不了底部
#define kUIPageControllerHeight         25

//拍照、发视频等更多功能模块的面板的高度
#define kMorePanelHeight                216
#define kMoreItemH                      80
#define kMoreItemIconSize               60


//整个聊天工具的高度
#define kChatKeyBoardHeight     kChatToolBarHeight + kFacePanelHeight

#define isIPhone4_5                (kScreenWidth == 320)
#define isIPhone6_6s               (kScreenWidth == 375)
#define isIPhone6p_6sp             (kScreenWidth == 414)

#endif /* ChatKeyBoardMacroDefine_h */
