//
//  LTImageScrollView.m
//  LTScrollViewDemo
//
//  Created by yelon on 16/5/2.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTImageScrollView.h"
#import "LTImageView.h"

@interface LTImageScrollView ()<UIScrollViewDelegate,CAAction>{

    NSInteger pagesCount;
    NSInteger _centerPageIndex;
    BOOL changeCurrentAnimate;
}

@property (nonatomic,strong) LTImageView *leftImageV;
@property (nonatomic,strong) LTImageView *centerImageV;
@property (nonatomic,strong) LTImageView *rightImageV;

@property (nonatomic,assign) NSInteger leftPageIndex;
@property (nonatomic,assign) NSInteger centerPageIndex;
@property (nonatomic,assign) NSInteger rightPageIndex;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation LTImageScrollView
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPageIndex = _centerPageIndex;

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    
    if (self = [super initWithCoder:coder]) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    self.scrollView.frame = self.bounds;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_scrollView];
    
    [_scrollView addSubview:self.centerImageV];
    [_scrollView addSubview:self.leftImageV];
    [_scrollView addSubview:self.rightImageV];
    
    self.scrollDuration = 2.0;
    [self addSubview:self.pageControl];
    [self addPageControlLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleStatusBarOrientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil
     ];
    [self lt_reloadContents];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    //    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    
    if (pagesCount>1) {
        
        self.scrollView.scrollEnabled = YES;
        [self.scrollView setContentSize:CGSizeMake(width*3, 0)];
    }
    else{
        
        self.scrollView.scrollEnabled = NO;
        [self.scrollView setContentSize:CGSizeMake(width, 0)];
    }
    
    [self updateContentFrame];
}

-(void)setDelegate:(id<LTImageScrollViewDelegate>)delegate{
    
    if (_delegate != delegate) {
        
        _delegate = delegate;
        [self lt_reloadContents];
    }
}
#pragma mark setter or getter
-(NSTimer *)timer{

    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:_scrollDuration
                                         target:self
                                       selector:@selector(autoScrollAction:)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer
                                     forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

-(void)setAutoScroll:(BOOL)autoScroll{

    if (_autoScroll != autoScroll) {
        
        _autoScroll = autoScroll;
        
        if (_autoScroll) {
            
            [self timerResume];
        }else{
            
            [self timerPause];
        }
    }
}

-(UIPageControl *)pageControl{

    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        _pageControl.hidesForSinglePage = NO;
        _pageControl.defersCurrentPageDisplay = YES;
        [_pageControl sizeToFit];
    }
    return _pageControl;
}

