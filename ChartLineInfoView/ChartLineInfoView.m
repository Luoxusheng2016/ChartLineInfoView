//
//  ChartLineInfoView.m
//  LineInfoVC
//
//  Created by Luoxusheng-imac on 16/6/29.
//  Copyright © 2016年 luoxusheng. All rights reserved.
//

#import "ChartLineInfoView.h"
#import "Masonry.h"


@interface ChartLineInfoView ()<UIScrollViewDelegate>
{
    CGFloat currentPage;//当前页数
    CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    CGPoint lastPoint;//最后一个坐标点
    UIButton *firstBtn;
}

@property (nonatomic,strong)UIScrollView *chartScrollView;
@property (nonatomic,strong)UIView *bgView1;//背景图
@property (nonatomic,strong)UIView *bgView2;
@property (nonatomic,strong)UIPageControl *pageControl;//分页
@property (nonatomic,strong)UIView *scrollBgView1;
@property (nonatomic,strong)UIView *scrollBgView2;
@property (nonatomic,strong)NSMutableArray *leftPointArr;//左边的数据源
@property (nonatomic,strong)NSMutableArray *rightPointArr;//右边的数据源
@property (nonatomic,strong)NSMutableArray *leftBtnArr;//左边按钮
@property (nonatomic,strong)NSMutableArray *righttBtnArr;//左边按钮
@property (nonatomic,strong)NSArray *leftScaleArr;
@property (nonatomic,strong)NSMutableArray *leftScaleViewArr;//左边的点击显示图
@property (nonatomic,strong)NSMutableArray *rightScaleViewArr;//右边的点击显示图
@property (nonatomic,strong)UIView *scaleBgView;
@property (nonatomic,strong)UILabel *lineLabel;
@property (nonatomic,strong)UILabel *scaleLabel;
@property (nonatomic,strong)UILabel *dateTimeLabel;

@end

@implementation ChartLineInfoView

-(UILabel *)scaleLabel{
    if (!_scaleLabel) {
        _scaleLabel = [[UILabel alloc]init];
        _scaleLabel.textAlignment = 1;
        _scaleLabel.text = @"3.3681%";
        _scaleLabel.font = [UIFont systemFontOfSize:11];
        _scaleLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
        _scaleLabel.textColor = [UIColor whiteColor];
    }
    return _scaleLabel;
    
}

-(UILabel *)dateTimeLabel{
    if (!_dateTimeLabel) {
        _dateTimeLabel = [[UILabel alloc]init];
        _dateTimeLabel.textAlignment = 1;
        _dateTimeLabel.text = @"2016.04.16";
        _dateTimeLabel.font = [UIFont systemFontOfSize:11];
        _dateTimeLabel.backgroundColor = [UIColor whiteColor];
        _dateTimeLabel.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1];
    }
    return _dateTimeLabel;
    
    
    
}

-(UILabel *)lineLabel{
    
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
    }
    return _lineLabel;
}

//-(UIView *)scaleBgView{
//    
//    
//    _scaleBgView = [[UIView alloc]init];
//       // _scaleBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
//   
//    return _scaleBgView;
//    
//}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.center = CGPointMake(self.chartScrollView.center.x, CGRectGetMaxY(self.chartScrollView.frame));
        _pageControl.bounds = CGRectMake(0, 0, 60, 30);
        _pageControl.numberOfPages = 2;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.currentPage = 0;
        
    }
    
    return _pageControl;
    
}

-(UIView *)scrollBgView1{
    if (!_scrollBgView1) {
        _scrollBgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.chartScrollView.bounds.size.width-5, self.chartScrollView.bounds.size.height)];
        
    }
    return _scrollBgView1;
    
}

-(UIView *)scrollBgView2{
    if (!_scrollBgView2) {
        _scrollBgView2 = [[UIView alloc]initWithFrame:CGRectMake(self.chartScrollView.bounds.size.width, 0, self.chartScrollView.bounds.size.width-5, self.chartScrollView.bounds.size.height)];
        
    }
    return _scrollBgView2;
    
    
}


