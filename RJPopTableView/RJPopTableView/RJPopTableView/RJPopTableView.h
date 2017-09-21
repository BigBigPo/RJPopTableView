//
//  RJFloatedView.h
//  SmallSecretary
//
//  Created by Po on 16/9/6.
//  Copyright © 2016年 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJPopTableView : UIView

@property (assign, nonatomic) BOOL hadShadow;               //是否有阴影
@property (strong, nonatomic) UIColor * backViewColor;      //背景色
@property (assign, nonatomic) NSInteger maxCellNum;         //Cell最大显示数

/**
 根据位置初始化悬浮视图

 @param data 数据，[title:imageName]
 @param position 点击的位置
 @param viewWidth 视图宽
 @param cellHeight 单个Cell高度
 @param borderMargin 与视窗边距
 */
- (instancetype)initWithData:(NSArray<NSDictionary *> *)data
                    position:(CGPoint)position
                   viewWidth:(CGFloat)viewWidth
                  cellHeight:(CGFloat)cellHeight
                borderMargin:(CGFloat)borderMargin;

/**
 展示

 @param block 点击回调
 */
- (void)show:(void(^)(NSInteger count))block;

@end
