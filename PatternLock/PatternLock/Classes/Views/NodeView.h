//
//  NodeView.h
//  PatternLock
//
//  Created by curatech on 10/19/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeView : UIView
-(instancetype)initWithWidth:(CGFloat)width;
-(void)markInvalid;
-(void)reset;
-(void)animateNode;
@end

NS_ASSUME_NONNULL_END