-(UIView *)bgView1{
    if (!_bgView1) {
        _bgView1 = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.chartScrollView.bounds.size.width-20, self.scrollBgView1.bounds.size.height-60)];
        _bgView1.layer.masksToBounds = YES;
        _bgView1.layer.cornerRadius = 5;
        _bgView1.layer.borderWidth = 1;
        //_bgView1.backgroundColor = [UIColor redColor];
        _bgView1.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor;
    }
    
    return _bgView1;
}

-(UIView *)bgView2{
    
    if (!_bgView2) {
        _bgView2 = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.chartScrollView.bounds.size.width-20, self.chartScrollView.bounds.size.height-60)];
        _bgView2.layer.cornerRadius = 5;
        _bgView2.layer.borderWidth = 1;
        //_bgView2.backgroundColor = [UIColor redColor];
        _bgView2.layer.borderWidth = 1;
        _bgView2.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor;
    }
    
    return _bgView2;
    
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        currentPage = 0;
        self.leftPointArr = [NSMutableArray array];
        self.rightPointArr = [NSMutableArray array];
        self.leftBtnArr = [NSMutableArray array];
        self.righttBtnArr = [NSMutableArray array];
        self.leftScaleArr = [NSArray array];
        self.leftScaleViewArr = [NSMutableArray array];
        self.rightScaleViewArr = [NSMutableArray array];
        [self addDetailViews];
    }
    
    return self;
    
    
}

//*******************数据源************************//

-(void)setLeftDataArr:(NSArray *)leftDataArr{

  [self addDataPointWith:self.scrollBgView1 andArr:leftDataArr];//添加点

  [self addLeftBezierPoint];//添加连线
    
    self.chartScrollView.scrollEnabled = NO;
    self.pageControl.numberOfPages = 1;
}


-(void)setRightDataArr:(NSArray *)rightDataArr{
    
     [self addDataPoint1With:self.scrollBgView2 andArr:rightDataArr];//添加点
    
    [self performSelector:@selector(addRightBezierPoint) withObject:nil afterDelay:4.8];//添加连线
    
    self.chartScrollView.scrollEnabled = YES;
    self.pageControl.numberOfPages = 2;
    
}

//*******************分割线************************//
-(void)addDetailViews{

    self.chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(30, 0, self.bounds.size.width-30, self.bounds.size.height)];
    self.chartScrollView.contentOffset = CGPointMake(0, 0);
    self.chartScrollView.backgroundColor = [UIColor clearColor];
    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.pagingEnabled = YES;
    self.chartScrollView.contentSize = CGSizeMake(self.bounds.size.width*2, 0);
    
    [self addSubview:self.chartScrollView];
    [self addSubview:self.pageControl];
    [self.chartScrollView addSubview:self.scrollBgView1];
    [self.chartScrollView addSubview:self.scrollBgView2];


    [self.scrollBgView1 addSubview:self.bgView1];
    
    [self.scrollBgView2 addSubview:self.bgView2];
    
    
    [self addLines1With:self.bgView1];
    [self addLines1With:self.bgView2];
    
    //添加左边数值
    [self addLeftViews];
    
    //添加底部月份
    [self addBottomViewsWith:self.scrollBgView1];
    [self addBottomViewsWith:self.scrollBgView2];
    

    
    
    //NSLog(@"%f",Xmargin);
   // NSLog(@"%f",Ymargin);
    
    
    

    
}


-(void)addDataPoint1With:(UIView *)view andArr:(NSArray *)rightArr{
    CGFloat height = self.bgView1.bounds.size.height;
    
    //插入左边最后一个点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:rightArr];
    [arr insertObject:[self.leftScaleArr lastObject] atIndex:0];
    
    
    for (int i = 0; i<arr.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Xmargin)*i, [arr[i] floatValue]* height, 12, 12)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor colorWithRed:0 green:122/255.0 blue:233/255.0 alpha:1].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[view addSubview:btn];
        
        [self.righttBtnArr addObject:btn];
        
        NSValue *point = [NSValue valueWithCGPoint:btn.center];
       // NSLog(@"%@",point);
        [self.rightPointArr addObject:point];
        
        
    }
   // CGRect *m = [[self.rightPointArr objectAtIndex:0] CGRectValue];
  //  NSLog(@"%@",m);
    

    
}

