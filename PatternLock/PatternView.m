//
//  PatternView.m
//  PatternLock
//
//  Created by Jubin Jacob on 15/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "PatternView.h"
#import "NodeView.h"
#import "DrawingView.h"
#import "Utils.h"

static CGFloat const nodeSide = 20.0f;
static CGFloat const permittedMinOffset = 20.0f;
static CGFloat const permittedMaxOffset = 30.0f;

typedef NS_ENUM(NSUInteger, ToleranceLevel) {
    ToleranceLevelLow,
    ToleranceLevelHigh
};
@interface PatternView ()

@property (nonatomic,weak) id<PatternDelegate> delegate;
@property (nonatomic,strong)NodeView *node1;
@property (nonatomic,strong)NodeView *node2;
@property (nonatomic,strong)NodeView *node3;
@property (nonatomic,strong)NodeView *node4;
@property (nonatomic,strong)NodeView *node5;
@property (nonatomic,strong)NodeView *node6;
@property (nonatomic,strong)NodeView *node7;
@property (nonatomic,strong)NodeView *node8;
@property (nonatomic,strong)NodeView *node9;
@property (nonatomic,strong)DrawingView *drawingView;

@property (nonatomic,strong)UIPanGestureRecognizer *pangesture;
@property (nonatomic,strong)NSMutableArray *pointsArray;
@property (nonatomic,strong)NSArray *nodesArray;
@property (nonatomic,strong)NSMutableArray *currentPattern;

@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIPushBehavior *pushBehaviour1;
@property (nonatomic,strong) UIPushBehavior *pushBehaviour2;
@property (nonatomic,strong) UIPushBehavior *pushBehaviour3;

@end

@implementation PatternView

-(instancetype)initWithDelegate:(id<PatternDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubviews];
        [self addPanRecognizer];
    }
    return self;
}


#pragma mark Layout view

-(void)addSubviews {
    [self addSubview:self.node1];
    [self addSubview:self.node2];
    [self addSubview:self.node3];
    [self addSubview:self.node4];
    [self addSubview:self.node5];
    [self addSubview:self.node6];
    [self addSubview:self.node7];
    [self addSubview:self.node8];
    [self addSubview:self.node9];
    [self addSubview:self.drawingView];
}



-(void)layoutSubviews {
    
    CGFloat totalWidth = CGRectGetWidth(self.frame);
    CGFloat availableWidth = totalWidth - (3*nodeSide);
    CGFloat nodeSeparation = availableWidth/3;
    CGFloat marginpadding = nodeSeparation/2;
    NSDictionary *views = @{@"node1":self.node1,@"node2":self.node2,@"node3":self.node3,@"node4":self.node4,@"node5":self.node5,@"node6":self.node6,@"node7":self.node7,@"node8":self.node8,@"node9":self.node9,@"drawingView":self.drawingView};
    NSDictionary *metrics = @{@"padding":@(nodeSeparation),@"marginPadding":@(marginpadding)};
    

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(marginPadding)-[node1]-(padding)-[node2]-(padding)-[node3]-(marginPadding)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(marginPadding)-[node4]-(padding)-[node5]-(padding)-[node6]-(marginPadding)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(marginPadding)-[node7]-(padding)-[node8]-(padding)-[node9]-(marginPadding)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(marginPadding)-[node1]-(padding)-[node4]-(padding)-[node7]-(marginPadding)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(marginPadding)-[node2]-(padding)-[node5]-(padding)-[node8]-(marginPadding)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(marginPadding)-[node3]-(padding)-[node6]-(padding)-[node9]-(marginPadding)-|" options:kNilOptions metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[drawingView]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[drawingView]|" options:kNilOptions metrics:metrics views:views]];
    [self initializeNodesArray];
    [super layoutSubviews];
    
}

-(void)addAnimations {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.pushBehaviour1 = [[UIPushBehavior alloc] initWithItems:@[self.node1,self.node2,self.node3] mode:UIPushBehaviorModeContinuous];
    [self.pushBehaviour1 setAngle:-M_PI_2];
    [self.pushBehaviour1 setMagnitude:3.0];
    self.pushBehaviour2 = [[UIPushBehavior alloc] initWithItems:@[self.node4,self.node5,self.node6] mode:UIPushBehaviorModeContinuous];
    [self.pushBehaviour2 setAngle:-M_PI_2];
    [self.pushBehaviour2 setMagnitude:2.3];
    self.pushBehaviour3 = [[UIPushBehavior alloc] initWithItems:@[self.node7,self.node8,self.node9] mode:UIPushBehaviorModeContinuous];
    [self.pushBehaviour3 setAngle:-M_PI_2];
    [self.pushBehaviour3 setMagnitude:1.0];
    [self.animator addBehavior:self.pushBehaviour1];
    [self.animator addBehavior:self.pushBehaviour2];
    [self.animator addBehavior:self.pushBehaviour3];
    [self performSelector:@selector(completedAnimations) withObject:self afterDelay:.6]; // workaround to dismiss after animation
}