-(UIScrollView *)scrollView{

    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(LTImageView *)leftImageV{
    
    if (!_leftImageV) {
        
        _leftImageV = [[LTImageView alloc]init];
    }
    return _leftImageV;
}

-(LTImageView *)centerImageV{
    
    if (!_centerImageV) {
        
        _centerImageV = [[LTImageView alloc]init];
        [_centerImageV addTarget:self action:@selector(scrollContentClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerImageV;
}

-(LTImageView *)rightImageV{
    
    if (!_rightImageV) {
        
        _rightImageV = [[LTImageView alloc]init];
    }
    return _rightImageV;
}

-(NSInteger)leftPageIndex{
    
    if (pagesCount==0) {
        
        return 0;
    }
    
    NSInteger leftIndex = self.centerPageIndex - 1;
    if (leftIndex < 0)  {
        
        leftIndex = pagesCount - 1;
    }
    
    return leftIndex;
}

-(NSInteger)rightPageIndex{
    
    if (pagesCount==0) {
        
        return 0;
    }
    
    NSInteger rightIndex = self.centerPageIndex + 1;
    if (rightIndex > pagesCount - 1) {
        
        rightIndex = 0;
    }
    
    return rightIndex;
}
-(void)setCenterPageIndex:(NSInteger)centerPageIndex{
    
//    if (centerPageIndex == _centerPageIndex) {
//        
//        return;
//    }

    changeCurrentAnimate = NO;
    [self updateCurrentPageIndex:centerPageIndex];
}

-(NSInteger)centerPageIndex{

    if (_centerPageIndex > pagesCount - 1) {
        
        _centerPageIndex = pagesCount - 1;
    }
    else if (_centerPageIndex < 0) {
        
        _centerPageIndex = 0;
    }
    
    return _centerPageIndex;
}

-(NSInteger)currentPageIndex{

    return self.centerPageIndex;
}
-(void)setCurrentPageIndex:(NSInteger)currentPageIndex{

    changeCurrentAnimate = YES;
    [self updateCurrentPageIndex:currentPageIndex];
}
#pragma mark self methord
- (void)addPageControlLayout{
    
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void)autoScrollAction:(NSTimer *)timer{
    
    if (pagesCount>1) {
        
        self.currentPageIndex = self.centerPageIndex+1;
    }
}

-(void)updateCurrentPageIndex:(NSInteger)currentPageIndex{

    if (currentPageIndex > pagesCount - 1) {
        
        currentPageIndex = 0;
    }
    else if (currentPageIndex < 0){
        
        currentPageIndex = pagesCount - 1;
    }
    
    self.pageControl.currentPage = currentPageIndex;
    [self.pageControl updateCurrentPageDisplay];
    
    if (changeCurrentAnimate) {
        
        CGFloat width = CGRectGetWidth(self.scrollView.bounds);
        
//        CGFloat offsetX = width;
//        if (currentPageIndex>_centerPageIndex) {
        
        CGFloat offsetX = width*2;
//        }else if (currentPageIndex<_centerPageIndex) {
//
//            offsetX = width*0;
//        }
        _centerPageIndex = currentPageIndex;
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0.0) animated:YES];
        [self performSelector:@selector(updateContentFrame)
                   withObject:nil
                   afterDelay:0.35];
    }
    else{
    
        _centerPageIndex = currentPageIndex;
        [self updateContentFrame];
    }
    
    if ([self.delegate respondsToSelector:@selector(ltImageScrollView:currentIndex:)]) {
        
        [self.delegate ltImageScrollView:self
                            currentIndex:_centerPageIndex];
    }
}

-(void)lt_reloadContents{

    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    
    pagesCount = 0;
    
    if ([self.delegate respondsToSelector:@selector(ltImageScrollViewNumbersOfContents:)]) {
        
        pagesCount = [self.delegate ltImageScrollViewNumbersOfContents:self];
    }
    
    self.pageControl.numberOfPages = pagesCount;
    [self.pageControl sizeToFit];
    self.pageControl.hidden = pagesCount < 2;
    
    if (pagesCount>1) {
        
        self.scrollView.scrollEnabled = YES;
        [self.scrollView setContentSize:CGSizeMake(width*3, 0)];
    }
    else{
        
        self.scrollView.scrollEnabled = NO;
        [self.scrollView setContentSize:CGSizeMake(width, 0)];
    }
    
    [self updateContentFrame];
}

- (void)updateContentFrame{

    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    
    self.scrollView.contentOffset = CGPointMake(width, 0.0);
    
    self.leftImageV.frame = CGRectMake(0, 0.0, width, height);
    self.centerImageV.frame = CGRectMake(width, 0.0, width, height);
    self.rightImageV.frame = CGRectMake(width+width, 0.0, width, height);
    
    if (pagesCount > 0) {
        
        [self updateImagesContent];
    }
}

- (void)updateImagesContent{

    if ([self.delegate respondsToSelector:@selector(ltImageScrollView:imageAtIndex:imageView:)]) {
        
        [self.delegate ltImageScrollView:self
                            imageAtIndex:self.centerPageIndex
                               imageView:self.centerImageV.imageView];
        
        [self.delegate ltImageScrollView:self
                            imageAtIndex:self.leftPageIndex
                               imageView:self.leftImageV.imageView];
        
        [self.delegate ltImageScrollView:self
                            imageAtIndex:self.rightPageIndex
                               imageView:self.rightImageV.imageView];
    }
}

- (void)timerPause{

    if (!_timer) {
        
        return;
    }
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)timerResume{
    
    [self.timer setFireDate:[NSDate date]];
}

- (void)timerResumeAfter:(NSTimeInterval)timeInterval{
    
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}
#pragma mark click Action
- (void)scrollContentClick:(UIControl *)control{

    if (pagesCount<1) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(ltImageScrollView:clickContentAtIndex:)]) {
        
        [self.delegate ltImageScrollView:self clickContentAtIndex:self.centerPageIndex];
    }
}

