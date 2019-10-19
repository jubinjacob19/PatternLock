//
//  PatternManager.h
//  PatternLock
//
//  Created by curatech on 10/19/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatternManager : NSObject
+(instancetype)sharedManager;
-(BOOL)isCorrectPattern:(NSArray *)pattern;
-(void)updatePattern:(NSArray *)pattern;
-(BOOL)pattern:(NSArray *)pattern1 isEqualToPattern:(NSArray *)pattern2;
@end

NS_ASSUME_NONNULL_END
