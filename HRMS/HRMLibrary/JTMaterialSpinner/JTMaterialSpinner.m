//
//  JTMaterialSpinner.h
//  JTMaterialSpinner
//
//  Created by Jonathan Tribouharet
//

#import "JTMaterialSpinner.h"

@implementation JTMaterialSpinner

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    _pulse = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    _pulse.layer.cornerRadius = (CGRectGetWidth(frame))/2.0;
    _pulse.backgroundColor = [UIColor clearColor];
    _pulse.center = self.center;
    [self addSubview:_pulse];
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self->_circleLayer = [CAShapeLayer new];
    [self.layer addSublayer:_circleLayer];
    
    _circleLayer.fillColor = nil;
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.lineWidth = 2.5;
    
    _circleLayer.strokeColor = [UIColor orangeColor].CGColor;
    _circleLayer.strokeStart = 0;
    _circleLayer.strokeEnd = 0.5;

    self.isAnimating = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(!CGRectEqualToRect(self.circleLayer.frame, self.bounds)){
        [self updateCircleLayer];
    }
}

- (void)updateCircleLayer
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2., self.bounds.size.height / 2.);
    CGFloat radius = CGRectGetHeight(self.bounds) / 2. - self.circleLayer.lineWidth / 2;
    CGFloat startAngle = 0;
    CGFloat endAngle = 2 * M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    self.circleLayer.path = path.CGPath;
    self.circleLayer.frame = self.bounds;
}

- (void)forceBeginRefreshing
{
    self.isAnimating = NO;
    [self beginRefreshing];
}

- (void)beginRefreshing
{
    if(self.isAnimating){
        return;
    }
    
    self.isAnimating = YES;

    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.values = @[
                               @0,
                               @(M_PI),
                               @(2 * M_PI)
                               ];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1;
    headAnimation.fromValue = @0;
    headAnimation.toValue = @.25;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1;
    tailAnimation.fromValue = @0;
    tailAnimation.toValue = @1;
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1;
    endHeadAnimation.duration = 1;
    endHeadAnimation.fromValue = @.25;
    endHeadAnimation.toValue = @1;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1;
    endTailAnimation.duration = 1;
    endTailAnimation.fromValue = @1;
    endTailAnimation.toValue = @1;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.duration = 2;
    animations.animations = @[
                              rotateAnimation,
                              headAnimation,
                              tailAnimation,
                              endHeadAnimation,
                              endTailAnimation
                              ];
    animations.repeatCount = INFINITY;
        
    [self.circleLayer addAnimation:animations forKey:@"animations"];
}

