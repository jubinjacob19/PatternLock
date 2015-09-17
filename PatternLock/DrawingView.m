//
//  DrawingView.m
//  PatternLock
//
//  Created by Jubin Jacob on 16/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "DrawingView.h"

@interface DrawingView ()
@property (nonatomic,strong) NSArray *pointsArray;
@property (nonatomic,strong) UIColor *lineColor;
@end

@implementation DrawingView

-(instancetype)initWithPoints:(NSArray *)points {
    if (self = [super init]) {
        _pointsArray = points;
        _lineColor = [UIColor whiteColor];
        [self setClearsContextBeforeDrawing:YES];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)markInvalid {
    self.lineColor = [UIColor orangeColor];
    [self setNeedsDisplay];
}

-(void)reset {
    self.pointsArray = @[];
    self.lineColor = [UIColor whiteColor];
    [self setNeedsDisplay];
}


-(void)updatePointsWithArray:(NSArray *)newPoints {
    self.pointsArray = newPoints;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(self.pointsArray.count >1) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineJoinStyle = kCGLineJoinRound;
        [path setLineWidth:2.5];
        CGPoint origin = [[self.pointsArray firstObject] CGPointValue];
        [path moveToPoint:origin];
        for (NSValue *pointValue in self.pointsArray) {
            CGPoint next = [pointValue CGPointValue];
            [path addLineToPoint:next];
        }
        [self.lineColor setStroke];
        [path stroke];
    }
}



@end
