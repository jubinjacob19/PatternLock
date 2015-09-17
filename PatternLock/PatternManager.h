//
//  PatternManager.h
//  PatternLock
//
//  Created by Jubin Jacob on 17/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatternManager : NSObject

+(instancetype)sharedManager;
-(BOOL)isCorrectPattern:(NSArray *)pattern;
-(void)updatePattern:(NSArray *)pattern;
-(BOOL)pattern:(NSArray *)pattern1 isEqualToPattern:(NSArray *)pattern2;
@end
