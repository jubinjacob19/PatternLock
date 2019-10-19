//
//  PatternView.h
//  PatternLock
//
//  Created by curatech on 10/19/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
