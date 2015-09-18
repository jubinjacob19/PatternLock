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
@property (nonatomic) CGFloat maskInset;
@end

@implementation NodeView

-(instancetype)initWithWidth:(CGFloat)width
{
    if (self = [super init]) {
        _width = width;
        _nodeColor = [UIColor whiteColor];
        _maskInset = 5.0;
        [self setUpView];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, self.maskInset, self.maskInset)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

-(void)setUpView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setBackgroundColor:self.nodeColor];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width]];
}

-(void)animateNode {
    self.maskInset = 0.0;
    [self setNeedsDisplay];
    [self performSelector:@selector(removeScaleEffect) withObject:self afterDelay:0.5];

}

-(void)removeScaleEffect {
    self.maskInset = 5.0;
    [self setNeedsDisplay];
}


-(void)markInvalid {
    self.backgroundColor = [UIColor orangeColor];
}

-(void)reset {
    self.backgroundColor = [UIColor whiteColor];
}

@end
