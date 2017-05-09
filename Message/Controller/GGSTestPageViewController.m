//
//  GGSTestPageViewController.m
//  GGSPlantform
//
//  Created by min zhang on 2017/2/14.
//  Copyright © 2017年 zhangmin. All rights reserved.
//

#import "GGSTestPageViewController.h"

#import "GGSEmoticonView.h"
#import <ImageIO/ImageIO.h>


@interface GGSTestPageViewController ()
<GGSEmoticonDelegate>

//@property (nonatomic, strong) NSMutableArray <NSString *>*bottomEmoticonArray;
//@property (nonatomic, strong) NSMutableArray <NSString *>*emoticonArray;
//
//@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UIImageView *testImageView;
/** 卡尔动画图片 */
@property (nonatomic, strong) UIImageView *carlImageView;

/** 球1 */
@property (nonatomic, strong) UIImageView *firballView;
/** 球2 */
@property (nonatomic, strong) UIImageView *secballView;
/** 球3 */
@property (nonatomic, strong) UIImageView *thrballView;

@property (nonatomic, strong) UIView *backContainView;
/** x 方向点的集合 */
@property (nonatomic, strong) NSMutableArray *xDirectSetArray;
/** y 方向点的集合 */
@property (nonatomic, strong) NSMutableArray *yDirectSetArray;
/** 已添加的点的坐标 */
@property (nonatomic, strong) NSMutableDictionary *addedRectOriginDictionary;
/** 添加图片的定时器 */
@property (nonatomic, strong) NSTimer *addImageViewTimer;
/** 图片十足 */
@property (nonatomic, strong) NSMutableArray *ballImageNamesArray;

@end

@implementation GGSTestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backContainView];
    __weak typeof(self) weakSelf = self;
    [_backContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    // 背景图
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"ggs_playsoon_back"];
    [_backContainView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backContainView);
    }];
    
    
    [self.view addSubview:self.carlImageView];
    
    [self.view addSubview:self.firballView];
    [self.view addSubview:self.secballView];
    [self.view addSubview:self.thrballView];
    [self.view addSubview:self.testImageView];

    self.carlImageView.frame = CGRectMake((SCREEN_WIDTH - 202)/2.0, (SCREEN_HEIGHT - 64 - 30 - 181)/2.0, 202, 181);
    self.testImageView.frame = CGRectMake((SCREEN_WIDTH - 120)/2.0, (SCREEN_HEIGHT - 64 - 30 - 200)/2.0 + 80, 120, 120);
    self.firballView.frame = CGRectMake((SCREEN_WIDTH - 120)/2.0 + 60 - 25, (SCREEN_HEIGHT - 64 - 30 - 200)/2.0 + 80 + 60-20, 50, 50);
    self.secballView.frame = CGRectMake((SCREEN_WIDTH - 120)/2.0 - 60, (SCREEN_HEIGHT - 64 - 30 - 200)/2.0 + 80, 50, 50);
    self.thrballView.frame = CGRectMake((SCREEN_WIDTH - 120)/2.0 + 60 + 70, (SCREEN_HEIGHT - 64 - 30 - 200)/2.0 + 80, 50, 50);
    
    NSMutableArray <UIImage *> *imagesArray = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ggs_carl%d", (i + 1)]];
        [imagesArray addObject:image];
    }
    
    self.carlImageView.animationImages = imagesArray;
    self.carlImageView.animationDuration = 2.f;
    [self.carlImageView startAnimating];

//    // 创建路径
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:CGPointMake((SCREEN_WIDTH - 200)/2.0 + 100 - 25 + 25 , (SCREEN_HEIGHT - 200)/2.0 + 200 + 25)];
//    [bezierPath addQuadCurveToPoint:CGPointMake((SCREEN_WIDTH - 200)/2.0 + 100 + 100 + 50 + 25, (SCREEN_HEIGHT - 200)/2.0 + 100 + 25) controlPoint:CGPointMake((SCREEN_WIDTH - 200)/2.0 + 100 - 25 + 25 + 87.5, (SCREEN_HEIGHT - 200)/2.0 + 200 + 25 - 50 + 25)];
//    [bezierPath addLineToPoint:CGPointMake((SCREEN_WIDTH - 200)/2.0 + 100 - 25 + 25 + 87.5, (SCREEN_HEIGHT - 200)/2.0 + 200 + 25 - 50)];
    
