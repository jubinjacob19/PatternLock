//
//  DrawingView.h
//  PatternLock
//
//  Created by Jubin Jacob on 16/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingView : UIView
-(instancetype)initWithPoints:(NSArray *)points;
-(void)updatePointsWithArray:(NSArray *)newPoints;
-(void)markInvalid;
-(void)reset;
@end
