//
//  PatternView.h
//  PatternLock
//
//  Created by Jubin Jacob on 15/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PatternDelegate <NSObject>

-(void)enteredPattern:(NSArray *)pattern;
-(void)completedAnimations;
-(void)startedDrawing;

@end

@interface PatternView : UIView
-(instancetype)initWithDelegate:(id<PatternDelegate>)delegate;
-(void)updateViewForCorrectPatternAnimates:(BOOL)shouldAnimate;
-(void)updateViewForInCorrectPattern;
-(void)updateViewForReEntry;
-(void)invalidateCurrentPattern;
@end