//    [bezierPath addArcWithCenter:CGPointMake((SCREEN_WIDTH - 200)/2.0 + 100, (SCREEN_HEIGHT - 200)/2.0 + 100) radius:100 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
//    
//    CAShapeLayer *pathLayer = [CAShapeLayer layer];
//    pathLayer.path = bezierPath.CGPath;// 绘制路径
//    pathLayer.strokeColor = [UIColor grayColor].CGColor;// 轨迹颜色
//    pathLayer.fillColor = [UIColor yellowColor].CGColor;// 填充颜色
//    pathLayer.lineWidth = 5.0f; // 线宽
//    
//    
//    [self.view.layer addSublayer:pathLayer];
//    
//    UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
//    [bezierPath1 moveToPoint:self.thrballView.center];
//    [bezierPath1 addQuadCurveToPoint:self.secballView.center controlPoint:CGPointMake((self.thrballView.centerX - self.secballView.centerX)/2.0 + self.secballView.centerX, self.thrballView.centerY - 80)];
//
//    
//    CAShapeLayer *pathLayer1 = [CAShapeLayer layer];
//    pathLayer1.path = bezierPath1.CGPath;// 绘制路径
//    pathLayer1.strokeColor = [UIColor blackColor].CGColor;// 轨迹颜色
//    pathLayer1.fillColor = [UIColor yellowColor].CGColor;// 填充颜色
//    pathLayer1.lineWidth = 5.0f; // 线宽
//    
//    
//    [self.view.layer addSublayer:pathLayer1];
//    
//    UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
//    [bezierPath2 moveToPoint:self.secballView.center];
//    [bezierPath2 addQuadCurveToPoint:self.firballView.center controlPoint:CGPointMake((self.firballView.centerX - self.secballView.centerX)/2.0 + self.secballView.centerX, (self.firballView.centerY - self.secballView.centerY)/2.0 + self.secballView.centerY + 50)];
//    
//    CAShapeLayer *pathLayer2 = [CAShapeLayer layer];
//    pathLayer2.path = bezierPath2.CGPath;// 绘制路径
//    pathLayer2.strokeColor = [UIColor orangeColor].CGColor;// 轨迹颜色
//    pathLayer2.fillColor = [UIColor yellowColor].CGColor;// 填充颜色
//    pathLayer2.lineWidth = 5.0f; // 线宽
//    
//    
//    [self.view.layer addSublayer:pathLayer2];
//    
//    bezierPath.lineJoinStyle = kCGLineJoinRound;
//    bezierPath.lineCapStyle = kCGLineCapRound;
//    bezierPath1.lineJoinStyle = kCGLineJoinRound;
//    bezierPath1.lineCapStyle = kCGLineCapRound;
//    bezierPath2.lineJoinStyle = kCGLineJoinRound;
//    bezierPath2.lineCapStyle = kCGLineCapRound;
//    
//    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pathAnimation.calculationMode = kCAAnimationPaced;// 我理解为节奏
//    pathAnimation.fillMode = kCAFillModeForwards;
//    pathAnimation.path = bezierPath.CGPath;
//    pathAnimation.removedOnCompletion = NO;// 是否在动画完成后从 Layer 层上移除  回到最开始状态
//    pathAnimation.duration = 3.0f;// 动画时间
//    pathAnimation.repeatCount = 100;// 动画重复次数
    

    
    UIBezierPath *bezierPath11 = [UIBezierPath bezierPath];
    [bezierPath11 moveToPoint:self.secballView.center];
    [bezierPath11 addQuadCurveToPoint:self.thrballView.center controlPoint:CGPointMake(self.firballView.centerX, self.firballView.centerY + 20)];
    [bezierPath11 addQuadCurveToPoint:self.secballView.center controlPoint:CGPointMake(self.firballView.centerX, self.firballView.centerY - 200)];
    
    CAShapeLayer *pathLayer2 = [CAShapeLayer layer];
    pathLayer2.path = bezierPath11.CGPath;// 绘制路径
    pathLayer2.strokeColor = [UIColor orangeColor].CGColor;// 轨迹颜色
    pathLayer2.fillColor = [UIColor clearColor].CGColor;// 填充颜色
    pathLayer2.lineWidth = 5.0f; // 线宽
    
    
