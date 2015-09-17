//
//  NodeView.h
//  PatternLock
//
//  Created by Jubin Jacob on 15/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodeView : UIView
-(instancetype)initWithWidth:(CGFloat)width;
-(void)markInvalid;
-(void)reset;
-(void)animateNode;

@end
