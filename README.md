# RJPopTableView
a pop view of TableView, help developer to create a selection view quickly.

the pop view could suit the device window size with some data you can config it。

Demo
![image](https://github.com/BigBigPo/RJPopTableView/blob/master/RJPopTableView/demoShow.gif)

It's easy to use like this:
```
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
```
