//
//  ViewController.m
//  折线图
//
//  Created by 王奥东 on 16/7/9.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "折线图-Bridging-Header.h"
#import "bridge.swift"
#import "Masonry/Masonry.h"

//此DEMO仿写：http://www.jianshu.com/p/27c756b536df

@interface ViewController ()<ChartViewDelegate>
@property(nonatomic,strong)LineChartView *lineChar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    LineChartView *lineChar = [[LineChartView alloc]init];
  //设置代理对象
    lineChar.delegate = self;
    [self.view addSubview:lineChar];
    [lineChar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width - 20, 300));
        make.center.mas_equalTo(self.view);
    }];

    lineChar.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
    lineChar.noDataText = @"暂无数据";
    
    //保存视图
    self.lineChar = lineChar;
    
    
    

    //取消Y轴缩放
    self.lineChar.scaleYEnabled = NO;
    //取消双击缩放
    self.lineChar.doubleTapToZoomEnabled = NO;
    //启用拖拽图标
    self.lineChar.dragEnabled = YES;
    //拖拽后是否有惯性效果
    self.lineChar.dragDecelerationEnabled = YES;
    //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    self.lineChar.dragDecelerationFrictionCoef = 1;



    //X轴样式
    ChartXAxis *xAxis = self.lineChar.xAxis;
    //设置x轴线宽
    xAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;
    //x轴的显示位置，默认是显示在上面
    xAxis.labelPosition = XAxisLabelPositionBottom;
    //不绘制网格线
    xAxis.drawGridLinesEnabled = NO;
    //设置label的间隙
    xAxis.spaceBetweenLabels = 4;
    //label文字颜色
    xAxis.labelTextColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
    
    

    
    //Y轴样式
    //不绘制右边轴
    self.lineChar.rightAxis.enabled = NO;
    //获取左边Y轴
    ChartYAxis *leftAxis = self.lineChar.leftAxis;
    //Y轴Label数量，数值不一定。如果foeceLabelsEnabled等于YES，则强制绘制指定数量的Label，但是可能不平均
    //不强制绘制指定数量的Label
    leftAxis.forceLabelsEnabled = NO;
    //是否只显示最大值和最小值
    leftAxis.showOnlyMinMaxEnabled = NO;
    //设置Y值得最小值
    leftAxis.axisMinValue = 0;
    //从0开始绘制
    leftAxis.startAtZeroEnabled = YES;
    //设置Y轴的最大值
    leftAxis.axisMaxValue = 105;
    //是否将Y轴进行上下翻转
    leftAxis.inverted = NO;
    //Y轴线宽
    leftAxis.axisLineWidth = 1.0 / [UIScreen mainScreen].scale;
    //自定义格式
    leftAxis.valueFormatter = [[NSNumberFormatter alloc]init];
    //数字后缀单位
    leftAxis.valueFormatter.positiveSuffix = @"$";
    //label位置
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    //文字颜色
    leftAxis.labelTextColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
    //文字字体
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];
    //设置虚线样式的网格线
    leftAxis.gridLineDashLengths = @[@3.0f,@3.0f];
    //网络线颜色
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    //开启抗锯齿
    leftAxis.gridAntialiasEnabled = YES;
    
    //添加一条限制线，不过可以添加很多条。
    ChartLimitLine *limitLine = [[ChartLimitLine alloc]initWithLimit:80 label:@"限制线"];
    limitLine.lineWidth = 2;
    limitLine.lineColor = [UIColor greenColor];
    //此处为虚线样式
    limitLine.lineDashLengths = @[@5.0f,@5.0f];
    //位置
    limitLine.labelPosition = ChartLimitLabelPositionLeftTop;
    //Label文字颜色
    limitLine.valueTextColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    //label字体
    limitLine.valueFont = [UIFont systemFontOfSize:12];
    //添加到Y轴上
    [leftAxis addLimitLine:limitLine];
    //设置限制线绘制在折线图的后面
    leftAxis.drawLimitLinesBehindDataEnabled = YES;

 
    //折线图描述
    [self.lineChar setDescriptionText:@"折线图"];
    [self.lineChar setDescriptionTextColor:[UIColor darkGrayColor]];
    //图例的样式
    self.lineChar.legend.form = ChartLegendFormLine;
    //图例中线条的长度
    self.lineChar.legend.formSize = 30;
    //图例文字颜色
    self.lineChar.legend.textColor = [UIColor darkGrayColor];
    
    
    self.lineChar.data = [self setData];
}