//    [self.view.layer addSublayer:pathLayer2];
    
    bezierPath11.lineJoinStyle = kCGLineJoinRound;
    bezierPath11.lineCapStyle = kCGLineCapRound;
    
    CAKeyframeAnimation *pathAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation1.calculationMode = kCAAnimationPaced;// 我理解为节奏
    pathAnimation1.fillMode = kCAFillModeForwards;
    pathAnimation1.path = bezierPath11.CGPath;
    pathAnimation1.removedOnCompletion = NO;// 是否在动画完成后从 Layer 层上移除  回到最开始状态
    pathAnimation1.duration = 3.0f;// 动画时间
    pathAnimation1.repeatCount = CGFLOAT_MAX;// 动画重复次数
    
    UIBezierPath *bezierPath12 = [UIBezierPath bezierPath];
    [bezierPath12 moveToPoint:self.firballView.center];
    [bezierPath12 addQuadCurveToPoint:self.thrballView.center controlPoint:CGPointMake((self.thrballView.centerX - self.firballView.centerX)/2.0 + self.firballView.centerX, (self.firballView.centerY - self.thrballView.centerY)/2.0 + self.thrballView.centerY + 15)];
    [bezierPath12 addQuadCurveToPoint:self.secballView.center controlPoint:CGPointMake(self.firballView.centerX, self.firballView.centerY - 200)];
    [bezierPath12 addQuadCurveToPoint:self.firballView.center controlPoint:CGPointMake((self.firballView.centerX - self.secballView.centerX)/2.0 + self.secballView.centerX, (self.firballView.centerY - self.secballView.centerY)/2.0 + self.secballView.centerY + 15)];
    
    CAShapeLayer *pathLayer3 = [CAShapeLayer layer];
    pathLayer3.path = bezierPath12.CGPath;// 绘制路径
    pathLayer3.strokeColor = [UIColor yellowColor].CGColor;// 轨迹颜色
    pathLayer3.fillColor = [UIColor clearColor].CGColor;// 填充颜色
    pathLayer3.lineWidth = 5.0f; // 线宽
    
    
//    [self.view.layer addSublayer:pathLayer3];
    
    bezierPath12.lineJoinStyle = kCGLineJoinRound;
    bezierPath12.lineCapStyle = kCGLineCapRound;
    
    CAKeyframeAnimation *pathAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation2.calculationMode = kCAAnimationPaced;// 我理解为节奏
    pathAnimation2.fillMode = kCAFillModeForwards;
    pathAnimation2.path = bezierPath12.CGPath;
    pathAnimation2.removedOnCompletion = NO;// 是否在动画完成后从 Layer 层上移除  回到最开始状态
    pathAnimation2.duration = 3.0f;// 动画时间
    pathAnimation2.repeatCount = CGFLOAT_MAX;// 动画重复次数
    
    UIBezierPath *bezierPath13 = [UIBezierPath bezierPath];
    [bezierPath13 moveToPoint:self.thrballView.center];
    [bezierPath13 addQuadCurveToPoint:self.secballView.center controlPoint:CGPointMake(self.secballView.centerX + (self.thrballView.centerX - self.secballView.centerX)/2.0, self.firballView.centerY - 200)];
    [bezierPath13 addQuadCurveToPoint:self.thrballView.center controlPoint:CGPointMake(self.firballView.centerX, self.firballView.centerY + 20)];
    
    CAShapeLayer *pathLayer4 = [CAShapeLayer layer];
    pathLayer4.path = bezierPath13.CGPath;// 绘制路径
    pathLayer4.strokeColor = [UIColor orangeColor].CGColor;// 轨迹颜色
    pathLayer4.fillColor = [UIColor clearColor].CGColor;// 填充颜色
    pathLayer4.lineWidth = 5.0f; // 线宽
    
    
