//
//  ViewController.m
//  PatternLock
//
//  Created by Jubin Jacob on 15/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "PatternViewController.h"
#import "PatternView.h"
#import "PatternManager.h"

typedef NS_ENUM(NSUInteger, PatternState) {
    PatternStateValidation,
    PatternStateEntry,
    PatternStateReEntry
};
@interface PatternViewController ()<PatternDelegate>
@property (nonatomic,strong) PatternView *patternView;
@property (nonatomic)PatternMode patternMode;
@property (nonatomic)PatternState patternState;
@property (nonatomic,strong) NSArray *tempPattern;
@property (nonatomic,weak)id<PatternViewControllerDelegate> delegate;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UIButton *resetButton;
@property (nonatomic,strong) UIButton *continueButton;
@property (nonatomic,strong) UILabel *infoLabel;
@end

@implementation PatternViewController

-(instancetype)initWithMode:(PatternMode)mode delegate:(id<PatternViewControllerDelegate>)delegate{
    if (self = [super init]) {
        _patternMode = mode;
        _patternState = PatternStateValidation;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubViews];
    [self setLayoutConstraints];
    if(self.patternMode == PatternModeModify) {
        [self addInfoView];
    }
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)addSubViews {
    
    [self.view addSubview:self.patternView];
}


-(void)setLayoutConstraints {
    
    NSDictionary *views = @{@"patternView":self.patternView};
    NSDictionary *metrics = @{@"padding":@10};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[patternView]-(padding)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.patternView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.patternView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.patternView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

-(void)addInfoView {

    [self.view addSubview:self.infoLabel];
    NSDictionary *views = @{@"label":self.infoLabel};
    NSDictionary *metrics = @{@"padding":@80};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[label]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[label]|" options:kNilOptions metrics:metrics views:views]];
}

-(void)modifyUIForEntryState {

    [self.view addSubview:self.resetButton];
    [self.view addSubview:self.continueButton];
    
    NSDictionary *views = @{@"reset":self.resetButton,@"continue":self.continueButton};
    NSDictionary *metrics = @{@"padding":@20};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[reset]-[continue(==reset)]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[reset]-(padding)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[continue]-(padding)-|" options:kNilOptions metrics:metrics views:views]];
    
}

-(void)modifyUIForReEntryState {
    
    [self.resetButton removeFromSuperview];
    [self.continueButton removeFromSuperview];
    
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
    
    NSDictionary *views = @{@"reset":self.cancelButton,@"continue":self.confirmButton};
    NSDictionary *metrics = @{@"padding":@20};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[reset]-[continue(==reset)]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[reset]-(padding)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[continue]-(padding)-|" options:kNilOptions metrics:metrics views:views]];
    
}


#pragma mark getters

-(PatternView *)patternView {
    if (!_patternView) {
        _patternView = [[PatternView alloc] initWithDelegate:self];
    }
    return _patternView;
}

-(void)setPatternState:(PatternState)patternState {
    _patternState = patternState;
    if(patternState == PatternStateEntry) {
        [self modifyUIForEntryState];
        self.infoLabel.text = @"Draw an unlock pattern";
    } else if (patternState == PatternStateReEntry) {
        [self modifyUIForReEntryState];
        self.infoLabel.text = @"Draw pattern again to confirm";
    }
}

-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelModification:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_confirmButton setTitle:@"CONFIRM" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_confirmButton addTarget:self action:@selector(confirmPattern:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setEnabled:NO];
    }
    return _confirmButton;
}

-(UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] init];
        [_resetButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_resetButton setTitle:@"RESET" forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetPattern:) forControlEvents:UIControlEventTouchUpInside];
        [_resetButton setEnabled:NO];
    }
    return _resetButton;
}

-(UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [[UIButton alloc] init];
        [_continueButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_continueButton addTarget:self action:@selector(continueEditing:) forControlEvents:UIControlEventTouchUpInside];
        [_continueButton setEnabled:NO];
    }
    return _continueButton;
}

