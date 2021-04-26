//
//  LTPView.h
//  LTSDK
//
//  Created by zhengli on 2018/4/26.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CakeView : UIView<UITextViewDelegate>
//按钮按下文字的颜色
@property (nonatomic, copy) UIColor *btnTouchDownColor;
//按钮的背景颜色
@property (nonatomic, copy) UIColor *btnBGColor;
//文字的字号
@property (nonatomic) float fontSize;
//界面原来的frame
@property (nonatomic) CGRect originFrame;
//text的默认边界颜色
@property (nonatomic, copy) UIColor *textDefaultColor;
//text编辑中的边框颜色
@property (nonatomic, copy) UIColor *textEditColor;

//通过设置view的边距来决定view的大小和位置
@property (nonatomic, assign) CGFloat baseViewtoLeft;
@property (nonatomic, assign) CGFloat baseViewtoTop;

//title栏的高度
@property (nonatomic, assign) CGFloat titleBarHeight;
//定义按钮到左边的距离
@property (nonatomic, assign) CGFloat itemToLeft;
//定义按钮到左边的距离
@property (nonatomic, assign) CGFloat itemHeight;
//item之间的纵向距离
@property (nonatomic, assign) CGFloat itemDistance;
@property (nonatomic, assign) CGFloat btnCornerRadius;
@property (nonatomic, assign) CGFloat lastItemOriginX;

//横线
@property (strong, nonatomic) UIView *grayLineView;

-(instancetype)initWithCakeView : (NSDictionary *) cakeDic;

@end
