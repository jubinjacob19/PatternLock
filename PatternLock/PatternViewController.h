//
//  ViewController.h
//  PatternLock
//
//  Created by Jubin Jacob on 15/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, PatternMode) {
    PatternModeValidation,
    PatternModeModify,
};

@protocol PatternViewControllerDelegate <NSObject>

-(void)unlockedPattern;
-(void)modifiedPattern;
-(void)cancelEditing;

@end

@interface PatternViewController : UIViewController

-(instancetype)initWithMode:(PatternMode)mode delegate:(id<PatternViewControllerDelegate>)delegate;

@end

