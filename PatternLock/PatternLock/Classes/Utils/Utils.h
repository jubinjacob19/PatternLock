//
//  Utils.h
//  PatternLock
//
//  Created by curatech on 10/19/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
+(BOOL)point:(CGPoint)intermediatePoint liesInJoinOfPoint1:(CGPoint)point1 point2:(CGPoint)point2;
@end

NS_ASSUME_NONNULL_END