//    [self.view.layer addSublayer:pathLayer4];
    

    
    CAKeyframeAnimation *pathAnimation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation3.calculationMode = kCAAnimationPaced;// 我理解为节奏
    pathAnimation3.fillMode = kCAFillModeForwards;
    pathAnimation3.path = bezierPath13.CGPath;
    pathAnimation3.removedOnCompletion = NO;// 是否在动画完成后从 Layer 层上移除  回到最开始状态
    pathAnimation3.duration = 3.0f;// 动画时间
    pathAnimation3.repeatCount = CGFLOAT_MAX;// 动画重复次数
    
//    bezierPath1.lineJoinStyle = kCGLineJoinRound;
//    bezierPath1.lineCapStyle = kCGLineCapRound;
//    bezierPath2.lineJoinStyle = kCGLineJoinRound;
//    bezierPath2.lineCapStyle = kCGLineCapRound;
    
    bezierPath11.lineJoinStyle = kCGLineJoinRound;
    bezierPath11.lineCapStyle = kCGLineCapRound;
    bezierPath12.lineJoinStyle = kCGLineJoinRound;
    bezierPath12.lineCapStyle = kCGLineCapRound;
    bezierPath13.lineJoinStyle = kCGLineJoinRound;
    bezierPath13.lineCapStyle = kCGLineCapRound;
    
    [bezierPath11 stroke];
    [bezierPath11 closePath];
    [bezierPath12 stroke];
    [bezierPath12 closePath];
    [bezierPath13 stroke];
    [bezierPath13 closePath];
    

    
//    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pathAnimation.calculationMode = kCAAnimationPaced;// 我理解为节奏
//    pathAnimation.fillMode = kCAFillModeForwards;
//    pathAnimation.path = bezierPath.CGPath;
//    
//    pathAnimation.removedOnCompletion = NO;// 是否在动画完成后从 Layer 层上移除  回到最开始状态
//    pathAnimation.duration = 1.5f;// 动画时间
//    pathAnimation.repeatCount = 100;// 动画重复次数
    
    
    
//    [self.view addSubview:basketball]; // 添加篮球
    [_firballView.layer addAnimation:pathAnimation2 forKey:nil];// 添加动画
    [_secballView.layer addAnimation:pathAnimation1 forKey:nil];// 添加动画
    [_thrballView.layer addAnimation:pathAnimation3 forKey:nil];// 添加动画
    
    // 大球上下移动动画
    UIBezierPath *bezierPath14 = [UIBezierPath bezierPath];
    [bezierPath14 moveToPoint:self.testImageView.center];
    [bezierPath14 addLineToPoint:CGPointMake(self.testImageView.centerX, self.testImageView.centerY - 15)];
    [bezierPath14 addLineToPoint:self.testImageView.center];
    [bezierPath14 closePath];


    
    CAShapeLayer *pathLayer14 = [CAShapeLayer layer];
    pathLayer14.path = bezierPath14.CGPath;// 绘制路径
    pathLayer14.strokeColor = [UIColor orangeColor].CGColor;// 轨迹颜色
    pathLayer14.fillColor = [UIColor clearColor].CGColor;// 填充颜色
    pathLayer14.lineWidth = 5.0f; // 线宽
    
    
    //    [self.view.layer addSublayer:pathLayer2];
    
    bezierPath14.lineJoinStyle = kCGLineJoinRound;
    bezierPath14.lineCapStyle = kCGLineCapRound;
    
    CAKeyframeAnimation *pathAnimation14 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation14.calculationMode = kCAAnimationPaced;// 我理解为节奏
    pathAnimation14.fillMode = kCAFillModeForwards;
    pathAnimation14.path = bezierPath14.CGPath;
    pathAnimation14.removedOnCompletion = NO;// 是否在动画完成后从 Layer 层上移除  回到最开始状态
    pathAnimation14.duration = 4.5f;// 动画时间
    pathAnimation14.repeatCount = CGFLOAT_MAX;// 动画重复次数

    [self.testImageView.layer addAnimation:pathAnimation14 forKey:nil];
    
//    [self.view.layer addSublayer:pathLayer];// 绘制的轨迹


    // Do any additional SetArrayup after loading the view.
    
//    self.view.backgroundColor = HEXCOLOR(0xcccccc);
    