-(void)addRightBezierPoint{
    
    CGPoint point = [[self.rightPointArr objectAtIndex:0] CGPointValue];

    
    CGFloat lastY = point.y;
    
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:CGPointMake(5, lastY)];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:CGPointMake(5, lastY)];
    
    CGFloat bgViewHeight = self.bgView2.bounds.size.height;
    
    for (int i = 0;i<self.rightPointArr.count;i++ ) {
        if (i != 0) {
            
            CGPoint point = [[self.rightPointArr objectAtIndex:i] CGPointValue];
            [beizer addLineToPoint:point];
             [bezier1 addLineToPoint:point];
            if (i == self.leftPointArr.count-1) {
                
                    [beizer moveToPoint:point];//添加连线
                    lastPoint = point;
                    

            }
            
            
        }
        
        
        
    }
    
    
   
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(5, bgViewHeight)];
    
    [bezier1 addLineToPoint:CGPointMake(5, lastY)];
    
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    // [self.scrollBgView1.layer addSublayer:shadeLayer];
    
    //渐变图层
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.scrollBgView2.bounds.size.height-60);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:237/255.0 green:246/255.0 blue:253/255.0 alpha:0.5].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [self.scrollBgView2.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 3;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint.x, self.scrollBgView2.bounds.size.height-60)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];


    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithRed:0 green:120/255.0 blue:233/255.0 alpha:1].CGColor;
    shapeLayer.lineWidth = 2;
    [self.scrollBgView2.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 3.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];

    for (UIButton *btn in self.righttBtnArr) {
        [self.scrollBgView2 addSubview:btn];
    }
    
}

//添加左边的坐标线
-(void)addLeftBezierPoint{
    
    //取得起始点
    CGPoint p1 = [[self.leftPointArr objectAtIndex:0] CGPointValue];
    NSLog(@"%f %f",p1.x,p1.y);
    
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
  
    CGFloat bgViewHeight = self.bgView1.bounds.size.height;

    for (int i = 0;i<self.leftPointArr.count;i++ ) {
        if (i != 0) {
            
            CGPoint point = [[self.leftPointArr objectAtIndex:i] CGPointValue];
            [beizer addLineToPoint:point];
            
            [bezier1 addLineToPoint:point];
            
            if (i == self.leftPointArr.count-1) {
//                [beizer moveToPoint:point];//添加连线
//                lastPoint = point;
                
                if (self.leftDataArr.count == 7) {
                    [beizer moveToPoint:point];//添加连线
                    lastPoint = point;
                }else{
                    [beizer moveToPoint:CGPointMake(Xmargin * 6, bgViewHeight)];//添加连线
                    lastPoint = CGPointMake(Xmargin * 6, bgViewHeight);
                }
            }
            
            
        }
        
        
        
    }
    
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
   // [self.scrollBgView1.layer addSublayer:shadeLayer];
    
    //渐变图层
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.scrollBgView1.bounds.size.height-60);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:237/255.0 green:246/255.0 blue:253/255.0 alpha:0.5].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];

    [self.scrollBgView1.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 5.2;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint.x, self.scrollBgView1.bounds.size.height-60)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    

    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithRed:0 green:120/255.0 blue:233/255.0 alpha:1].CGColor;
    shapeLayer.lineWidth = 2;
    [self.scrollBgView1.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 5;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    for (UIButton *btn in self.leftBtnArr) {
        [self.scrollBgView1 addSubview:btn];
    }
    
    
}

