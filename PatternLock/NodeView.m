//
//  NodeView.m
//  PatternLock
//
//  Created by Jubin Jacob on 15/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "NodeView.h"

@interface NodeView ()
@property (nonatomic)CGFloat width;
@property (nonatomic,strong) UIColor *nodeColor;
@end

@implementation NodeView

-(instancetype)initWithWidth:(CGFloat)width
{
    if (self = [super init]) {
        _width = width;
        _nodeColor = [UIColor whiteColor];
        [self setUpView];
    }
    return self;
}

-(void)setUpView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setBackgroundColor:self.nodeColor];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width]];
    [self.layer setCornerRadius:self.width/2];
}

-(void)animateNode {
    [self setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
    [self performSelector:@selector(removeScaleEffect) withObject:self afterDelay:0.5];
}

-(void)removeScaleEffect {
    [self setTransform:CGAffineTransformMakeScale(1, 1)];
}


-(void)markInvalid {
    self.backgroundColor = [UIColor orangeColor];
}

-(void)reset {
    self.backgroundColor = [UIColor whiteColor];
}

@end