-(void)initializeNodesArray {
    self.nodesArray = @[self.node1,self.node2,self.node3,self.node4,self.node5,self.node6,self.node7,self.node8,self.node9];
}

#pragma mark Add Gesture Recognizer 

-(void)addPanRecognizer {
    [self addGestureRecognizer:self.pangesture];
}



#pragma mark getters

-(NodeView *)node1 {
    if (!_node1) {
        _node1 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node1;
}


-(NodeView *)node2 {
    if (!_node2) {
        _node2 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node2;
}


-(NodeView *)node3 {
    if (!_node3) {
        _node3 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node3;
}

-(NodeView *)node4 {
    if (!_node4) {
        _node4 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node4;
}


-(NodeView *)node5 {
    if (!_node5) {
        _node5 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node5;
}


-(NodeView *)node6 {
    if (!_node6) {
        _node6 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node6;
}

-(NodeView *)node7 {
    if (!_node7) {
        _node7 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node7;
}


-(NodeView *)node8 {
    if (!_node8) {
        _node8 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node8;
}


-(NodeView *)node9 {
    if (!_node9) {
        _node9 = [[NodeView alloc] initWithWidth:nodeSide];
    }
    return _node9;
}

-(DrawingView *)drawingView {
    if (!_drawingView) {
        _drawingView = [[DrawingView alloc] initWithPoints:self.pointsArray];
    }
    return _drawingView;
}

-(UIPanGestureRecognizer *)pangesture {
    if (!_pangesture) {
        _pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedOnView:)];
    }
    return _pangesture;
}

-(NSMutableArray *)pointsArray {
    if (!_pointsArray) {
        _pointsArray = [[NSMutableArray alloc] init];
    }
    return _pointsArray;
}

-(NSMutableArray *)currentPattern {
    if (!_currentPattern) {
        _currentPattern = [[NSMutableArray alloc] init];
    }
    return _currentPattern;
}


#pragma mark IBActions 

-(IBAction)pannedOnView:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    NSValue *pointValue = [NSValue valueWithCGPoint:touchPoint];
    NSError *error;
    NodeView *newNode;
    if(self.currentPattern.count) {
        newNode = [self viewInRangeForPoint:touchPoint error:&error tolerance:ToleranceLevelLow];
    }
    else {
        newNode = [self viewInRangeForPoint:touchPoint error:&error tolerance:ToleranceLevelHigh];
    }
    NSValue *newNodeCentre = [NSValue valueWithCGPoint:newNode.center];
    NSUInteger newNodeIndex = [self.nodesArray indexOfObject:newNode];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if(self.currentPattern.count) {
                [self invalidateCurrentPattern];
            }
            if(newNode) {
                [self.pointsArray addObject:newNodeCentre];
                [self.currentPattern addObject:@(newNodeIndex)];
                [self.delegate startedDrawing];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if(self.pointsArray.count)
            {
                if(self.pointsArray.count < 2)
                {
                    [self.pointsArray addObject:pointValue];
                }
                else
                {
                    NSUInteger lastIndex = self.pointsArray.count - 1;
                    if(newNode && ![self.currentPattern containsObject:@(newNodeIndex)])
                    {
                        [self.currentPattern addObject:@(newNodeIndex)];
                        [self.pointsArray replaceObjectAtIndex:lastIndex withObject:newNodeCentre];
                        [self animateAddedNode];
                        [self checkForIntermediatePoint];
                        
                    }
                    else
                    {
                        if([self shouldReplacePreviousPoint]) {
                            [self.pointsArray replaceObjectAtIndex:lastIndex withObject:pointValue];
                        }
                        else {
                            if([self shouldAddPoint:touchPoint]) {
                                [self.pointsArray addObject:pointValue];
                            }
                            
                        }
                        
                    }
                }
            }
            break;
         case UIGestureRecognizerStateCancelled:
            [self removeExtraLinesAndValidatePattern];
            break;
         case UIGestureRecognizerStateEnded:
            [self removeExtraLinesAndValidatePattern];
            break;
            
        default:
            break;
    }
    [self.drawingView updatePointsWithArray:self.pointsArray];
    [self.drawingView setNeedsDisplay];
}

-(void)checkForIntermediatePoint {
    CGPoint point1  = [[self.pointsArray lastObject] CGPointValue];
    CGPoint point2  = [[self.pointsArray objectAtIndex:self.pointsArray.count-2] CGPointValue];
    __block NSUInteger intermediateNodeIndex = NSNotFound;
    [self.nodesArray enumerateObjectsUsingBlock:^(NodeView *nodeView, NSUInteger idx, BOOL *stop) {
        if(![self.currentPattern containsObject:@(idx)]) {
            if([Utils point:nodeView.center liesInJoinOfPoint1:point1 point2:point2]) {
                intermediateNodeIndex = idx;
                *stop = YES;
            }
        }
    }];
    if(intermediateNodeIndex != NSNotFound) {
        [self addIntermediateNodeFromIndex:intermediateNodeIndex];
    }
}

-(void)addIntermediateNodeFromIndex:(NSUInteger)index {
    [self.currentPattern insertObject:@(index) atIndex:self.currentPattern.count-1];
    NodeView *node = [self.nodesArray objectAtIndex:index];
    [self.pointsArray insertObject:[NSValue valueWithCGPoint:node.center] atIndex:self.pointsArray.count-1];
    [self animateNodeAtIndex:index];
}



#pragma mark touch validation

-(NodeView *)viewInRangeForPoint:(CGPoint)touchPoint error:(NSError **)error tolerance:(ToleranceLevel)tolerance{
    
    __block NodeView *touchNode;
    [self.nodesArray enumerateObjectsUsingBlock:^(NodeView *node, NSUInteger idx, BOOL *stop) {
        
        CGPoint centre = node.center;
        if ([self point:touchPoint liesInRangeOfPoint:centre tolerance:tolerance]) {
            touchNode = node;
            *stop = YES;
        }
        
    }];
    if(!touchNode) {
        *error = [[NSError alloc] initWithDomain:@"com.sample.patternview" code:404 userInfo:@{@"data":@"No View Found"}];
    }
    return touchNode;
}

#pragma drawing helpers

-(BOOL)point:(CGPoint)point1 liesInRangeOfPoint:(CGPoint)centre tolerance:(ToleranceLevel)tolerance {
    
    CGFloat permittedoffset = (tolerance == ToleranceLevelHigh)?permittedMaxOffset : permittedMinOffset;
    CGFloat xOffset = fabs(point1.x-centre.x);
    CGFloat yOffset = fabs(point1.y-centre.y);
    return (xOffset < permittedoffset && yOffset < permittedoffset);
}

-(BOOL)shouldReplacePreviousPoint {
    
    CGPoint previousPoint = [[self.pointsArray lastObject] CGPointValue];
    __block BOOL shouldReplace = YES;
    [self.nodesArray enumerateObjectsUsingBlock:^(NodeView *node, NSUInteger idx, BOOL *stop) {
        if(CGPointEqualToPoint(previousPoint, node.center)) {
            *stop = YES;
            shouldReplace = NO;
        }
    }];
    return shouldReplace;
}

-(BOOL)shouldAddPoint:(CGPoint)newPoint {
    
    CGPoint previousPoint = [[self.pointsArray lastObject] CGPointValue];
    return (fabs(newPoint.x - previousPoint.x) > permittedMinOffset || fabs(newPoint.y - previousPoint.y) > permittedMinOffset);
    
}

-(void)removeExtraLinesAndValidatePattern {
    
    BOOL hasExtraLines = [self shouldReplacePreviousPoint];
    if(hasExtraLines) {
        [self.pointsArray removeLastObject];
        [self.drawingView updatePointsWithArray:self.pointsArray];
        [self.drawingView setNeedsDisplay];
    }
    if(self.currentPattern.count) {
        [self.delegate enteredPattern:self.currentPattern];
    }
}


-(void)animateAddedNode {
    [[self.nodesArray objectAtIndex:[[self.currentPattern lastObject] integerValue]] animateNode];
}
-(void)animateNodeAtIndex:(NSUInteger)index {
    [[self.nodesArray objectAtIndex:index] animateNode];
}

-(void)updateViewForCorrectPatternAnimates:(BOOL)shouldAnimate {
    
    if(shouldAnimate) {
        [self addAnimations];
        [self invalidateCurrentPattern];
    } else {
        [self invalidateCurrentPattern];
    }
}

-(void)updateViewForInCorrectPattern {
    for (NSNumber *nodeIndex in self.currentPattern) {
        [[self.nodesArray objectAtIndex:[nodeIndex intValue]] markInvalid];
        [self.drawingView markInvalid];
        [self performSelector:@selector(invalidateCurrentPattern) withObject:self afterDelay:1.0];
    }

}

-(void)updateViewForReEntry {
    [self invalidateCurrentPattern];
}

-(void)invalidateCurrentPattern {
    for (NSNumber *nodeIndex in self.currentPattern) {
        [[self.nodesArray objectAtIndex:[nodeIndex intValue]] reset];
    }
    [self.currentPattern removeAllObjects];
    [self.pointsArray removeAllObjects];
    [self.drawingView reset];
}

#pragma mark DismissView After Animation

-(void)completedAnimations {
    [self.animator removeAllBehaviors];
    [self.delegate completedAnimations];
}



@end