-(void)addDataPointWith:(UIView *)view andArr:(NSArray *)leftData{
    
    self.leftScaleArr = leftData;
    
    CGFloat height = self.bgView1.bounds.size.height;
    
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:leftData];
    [arr insertObject:@"0.8" atIndex:0];

    CGFloat lineHeight = 0.5*height;//线的高度
   

    for (int i = 0; i<arr.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Xmargin)*i, [arr[i] floatValue]* height, 12, 12)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor colorWithRed:0 green:122/255.0 blue:233/255.0 alpha:1].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        if (i == 0) {
            firstBtn = btn;
        }
        [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[view addSubview:btn];
        
        UILabel *scaleLabel;//百分比
        UILabel *dateLabel;//日期
        UILabel *lineLabel;
        
      
        if (btn.frame.origin.y >= lineHeight) {//判断显示在上还是下面
//            scaleBgView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x,self.scrollBgView1.frame.size.height- btn.frame.origin.y-0.4*height, 20, 0.4*height)];
//            scaleBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
            
            
            //[self.leftScaleViewArr addObject:scaleBgView];

            
            
            
        }else{
            
            
            
        }
        

        [self.leftBtnArr addObject:btn];
        
        NSValue *point = [NSValue valueWithCGPoint:btn.center];
        [self.leftPointArr addObject:point];
        
        
    
    
    }
    
    
    
    
    
    
 
}


-(void)addLeftViews{
    
    NSArray *leftArr = @[@"5.00",@"4.00",@"3.00",@"2.00",@"1.00",@"0.00"];
    
    for (int i = 0;i<6 ;i++ ) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, i*(Ymargin-2)-10, 30, 30)];
        leftLabel.textColor = [UIColor grayColor];
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.text = leftArr[i];
        [self addSubview:leftLabel];
        
;
        
    }
    
    
    
}


-(void)addBottomViewsWith:(UIView *)UIView{
    
    NSArray *bottomArr;
    
    if (UIView == self.scrollBgView1) {
        bottomArr = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月"];

    }else{
        bottomArr = @[@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
 
    }
    
    for (int i = 0;i<6 ;i++ ) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(Xmargin+i*Xmargin-12, 5*Ymargin, 50, 30)];
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.text = bottomArr[i];
        leftLabel.textAlignment = 0;
        [UIView addSubview:leftLabel];
        
    }
    
    
    
}