- (void)beginRefreshingWithFader
{
    if(self.isAnimating){
        return;
    }
    
    self.isAnimating = YES;
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.values = @[
                               @0,
                               @(M_PI),
                               @(2 * M_PI)
                               ];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1;
    headAnimation.fromValue = @0;
    headAnimation.toValue = @.25;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1;
    tailAnimation.fromValue = @0;
    tailAnimation.toValue = @1;
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.;
    endHeadAnimation.duration = 1;
    endHeadAnimation.fromValue = @.25;
    endHeadAnimation.toValue = @1;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1;
    endTailAnimation.duration = 1;
    endTailAnimation.fromValue = @1;
    endTailAnimation.toValue = @1;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.duration = 2;
    animations.animations = @[
                              rotateAnimation,
                              headAnimation,
                              tailAnimation,
                              endHeadAnimation,
                              endTailAnimation
                              ];
    animations.repeatCount = INFINITY;
    
    [self.circleLayer addAnimation:animations forKey:@"animations"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animation];
    fadeAnimation.keyPath = @"opacity";
    fadeAnimation.duration = 2;
    fadeAnimation.fromValue = @1;
    fadeAnimation.toValue = @0;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.duration = 2;
    scaleAnimation.fromValue = @0;
    scaleAnimation.toValue = @1;
    
    CAAnimationGroup *animationsFader = [CAAnimationGroup animation];
    animationsFader.duration = 2;
    animationsFader.animations = @[
                                   fadeAnimation,
                                   scaleAnimation
                                   ];
    animationsFader.repeatCount = INFINITY;
    animationsFader.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [_pulse.layer addAnimation:animationsFader forKey:@"fader"];
    
    __weak typeof(self) wSelf = self;
    
    [self setBlockComplete:^(BOOL success) {
       
            wSelf.isAnimating = NO;
            [wSelf.circleLayer removeAnimationForKey:@"animations"];
            [wSelf.pulse.layer removeAnimationForKey:@"fader"];
            [wSelf.circleLayer removeFromSuperlayer];
            
            CAShapeLayer *tickLine = [CAShapeLayer new];
            [wSelf.pulse.layer addSublayer:tickLine];
            tickLine.lineCap = kCALineCapRound;
            tickLine.lineWidth = 2.0;
            tickLine.fillColor = [UIColor clearColor].CGColor;
            tickLine.strokeColor = [UIColor whiteColor].CGColor;
            tickLine.strokeStart = 0.0;
            tickLine.strokeEnd = 1.0;
        
            if (success) {
                wSelf.pulse.backgroundColor = kFlatGreen;
                // Tick Mark
                UIBezierPath *path = [[UIBezierPath alloc] init];
                if (IS_IPAD) {
                    [path moveToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+8, CGRectGetMidY(wSelf.pulse.bounds))];
                    [path addLineToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+17, CGRectGetMidY(wSelf.pulse.bounds)+14)];
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(wSelf.pulse.bounds)-7, CGRectGetMidY(wSelf.pulse.bounds)-7)];
                }else{
                    [path moveToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+5, CGRectGetMidY(wSelf.pulse.bounds))];
                    [path addLineToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+10, CGRectGetMidY(wSelf.pulse.bounds)+6)];
                    [path addLineToPoint:CGPointMake(CGRectGetMaxX(wSelf.pulse.bounds)-5, CGRectGetMidY(wSelf.pulse.bounds)-5)];
                }
                [[UIColor whiteColor] setStroke];
                [path stroke];
                [[UIColor clearColor] setFill];
                tickLine.path = path.CGPath;
                tickLine.frame = wSelf.pulse.bounds;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(wSelf.restore)
                        wSelf.restore(NO);
                });
            }else{
                wSelf.pulse.backgroundColor = kFlatRed;
                // Cross Mark
                UIBezierPath *crossPath = [[UIBezierPath alloc] init];
                if (IS_IPAD) {
                    [crossPath moveToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+13, CGRectGetMinY(wSelf.pulse.bounds)+13)];
                    [crossPath addLineToPoint:CGPointMake(CGRectGetMaxX(wSelf.pulse.bounds)-13, CGRectGetMaxY(wSelf.pulse.bounds)-13)];
                    [crossPath moveToPoint:CGPointMake(CGRectGetMaxX(wSelf.pulse.bounds)-13, CGRectGetMinY(wSelf.pulse.bounds)+13)];
                    [crossPath addLineToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+13, CGRectGetMaxY(wSelf.pulse.bounds)-13)];
                }else{
                    [crossPath moveToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+7, CGRectGetMinY(wSelf.pulse.bounds)+7)];
                    [crossPath addLineToPoint:CGPointMake(CGRectGetMaxX(wSelf.pulse.bounds)-7, CGRectGetMaxY(wSelf.pulse.bounds)-7)];
                    [crossPath moveToPoint:CGPointMake(CGRectGetMaxX(wSelf.pulse.bounds)-7, CGRectGetMinY(wSelf.pulse.bounds)+7)];
                    [crossPath addLineToPoint:CGPointMake(CGRectGetMinX(wSelf.pulse.bounds)+7, CGRectGetMaxY(wSelf.pulse.bounds)-7)];
                }
                [[UIColor whiteColor] setStroke];
                [crossPath stroke];
                tickLine.path = crossPath.CGPath;
                tickLine.frame = wSelf.pulse.bounds;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(wSelf.restore)
                        wSelf.restore(YES);
                    [wSelf removeFromSuperview];
                });
            }
        
            CABasicAnimation *tickAnimate = [CABasicAnimation animation];
            tickAnimate.keyPath = @"strokeEnd";
            tickAnimate.duration = 0.3;
            tickAnimate.fromValue = @0;
            tickAnimate.toValue = @1;
            [tickLine addAnimation:tickAnimate forKey:@"tickAnimate"];
    }];
}

- (void)endRefreshing
{
    self.isAnimating = NO;
    [self.circleLayer removeAnimationForKey:@"animations"];
}

@end