- (void)pageControlClick:(UIPageControl *)pageControl{

    changeCurrentAnimate = YES;
    [self updateCurrentPageIndex:pageControl.currentPage];
}

- (UIImageView *)lt_currentImageView{
    
    return self.centerImageV.imageView;
}

- (void)lt_clearImageContents{

    self.centerImageV.imageView.image = nil;
    self.leftImageV.imageView.image = nil;
    self.rightImageV.imageView.image = nil;
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (self.forceToNoCycle) {
        
        if (self.centerPageIndex == 0) {
            
            if (offsetX<width) {
                
                scrollView.contentOffset = CGPointMake(width, 0);
                scrollView.userInteractionEnabled = NO;
                return;
            }
        }
        else if (self.centerPageIndex == pagesCount - 1){
        
            if (offsetX>width) {
                
                scrollView.contentOffset = CGPointMake(width, 0);
                scrollView.userInteractionEnabled = NO;
                return;
            }
        }
    }
    
    if (offsetX>2*width) {
        
        self.centerPageIndex = self.centerPageIndex-1;
    }
    else if (offsetX<0.0) {
        
        self.centerPageIndex = self.centerPageIndex+1;
    }
    
    if (self.pullStyle) {
        
        CGFloat height = CGRectGetHeight(self.scrollView.bounds);
        
        if (offsetX>width) {
            
            self.rightImageV.frame = CGRectMake(2*width, 0.0, offsetX-width, height);
            self.centerImageV.frame = CGRectMake(offsetX, 0.0, 2*width-offsetX, height);
        }
        if (offsetX<width) {
            
            self.leftImageV.frame = CGRectMake(offsetX, 0.0, width-offsetX, height);
            self.centerImageV.frame = CGRectMake(width, 0.0, offsetX, height);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    //NSLog(@"scrollViewDidEndDecelerating");
    scrollView.userInteractionEnabled = YES;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    NSInteger index = round(scrollView.contentOffset.x/width);
    
    self.centerPageIndex = self.centerPageIndex + index - 1;
    
    if (self.autoScroll) {
        
        [self timerResumeAfter:_scrollDuration];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if (self.autoScroll) {
        
        [self timerPause];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    scrollView.userInteractionEnabled = YES;
}
#pragma mark - CAAction

- (id<CAAction>)actionForLayer:(CALayer *)_layer forKey:(NSString *)event {
    //    [CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];

    if ([event isEqualToString:kCAOnOrderOut]) {
        
        if (_timer&&_timer.isValid) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    if ([event isEqualToString:kCAOnOrderIn] || [event isEqualToString:kCAOnOrderOut]) {
        return self;
    }
    
    return nil;
}

- (void)runActionForKey:(NSString *)key object:(id)anObject arguments:(NSDictionary *)dict {

    if (self.autoScroll) {
        
        if ([key isEqualToString:kCAOnOrderIn]) {
            
            [self timerResume];
        }
        else if ([key isEqualToString:kCAOnOrderOut]){
            
            [self timerPause];
        }
    }
}

- (void)handleStatusBarOrientationDidChange:(NSNotification *)notification{
    //1.获取 当前设备 实例
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    switch (orientation) {
            
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:{
            
            if (pagesCount == 0) {
                
                [self lt_reloadContents];
            }
            else {
                
                CGFloat width = CGRectGetWidth(self.scrollView.bounds);
                
                if (pagesCount>1) {
                    
                    self.scrollView.scrollEnabled = YES;
                    [self.scrollView setContentSize:CGSizeMake(width*3, 0)];
                }
                else{
                    
                    self.scrollView.scrollEnabled = NO;
                    [self.scrollView setContentSize:CGSizeMake(width, 0)];
                }
                [self updateContentFrame];
            }
            break;
        }
        case UIInterfaceOrientationUnknown:
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}

@end