//    GGSEmoticonView *view = [[GGSEmoticonView alloc] initWithFrame:CGRectZero delegate:self  bottomEmotionArray:self.bottomEmoticonArray];
//    [self.view addSubview:view];
//    [self.view addSubview:self.centerImageView];
//    
//    view.backgroundColor = kBACKGROUND_COLOR;
//    
//    view.sd_layout.
//    leftEqualToView(self.view)
//    .bottomEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .heightIs(250);
//    
//    _centerImageView.sd_layout
//    .topEqualToView(self.view)
//    .leftEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .heightIs(200);
    
    

    
    [self addImageViewTimer];
    
}

- (void)addPointToBackContinerView {
    
    NSInteger xCount = arc4random()%(self.xDirectSetArray.count);
    NSInteger beginX = ([self.xDirectSetArray[xCount] integerValue]) * 30 + (30 / (self.xDirectSetArray.count * 1.0));
    
    NSInteger yCount = arc4random()%(self.yDirectSetArray.count);
    NSInteger beginY = ([self.yDirectSetArray[yCount] integerValue]) * 30 +  + (30 / (self.yDirectSetArray.count * 1.0));
    
    // 添加不重复的点
    CGPoint begin = CGPointMake(beginX, beginY);
    NSString *beginKey = NSStringFromCGPoint(begin);
    if (self.addedRectOriginDictionary[beginKey] == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(beginX, beginY, 30, 30);
        NSInteger index = arc4random()%self.ballImageNamesArray.count;
        imageView.image = [UIImage imageNamed:self.ballImageNamesArray[index]];
        [self.backContainView addSubview:imageView];
        self.addedRectOriginDictionary[beginKey] = NSStringFromCGRect(imageView.frame);
    }
    
    // 当添加的点的个数大于20时 随机移除点
    if (self.addedRectOriginDictionary.allKeys.count > 20) {
        NSInteger subViewindex = arc4random() % (self.backContainView.subviews.count);
        UIView *subView = self.backContainView.subviews[subViewindex];
        CGRect rect = subView.frame;
        if ([NSStringFromCGRect(rect) isEqualToString:NSStringFromCGRect(self.backContainView.frame)] == NO) {
            [subView removeFromSuperview];
            // 移除点的坐标
            NSString *removeKey = NSStringFromCGPoint(subView.frame.origin);
            if (self.addedRectOriginDictionary[removeKey] != nil) {
                [self.addedRectOriginDictionary removeObjectForKey:removeKey];
            }
        }
    }
}

//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//
//}
//
//#pragma mark - GGSEmoticonDelegate
//- (void)emotiocnView:(GGSEmoticonView *)emoticonView didClickedItemAtIndex:(NSInteger)index {
//    NSString *emoticon = self.emoticonArray[index];
//    
//    if ([emoticon hasSuffix:@".gif"]) {
//        NSString *name = [emoticon stringByReplacingOccurrencesOfString:@".gif" withString:@""];
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@".gif"];
//        // 获取gif数据
//        CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], NULL);
//        // 获取gif文件个数
//        size_t count = CGImageSourceGetCount(source);
//        // gif 播放完整一次所需事件
//        CGFloat allTime = 0;
//        // 获取git 所有图片的数组
//        NSMutableArray *allImagesArray = [NSMutableArray array];
//        // 遍历GIF 图片
//        for (size_t i = 0; i < count; i++) {
//            CGImageRef imageItem = CGImageSourceCreateImageAtIndex(source, i, NULL);
//            UIImage *needImage = [UIImage imageWithCGImage:imageItem];
//            [allImagesArray addObject:needImage];
//            
//            // 获取图片信息
//            NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
//            
//            // 统计动画所需事件
//            NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)(kCGImagePropertyGIFDictionary)];
//            CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
//            
//            allTime += time;
//        }
//        
//        self.centerImageView.animationImages = allImagesArray;
//        self.centerImageView.animationDuration = allTime;
//        [self.centerImageView startAnimating];
//    }
//}
//

#pragma mark - PrivateMethod
- (void)p_addTimer {
    [self.addImageViewTimer fire];
}

