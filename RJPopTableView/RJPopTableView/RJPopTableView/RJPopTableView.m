//
//  RJFloatedView.m
//  SmallSecretary
//
//  Created by Po on 16/9/6.
//  Copyright © 2016年 pretang. All rights reserved.
//

#import "RJPopTableView.h"
#import "CALayer+RJLayer.h"

#define SCWidth [UIScreen mainScreen].bounds.size.width
#define SCHeight [UIScreen mainScreen].bounds.size.height
#define RJWeak(obj)     __weak typeof(obj) weak##obj = obj;
typedef void(^FloatedViewFinishBlock)(NSInteger count);

static NSString * const FloatedViewID = @"FloatedViewID";
static CGFloat const ArrowWidth = 10;
static CGFloat const ArrowHeight = 6;

@interface RJPopTableView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CAShapeLayer * arrowLayer;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UIView * shadowView;
@property (assign, nonatomic) BOOL arrowLookUp;

@property (strong, nonatomic) NSArray * dataArray;
@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) CGFloat viewWidth;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat borderMargin;
@property (assign, nonatomic) CGRect tableShowRect;

@property (copy, nonatomic) FloatedViewFinishBlock finishBlock;

@end

@implementation RJPopTableView

- (instancetype)initWithData:(NSArray<NSDictionary *> *)data position:(CGPoint)position viewWidth:(CGFloat)viewWidth cellHeight:(CGFloat)cellHeight borderMargin:(CGFloat)borderMargin
{
    self = [super init];
    if (self) {
        _dataArray = [NSArray arrayWithArray:data];
        _position = position;
        _viewWidth = viewWidth;
        _cellHeight = cellHeight;
        _borderMargin = borderMargin;
        _maxCellNum = 0;                        //无限制
        _hadShadow = NO;
        [self setFrame:CGRectMake(0, 0, SCWidth, SCHeight)];
    }
    return self;
}

#pragma mark - function
- (void)show:(void(^)(NSInteger count))block {
    _finishBlock = block;
    
    [self configAllInterface];
    RJWeak(self)
    
    //anim
    CGRect rect = _tableShowRect;
    [UIView animateWithDuration:0.3 animations:^{
        [weakself setBackgroundColor:weakself.backViewColor];
        [weakself.tableView setFrame:rect];
        if (weakself.hadShadow) {
            [weakself.shadowView setFrame:rect];
        }
    }];
}

- (void)removeSelf {
    CGRect rect = _tableView.frame;
    if (_arrowLookUp) {
        rect.size.height = 1;
    } else {
        rect.origin.y += rect.size.height;
        rect.size.height = 1;
    }
    RJWeak(self)
    [UIView animateWithDuration:0.2 animations:^{
        [weakself.tableView setFrame:rect];
        [weakself setBackgroundColor:[UIColor clearColor]];
        if (weakself.hadShadow) {
            [weakself.shadowView setFrame:rect];
        }
    } completion:^(BOOL finished) {
        [weakself.shadowView removeFromSuperview];
        [weakself.tableView removeFromSuperview];
        [weakself removeFromSuperview];
    }];
}

#pragma mark delegate
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_finishBlock) {
        _finishBlock(indexPath.row);
    }
    [self removeSelf];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FloatedViewID forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = _dataArray[indexPath.row];
    NSString * title = [[dic allKeys] lastObject];
    NSString * imageName = [[dic allValues] lastObject];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    [cell.textLabel setText:title];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

#pragma mark - setter
- (void)configAllInterface {
    NSInteger cellNum = _maxCellNum == 0 ? _dataArray.count : _maxCellNum;
    CGFloat viewBottomPosition = _position.y + ArrowHeight + _cellHeight * cellNum;
    NSLog(@"%f", SCHeight);
    //判断控件的朝向
    if( viewBottomPosition <= SCHeight ) {
        _arrowLookUp = YES;
    } else {
        _arrowLookUp = NO;
        CGFloat lookDownTop = _position.y - ArrowHeight - _cellHeight * cellNum;
        
        if (lookDownTop < _borderMargin) {
            //若上下均超出窗口，则选择较多空间的一边
            _arrowLookUp = _position.y < SCHeight / 2;
        }
    }
    //展示箭头
    [self configArrowLayer];
    
    [self configTableView];
    if (_hadShadow) {
        [self configShadowLayer];
    }
    [self setBackgroundColor:[UIColor colorWithRed:33/255.0f green:33/255.0f blue:33/255.0f alpha:0]];
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

- (void)configTableView {
    //生成列表
    _tableShowRect = [self getViewRectSuitWindow:_arrowLookUp];
    CGRect tableInitRect = _tableShowRect;
    tableInitRect.size.height = 1;
    if (!_arrowLookUp) {
        tableInitRect.origin.y += _tableShowRect.size.height;
    }
    _tableView = [[UITableView alloc] initWithFrame:tableInitRect];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FloatedViewID];
    [_tableView.layer setCornerRadius:3];
    [self addSubview:_tableView];
}