-(UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel setText:@"Confirm saved pattern"];
        [_infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setTextColor:[UIColor whiteColor]];
    }
    return _infoLabel;
}

#pragma mark IBActions 

-(IBAction)confirmPattern:(id)sender {
    [self updatePatterViewForModificationIsVerified:YES];
}

-(IBAction)cancelModification:(id)sender {
    [self.delegate cancelEditing];
}

-(IBAction)resetPattern:(id)sender {
    [self.patternView invalidateCurrentPattern];
    self.infoLabel.text = @"Draw an unlock pattern";
}

-(IBAction)continueEditing:(id)sender {
    [self.patternView updateViewForReEntry];
    self.patternState = PatternStateReEntry;
}


#pragma mark Pattern Validation

-(BOOL)isPatternCorrect:(NSArray *)pattern {
    if(self.patternState == PatternStateValidation) {
        return  [[PatternManager sharedManager] isCorrectPattern:pattern];
    } else if (self.patternState == PatternStateReEntry) {
        return [[PatternManager sharedManager] pattern:pattern isEqualToPattern:self.tempPattern];
    }
    return YES;
}


-(BOOL)isPatternValid:(NSArray *)pattern {
    return [pattern count] >= 4;
}


#pragma mark Pattern Delegate

-(void)enteredPattern:(NSArray *)pattern {
    if(self.patternState == PatternStateEntry) {
        if([self isPatternValid:pattern]) {
            self.tempPattern = [pattern copy];
            [self.resetButton setEnabled:YES];
            [self.continueButton setEnabled:YES];
        } else {
            [self showInvalidPatternAlert];
            [self.patternView updateViewForReEntry];
        }
    } else {
        if([self isPatternCorrect:pattern]) {
            if (self.patternMode == PatternModeValidation) {
                [self.patternView updateViewForCorrectPatternAnimates:YES];
            } else if(self.patternMode == PatternModeModify && self.patternState == PatternStateValidation) {
                self.patternState = PatternStateEntry;
                [self updatePatterViewForModificationIsVerified:YES];
            } else if (self.patternState == PatternStateReEntry) {
                [self.confirmButton setEnabled:YES];
            }
        } else {
            if(self.patternState == PatternStateReEntry) {
                self.infoLabel.text = @"Try again";
            }
            [self.patternView updateViewForInCorrectPattern];
        }
    }
    
}

#pragma mark update Patter View


-(void)updateViewForCorrectPattern {
    switch (self.patternMode) {
        case PatternModeValidation:
            [self.patternView updateViewForCorrectPatternAnimates:YES];
            break;
         case PatternModeModify:
            [self.patternView updateViewForInCorrectPattern];
            break;
        default:
            break;
    }

}


-(void)updatePatterViewForModificationIsVerified:(BOOL)verified {
    
    if(verified) {
        [self.patternView updateViewForCorrectPatternAnimates:NO];
        if(self.patternMode == PatternModeValidation) {
            [self.patternView updateViewForCorrectPatternAnimates:YES];
            
        } else  {
            if(self.patternState == PatternStateReEntry) {
                [self updateStoredPattern];
                [self.delegate modifiedPattern];
            }
        }
    } else {
        [self updatePatterViewForModificationIsVerified:NO];
    }
}

-(void)updateStoredPattern {
    [[PatternManager sharedManager] updatePattern:self.tempPattern];
}

-(void)showInvalidPatternAlert {
    
    [self.infoLabel setText:@"Connect atleast four dots"];
}

-(void)updateUIForPatternEntry {
    
}



#pragma mark Pattern View Delegate

-(void)completedAnimations {
    [self.delegate unlockedPattern];
}

-(void)startedDrawing {
    if (self.patternState == PatternStateEntry || self.patternState == PatternStateReEntry) {
        [self.infoLabel setText:@"Release finger when done"];
    }
}


@end
