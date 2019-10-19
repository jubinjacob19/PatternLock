//
//  PatternViewController.h
//  PatternLock
//
//  Created by jubinjacob on 10/19/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