- (void)configArrowLayer {
    _arrowLayer = [CAShapeLayer layer];
    //获取箭头所在的区域
    CGRect arrowFrame = CGRectMake(_position.x - ArrowWidth / 2,
                                   _arrowLookUp ? _position.y : _position.y - ArrowHeight,
                                   ArrowWidth,
                                   ArrowHeight);
    
    //检测是否超出边界
    if (arrowFrame.origin.x < _borderMargin) {
        arrowFrame.origin.x = _borderMargin + 3;
    } else {
        CGFloat rightErrorValue = (arrowFrame.origin.x + arrowFrame.size.width) - (SCWidth - _borderMargin);
        if (rightErrorValue > 0) {
            arrowFrame.origin.x -= (rightErrorValue + 3);
        }
    }
    
    //绘制矩形
    [_arrowLayer setFrame:arrowFrame];
    UIBezierPath * path = [self getPathWithArrayLayerFrame:arrowFrame lookUp:_arrowLookUp];
    [_arrowLayer setPath:path.CGPath];
    [_arrowLayer setFillColor:[UIColor whiteColor].CGColor];
    [self.layer addSublayer:_arrowLayer];
}

- (void)configShadowLayer {
    if (_hadShadow) {
        [_arrowLayer showShadowWithOffset:CGSizeMake(4, 3) radio:4];
    }
    _shadowView=[[UIView alloc] initWithFrame:_tableView.frame];
    _shadowView.layer.cornerRadius=5;
    _shadowView.layer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    [_shadowView.layer showShadowWithOffset:CGSizeMake(4, 3) radio:4];
    [self.layer insertSublayer:_shadowView.layer below:_arrowLayer];
    

}

#pragma mark - tools

- (UIBezierPath *)getPathWithArrayLayerFrame:(CGRect)frame lookUp:(BOOL)lookUp{
    UIBezierPath * path = [UIBezierPath bezierPath];
    if (lookUp) {
        [path moveToPoint:CGPointMake(5, 0)];
        [path addLineToPoint:CGPointMake(0, 6)];
        [path addLineToPoint:CGPointMake(10, 6)];
    } else {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(5, 6)];
        [path addLineToPoint:CGPointMake(10, 0)];
    }
    [path closePath];
    return path;
}

- (CGRect)getViewRectSuitWindow:(BOOL)lookUp {
    NSInteger cellNum = (_maxCellNum == 0 || _maxCellNum > _dataArray.count) ? _dataArray.count : _maxCellNum;
    CGFloat x = 0, y = 0, height = _cellHeight * cellNum;
    
    //根据朝向确定控件Y坐标
    if (lookUp) {
        y = _position.y + ArrowHeight;
        CGFloat value = (SCHeight - _borderMargin) - (y + height);
        if (value < 0) {
            height += value;
            height -= ((NSInteger)height % (NSInteger)_cellHeight);
        }
    } else {
        y = _position.y - ArrowHeight - _cellHeight * cellNum;
        CGFloat value = y - _borderMargin;
        if (value < 0) {
            height += value;
            CGFloat errorValue = ((NSInteger)height % (NSInteger)_cellHeight);
            height -= errorValue;
            y = errorValue + _borderMargin;
        }
    }
    
    //确保视图不会超出边界
    x = _position.x - _viewWidth / 2;
    if (x < _borderMargin) {
        x = _borderMargin;
    } else if (x > SCWidth - _borderMargin - _viewWidth) {
        x = SCWidth - _borderMargin - _viewWidth;
    }
    
    return CGRectMake(x, y, _viewWidth, height);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeSelf];
}
@end