- (void)p_stopTimer {
    [self.addImageViewTimer invalidate];
    _addImageViewTimer = nil;
}

#pragma mark - Getter
- (UIImageView *)carlImageView {
    if (_carlImageView == nil) {
        _carlImageView = [[UIImageView alloc] init];
    }
    return _carlImageView;
}

- (UIImageView *)testImageView {
    if (_testImageView == nil) {
        _testImageView = [[UIImageView alloc] init];
//        _testImageView.backgroundColor = [UIColor brownColor];
        _testImageView.image = [UIImage imageNamed:@"ggs_playsoon_bottomball"];
    }
    return _testImageView;
}

- (UIImageView *)firballView {
    if (_firballView == nil) {
        _firballView = [[UIImageView alloc] init];
//        _firballView.backgroundColor = [UIColor redColor];
        _firballView.image = [UIImage imageNamed:@"ggs_purpleball"];
    }
    return _firballView;
}

- (UIImageView *)secballView {
    if (_secballView == nil) {
        _secballView = [[UIImageView alloc] init];
//        _secballView.backgroundColor = [UIColor greenColor];
        _secballView.image = [UIImage imageNamed:@"ggs_blueball"];
    }
    return _secballView;
}

- (UIImageView *)thrballView {
    if (_thrballView == nil) {
        _thrballView = [[UIImageView alloc] init];
//        _thrballView.backgroundColor = [UIColor blueColor];
        _thrballView.image = [UIImage imageNamed:@"ggs_yellowball"];
    }
    return _thrballView;
}

- (UIView *)backContainView {
    if (_backContainView == nil) {
        _backContainView = [[UIView alloc] init];
    }
    return _backContainView;
}

- (NSMutableArray *)xDirectSetArray {
    if (_xDirectSetArray == nil) {
        _xDirectSetArray = [NSMutableArray array];
        NSInteger xCount = ((SCREEN_WIDTH - 30) / 30);
        for (int i = 0; i < xCount; i++) {
            [_xDirectSetArray addObject:@(i)];
        }
    }
    return _xDirectSetArray;
}

- (NSMutableArray *)yDirectSetArray {
    if (_yDirectSetArray == nil) {
        _yDirectSetArray = [NSMutableArray array];
        NSInteger yCount = ((SCREEN_HEIGHT - 30) / 30);
        for (int i = 0; i < yCount; i++) {
            [_yDirectSetArray addObject:@(i)];
        }
    }
    return _yDirectSetArray;
}

- (NSMutableDictionary *)addedRectOriginDictionary {
    if (_addedRectOriginDictionary == nil) {
        _addedRectOriginDictionary = [NSMutableDictionary dictionary];
    }
    return _addedRectOriginDictionary;
}

- (NSTimer *)addImageViewTimer {
    if (_addImageViewTimer == nil) {
        _addImageViewTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(addPointToBackContinerView) userInfo:nil repeats:YES];
    }
    return _addImageViewTimer;
}

- (NSMutableArray *)ballImageNamesArray {
    if (_ballImageNamesArray == nil) {
        _ballImageNamesArray = [NSMutableArray array];
        [_ballImageNamesArray addObjectsFromArray:@[@"ggs_purpleball",
                                                    @"ggs_blueball",
                                                    @"ggs_yellowball"]];
    }
    return _ballImageNamesArray;
}

