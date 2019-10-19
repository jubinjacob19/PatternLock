//
//  PatternManager.m
//  PatternLock
//
//  Created by curatech on 10/19/19.
//

#import "PatternManager.h"

NSString *const kPatternKey = @"patternKey";

@interface PatternManager ()
@property (nonatomic,strong)NSArray *storedpattern;
@end

@implementation PatternManager
+(instancetype)sharedManager {
    static PatternManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

-(BOOL)isCorrectPattern:(NSArray *)pattern {
    if(self.storedpattern) {
        return [self.storedpattern isEqualToArray:pattern];
    } else {
        return YES;
    }
}

-(BOOL)pattern:(NSArray *)pattern1 isEqualToPattern:(NSArray *)pattern2{
    
    return [pattern1 isEqualToArray:pattern2];
    
}

-(NSArray *)storedpattern {
    if(!_storedpattern) {
        _storedpattern = [[NSUserDefaults standardUserDefaults] objectForKey:kPatternKey];
    }
    return _storedpattern;
}

-(void)updatePattern:(NSArray *)pattern {
    self.storedpattern = [pattern copy];
    [[NSUserDefaults standardUserDefaults] setObject:self.storedpattern forKey:kPatternKey];
}

@end