-(LineChartData *)setData{
    
    
    //X轴上要显示多少条数据
    int xVals_count = 12;
    //Y轴的最大值
    double maxYVal = 100;
    
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc]init];
    for (int i = 0; i < xVals_count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"%d月",i+1]];
    }
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc]init];
    for (int i = 0; i < xVals_count; i++) {
        
        double mult = maxYVal + 1;
        double val = (double)(arc4random_uniform(mult));
        ChartDataEntry *entry = [[ChartDataEntry alloc]initWithValue:val xIndex:i];
        [yVals addObject:entry];
        
        
    }
    
    LineChartDataSet *set1 = nil;
    if (self.lineChar.data.dataSetCount > 0) {
        
        LineChartData *data = (LineChartData *)self.lineChar.data;
        set1 = (LineChartDataSet *)data.dataSets[0];
        set1.yVals = yVals;
        return data;
        
        
    }else{
        
        //创建lineCharDataSet创建
        set1 = [[LineChartDataSet alloc]initWithYVals:yVals label:@"lineName"];

        //设置折线的样式
        //折线宽度
        set1.lineWidth = 1.0 / [UIScreen mainScreen].scale;
        //是否在拐点处显示数据
        set1.drawValuesEnabled = YES;
        //折现拐点处显示数据的颜色
        set1.valueColors = @[[UIColor brownColor]];
        //折线颜色
        [set1 setColor:[UIColor greenColor]];
        //是否开启绘制阶梯样式的折线图
        set1.drawSteppedEnabled = NO;
        
        //折线拐点样式
        //是否绘制拐点
        set1.drawCirclesEnabled = NO;
        //拐点半径
        set1.circleRadius = 4.0f;
        //拐点颜色
        set1.circleColors = @[[UIColor redColor],[UIColor greenColor]];

        
        //拐点中间的空心样式
        set1.drawCircleHoleEnabled = YES;
        //空心的半径
        set1.circleHoleRadius = 2.0f;
        //空心的颜色
        set1.circleHoleColor = [UIColor blackColor];
        
        
        //折线的颜色填充样式
        //第一种填充样式：单色填充
        //是否填充颜色
        set1.drawFilledEnabled = YES;
        //填充颜色
        set1.fillColor = [UIColor redColor];
        //填充颜色的透明度
        set1.fillAlpha = 0.3;
        

        //第二种填充样式：渐变填充
//        //是否填充颜色
//        set1.drawFilledEnabled = YES;
//        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"FFFFFFFF"].CGColor,(id)[ChartColorTemplates colorFromString:@"FF007FFF"].CGColor];
//        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
//        //透明度
//        set1.fillAlpha = 0.3f;
//        //赋值填充颜色对象
//        set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];
//        //释放gradientRef
//        CGGradientRelease(gradientRef);
//        
//        //点击选中拐点的交互样式
//        //选中拐点，是否开启高亮效果（显示十字线）
//        set1.highlightEnabled = YES;
//        //点击选中拐点的十字线的颜色
//        set1.highlightColor  = [UIColor purpleColor];
//        //十字线宽度
//        set1.highlightLineWidth = 1.0 / [UIScreen mainScreen].scale;
//        //十字线的虚线样式
//        set1.highlightLineDashLengths = @[@5,@5];
//      
//        
      
        
        //将LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc]init];
        [dataSets addObject:set1];

        //添加第二个LineChartDataSet对象
        LineChartDataSet *set2 = [set1 copy];
        NSMutableArray *yVals2 = [[NSMutableArray alloc]init];
        for (int i = 0; i < xVals_count; i++) {
            double mult = maxYVal +1;
            double val = (double)(arc4random_uniform(mult));
            ChartDataEntry *entry = [[ChartDataEntry alloc]initWithValue:val xIndex:i];
            [yVals2 addObject:entry];
        }
        set2.yVals = yVals2;
        [set2 setColor:[UIColor redColor]];
        //是否填充颜色
        set2.drawFilledEnabled = YES;
        //填充颜色
        set2.fillColor = [UIColor redColor];
        //填充颜色的透明度
        set2.fillAlpha = 0.1;
        [dataSets addObject:set2];
        
//

        //创建LineCharData对象，此对象就是LineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc]initWithXVals:xVals dataSets:dataSets];
        //文字字体
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light"  size:8.f]];
        //文字颜色
        [data setValueTextColor:[UIColor grayColor]];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        //自定义数据显示格式
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"#0.0"];
        [data setValueFormatter:formatter];
        
        
        return data;
        
        
    }
    
}
@end
