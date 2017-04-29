//
//  LTImageView.m
//  LTScrollViewDemo
//
//  Created by yelon on 16/5/2.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTImageView.h"

@interface LTImageView ()<UIScrollViewDelegate>

@end

@implementation LTImageView
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.scrollView.frame = self.bounds;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.scrollView];
        self.scrollView.delegate = self;
        
        self.imageView.frame = self.bounds;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.scrollView addSubview:self.imageView];
        
    }
    return self;
}

-(UIImageView *)imageView{

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.maximumZoomScale = 3.0;
    }
    return _scrollView;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    return self.imageView;
}

@end