//- (UIImageView *)centerImageView {
//    if (_centerImageView == nil) {
//        _centerImageView = [[UIImageView alloc] init];
//        _centerImageView.contentMode = UIViewContentModeCenter;
//    }
//    return _centerImageView;
//}
//
////@property (nonatomic, strong) NSMutableArray <NSString *>*bottomEmoticonArray;
////@property (nonatomic, strong) NSMutableArray <NSString *>*emoticonArray;
//
//- (NSMutableArray<NSString *> *)bottomEmoticonArray {
//    if (_bottomEmoticonArray == nil) {
//        _bottomEmoticonArray = [NSMutableArray array];
//
//        [_bottomEmoticonArray addObjectsFromArray:@[
//                                                    @"ggs_test_emoticon",
//                                                    @"ggs_test_emoticon"
//                                                    ]];
//    }
//    return _bottomEmoticonArray;
//}
//
//- (NSMutableArray <NSString *> *)emoticonArray {
//    if (_emoticonArray == nil) {
//        _emoticonArray = [NSMutableArray array];
//        [_emoticonArray addObjectsFromArray:@[
//                                              @"aegis2015.gif",
//                                              @"axe_laugh.gif",
//                                              @"bc_flex.gif",
//                                              @"bc_frog.gif",
//                                              @"bc_ok.gif",
//                                              @"blink.gif",
//                                              @"blush.gif",
//                                              @"bts_bristle.gif",
//                                              @"bts_godz.gif",
//                                              @"bts_lina.gif",
//                                              @"bts_merlini.gif",
//                                              @"bts_rosh.gif",
//                                              @"burn.gif",
//                                              @"charm_cheeky.gif",
//                                              @"charm_cool.gif",
//                                              @"charm_crazy.gif",
//                                              @"charm_disapprove.gif",
//                                              @"charm_facepalm.gif",
//                                              @"charm_happytears.gif",
//                                              @"charm_highfive.gif",
//                                              @"charm_huh.gif",
//                                              @"charm_hush.gif",
//                                              @"charm_laugh.gif",
//                                              @"charm_onlooker.gif",
//                                              @"charm_rage.gif",
//                                              @"charm_sad.gif",
//                                              @"charm_sick.gif",
//                                              @"charm_smile.gif",
//                                              @"charm_surprise.gif",
//                                              @"charm_wink.gif",
//                                              @"cheeky.gif",
//                                              @"cocky.gif",
//                                              @"crazy.gif",
//                                              @"cry.gif",
//                                              @"dac15_angry.gif",
//                                              @"dac15_blush.gif",
//                                              @"dac15_cool.gif",
//                                              @"dac15_face.gif",
//                                              @"dac15_fade.gif",
//                                              @"dac15_frog.gif",
//                                              @"dac15_nosewipe.gif",
//                                              @"dac15_sad.gif",
//                                              @"dac15_stab.gif",
//                                              @"dac15_surprise.gif",
//                                              @"dac15_tired.gif",
//                                              @"dac15_transform.gif",
//                                              @"dac15_water.gif",
//                                              @"dead_eyes.gif",
//                                              @"devil.gif",
//                                              @"disappear.gif",
//                                              @"disapprove.gif",
//                                              @"drunk.gif",
//                                              @"eyeroll.gif",
//                                              @"facepalm.gif",
//                                              @"fail.gif",
//                                              @"fire.gif",
//                                              @"fuming.gif",
//                                              @"ggdire.gif",
//                                              @"ggradiant.gif",
//                                              @"goodjob.gif",
//                                              @"gross.gif",
//                                              @"happy.gif",
//                                              @"happytears.gif",
//                                              @"healed.gif",
//                                              @"hex_ti6_charm.gif",
//                                              @"highfive.gif",
//                                              @"huh.gif",
//                                              @"hush.gif",
//                                              @"laugh.gif",
//                                              @"luna_love.gif",
//                                              @"money.gif",
//                                              @"monkey_king_ti6_charm.gif",
//                                              @"naga_song.gif",
//                                              @"nervous.gif",
//                                              @"pa_kiss.gif",
//                                              @"poop.gif",
//                                              @"rage.gif",
//                                              @"sick.gif",
//                                              @"smile.gif",
//                                              @"snowman.gif",
//                                              @"stunned.gif",
//                                              @"surprise_blush.gif",
//                                              @"surprise.gif",
//                                              @"tear.gif",
//                                              @"techies.gif",
//                                              @"thinking.gif",
//                                              @"throwgame.gif",
//                                              @"wink.gif",
//                                              @"wrath.gif",
//                                              @"yolo.gif",
//                                              @"zipper.gif"
//                                              ]];
//        if ((_emoticonArray.count % kEachPageCount) != 0) {
//            NSInteger needAddItemCount = kEachPageCount * (_emoticonArray.count / kEachPageCount + 1) - _emoticonArray.count;
//            for (int i = 0; i < needAddItemCount; i++) {
//                [_emoticonArray addObject:@""];
//                
//            }
//        }
//    }
//    return _emoticonArray;
//}

@end