-(void)clickTopBtn:(UIButton *)sender{
    sender.layer.borderColor = [UIColor colorWithRed:1 green:159/255.0 blue:106/255.0 alpha:1].CGColor;
    
    
    if (sender != firstBtn) {
        
        firstBtn.layer.borderColor = [UIColor colorWithRed:0 green:122/255.0 blue:233/255.0 alpha:1].CGColor;
        firstBtn = sender;
        
        
        
    }
    
    if (self.scaleBgView) {
        
        [self.scaleBgView removeFromSuperview];
        self.scaleBgView = [[UIView alloc]init];
        
    }else{
        
      self.scaleBgView = [[UIView alloc]init];
        
    }
    
    
        if (sender.tag >= 100) {
            [self.scrollBgView2  addSubview:self.scaleBgView];
        }else{
            [self.scrollBgView1  addSubview:self.scaleBgView];
        }
        
        
    
        
        CGFloat height = self.bgView1.bounds.size.height;
        CGFloat lineHeight = 0.5*height;
        if (sender.frame.origin.y<lineHeight) {
            
            if (sender.tag == 0 || sender.tag == 100) {
                
                [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(sender.mas_bottom).offset(0);
                    make.left.equalTo(sender.mas_centerX).offset(0);
                    make.height.mas_offset(lineHeight);
                    make.width.mas_offset(80);
                    
                    
                }];
                
                
                
            }else if (sender.tag == 6 || sender.tag == 106){
                
                [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(sender.mas_bottom).offset(0);
                    make.right.equalTo(sender.mas_centerX).offset(0);
                    make.height.mas_offset(lineHeight);
                    make.width.mas_offset(80);
                    
                    
                }];
                
                
            }else{
                [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(sender.mas_bottom).offset(0);
                    make.centerX.equalTo(sender.mas_centerX).offset(0);
                    make.height.mas_offset(lineHeight);
                    make.width.mas_offset(80);
                    
                    
                }];
                
            }
            
            
            [self.scaleBgView addSubview:self.scaleLabel];
            [self.scaleBgView addSubview:self.dateTimeLabel];
            [self.scaleBgView addSubview:self.lineLabel];
            
            [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
                make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                make.height.mas_equalTo(20);
                
            }];
            
            [self.scaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                make.bottom.equalTo(self.dateTimeLabel.mas_top).offset(0);
                make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                make.height.mas_equalTo(20);
                
            }];
            
            
            
            if (sender.tag == 0 || sender.tag == 100) {
                
                [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                    make.top.equalTo(self.scaleBgView.mas_top).offset(0);
                    make.bottom.equalTo(self.scaleLabel.mas_top).offset(0);
                    make.width.mas_equalTo(2);
                    
                }];
                
                
            }else if (sender.tag == 6 || sender.tag == 106){
                
                [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                    make.top.equalTo(self.scaleBgView.mas_top).offset(0);
                    make.bottom.equalTo(self.scaleLabel.mas_top).offset(0);
                    make.width.mas_equalTo(2);
                    
                }];
                
                
            }else{
                
                [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.scaleBgView.mas_centerX).offset(0);
                    make.top.equalTo(self.scaleBgView.mas_top).offset(0);
                    make.bottom.equalTo(self.scaleLabel.mas_top).offset(0);
                    make.width.mas_equalTo(2);
                    
                }];
                
                
            }

            

        }else{
            
            if (sender.tag == 0 || sender.tag == 100) {
                
                [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(sender.mas_top).offset(0);
                    make.left.equalTo(sender.mas_centerX).offset(0);
                    make.height.mas_offset(lineHeight);
                    make.width.mas_offset(80);
 
                }];
                
            }else if (sender.tag == 6 || sender.tag == 106){
                
                [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(sender.mas_top).offset(0);
                    make.right.equalTo(sender.mas_centerX).offset(0);
                    make.height.mas_offset(lineHeight);
                    make.width.mas_offset(80);
                    
                    
                }];
                
            }else{
                
                [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(sender.mas_top).offset(0);
                    make.centerX.equalTo(sender.mas_centerX).offset(0);
                    make.height.mas_offset(lineHeight);
                    make.width.mas_offset(80);
                    
                    
                }];
                
            }
            
            
            [self.scaleBgView addSubview:self.lineLabel];
            [self.scaleBgView addSubview:self.dateTimeLabel];
            [self.scaleBgView addSubview:self.scaleLabel];
            
            
            
            
            [self.scaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                make.top.equalTo(self.scaleBgView.mas_top).offset(0);
                make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                make.height.mas_equalTo(20);
                
            }];
            
            [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                make.top.equalTo(self.scaleLabel.mas_bottom).offset(0);
                make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                make.height.mas_equalTo(20);
                
            }];
            
            
            if (sender.tag == 0 || sender.tag == 100) {
                
                [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                    make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(0);
                    make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
                    make.width.mas_equalTo(2);
                    
                }];
                
                
            }else if (sender.tag == 6 || sender.tag == 106){
                
                [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                    make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(0);
                    make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
                    make.width.mas_equalTo(2);
                    
                }];
                
                
            }else{
                
                [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.scaleBgView.mas_centerX).offset(0);
                    make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(0);
                    make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
                    make.width.mas_equalTo(2);
                    
                }];
                
                
            }

            

        }
        

        
        
       
        
        
        
        
        
        
        
        


    

    
    
    

    
    
}
-(void)addLines1With:(UIView *)view{
    
    CGFloat magrginHeight = (view.bounds.size.height)/5;
    CGFloat labelWith = view.bounds.size.width;
    Ymargin = magrginHeight;
    
    for (int i = 0;i<4 ;i++ ) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, magrginHeight+magrginHeight*i, labelWith, 1)];
        
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        [view addSubview:label];
        
        
    }
    
    CGFloat marginWidth = view.bounds.size.width/6;
    Xmargin = marginWidth;
    CGFloat labelHeight = view.bounds.size.height;
    
    for (int i = 0;i<6 ;i++ ) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth*i, 0, 1, labelHeight)];
        
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
  
       
        if (i != 0) {
            [view addSubview:label];
        }
        
        
        
    }
    

    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    currentPage = scrollView.contentOffset.x/self.chartScrollView.bounds.size.width;
    self.pageControl.currentPage = currentPage;
 
    
}

@end
