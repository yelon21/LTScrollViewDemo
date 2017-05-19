//
//  LTImageView.m
//  LTScrollViewDemo
//
//  Created by yelon on 16/5/2.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTImageView.h"

@implementation LTImageView
@synthesize imageView = _imageView;

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.imageView.frame = self.bounds;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
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
@end
