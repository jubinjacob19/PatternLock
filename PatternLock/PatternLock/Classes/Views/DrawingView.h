//
//  DrawingView.h
//  PatternLock
//
//  Created by curatech on 10/19/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawingView : UIView
-(instancetype)initWithPoints:(NSArray *)points;
-(void)updatePointsWithArray:(NSArray *)newPoints;
-(void)markInvalid;
-(void)reset;
@end

NS_ASSUME_NONNULL_END
