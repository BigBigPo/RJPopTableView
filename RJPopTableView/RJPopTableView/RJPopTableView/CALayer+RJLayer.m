//
//  CALayer+RJLayer.m
//  test
//
//  Created by Po on 16/3/2.
//  Copyright © 2016年 Po. All rights reserved.
//

#import "CALayer+RJLayer.h"

@implementation CALayer (RJLayer)
- (void)showShadowWithOffset:(CGSize)offset radio:(CGFloat)radio {
    self.masksToBounds=NO;
    self.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.shadowOffset = offset;//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    self.shadowOpacity = 0.8;//阴影透明度，默认0
    self.shadowRadius = radio;//阴影半径，默认3
}
@end
