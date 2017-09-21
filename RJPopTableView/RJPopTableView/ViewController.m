//
//  ViewController.m
//  RJPopTableView
//
//  Created by Po on 2017/9/21.
//  Copyright © 2017年 Po. All rights reserved.
//

#import "ViewController.h"
#import "RJPopTableView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numOfDataTF;
@property (weak, nonatomic) IBOutlet UITextField *cellHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *maxIndexTF;
@property (weak, nonatomic) IBOutlet UITextField *borderValueTF;
@property (weak, nonatomic) IBOutlet UITextField *widthTF;
@property (weak, nonatomic) IBOutlet UIButton *shadowButton;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - event
- (IBAction)pressShadowButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

    //get touch position
    UITouch * touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.view];
    
    //get datas
    BOOL hadShadow = _shadowButton.selected;
    CGFloat cellHeight = [_cellHeightTF.text floatValue];
    CGFloat viewWidth = [_widthTF.text floatValue];
    NSInteger number = [_numOfDataTF.text integerValue];
    CGFloat borderValue = [_borderValueTF.text floatValue];
    NSInteger maxIndex = [_maxIndexTF.text integerValue];
    
    NSMutableArray * datas = [NSMutableArray array];
    for (NSInteger index = 0; index < number; index ++) {
        NSString * title = [NSString stringWithFormat:@"%@", @(index)];
        [datas addObject:@{title:@"icon"}];
    }
    

    
    //config poview with some data
    RJPopTableView * popView = [[RJPopTableView alloc] initWithData:datas
                                                           position:position
                                                          viewWidth:viewWidth
                                                         cellHeight:cellHeight
                                                       borderMargin:borderValue];
    //color of background view
    popView.backViewColor = [UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:0.5];
    //show the shadow
    popView.hadShadow = hadShadow;
    
    //max number of cell number to show
    
    popView.maxCellNum = maxIndex;
    //show the pop view
    __weak typeof(self) weakSelf = self;
    [popView show:^(NSInteger count) {
        [weakSelf.showLabel setText:[NSString stringWithFormat:@"%@",@(count)]];
    }];
}


@end
