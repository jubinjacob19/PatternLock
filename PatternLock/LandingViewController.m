//
//  LandingViewController.m
//  PatternLock
//
//  Created by Jubin Jacob on 17/09/15.
//  Copyright (c) 2015 J. All rights reserved.
//

#import "LandingViewController.h"
#import "PatternViewController.h"

@interface LandingViewController ()<PatternViewControllerDelegate>
@property (nonatomic,strong) UIButton *unlockButton;
@property (nonatomic,strong) UIButton *modifyButton;
@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self setLayoutConstraints];
    // Do any additional setup after loading the view.
}

-(void)addSubviews {
    [self.view addSubview:self.unlockButton];
    [self.view addSubview:self.modifyButton];
}

-(void)setLayoutConstraints {
    NSDictionary *views = @{@"unlock":self.unlockButton,@"modify":self.modifyButton};
    NSDictionary *metrics = @{@"padding":@(70)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[unlock]-(padding)-[modify]" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[unlock]-(padding)-|" options:kNilOptions metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[modify]-(padding)-|" options:kNilOptions metrics:metrics views:views]];
}


-(UIButton *)unlockButton {
    if (!_unlockButton) {
        _unlockButton = [[UIButton alloc] init];
        [_unlockButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_unlockButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_unlockButton setTitle:@"Unlock" forState:UIControlStateNormal];
        [_unlockButton addTarget:self action:@selector(addUnLockVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unlockButton;
}

-(UIButton *)modifyButton {
    if (!_modifyButton) {
        _modifyButton = [[UIButton alloc] init];
        [_modifyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_modifyButton setTitle:@"Modify" forState:UIControlStateNormal];
        [_modifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(addModifyingVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyButton;
}


-(IBAction)addUnLockVC:(id)sender {
    PatternViewController *patternVC = [[PatternViewController alloc] initWithMode:PatternModeValidation delegate:self];
    [self presentViewController:patternVC animated:YES completion:^{
        
    }];
}

-(IBAction)addModifyingVC:(id)sender {
    PatternViewController *patternVC = [[PatternViewController alloc] initWithMode:PatternModeModify delegate:self];
    [self presentViewController:patternVC animated:YES completion:^{
        
    }];
    
}

#pragma mark pattern view controller delegate

-(void)unlockedPattern {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)modifiedPattern {
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)cancelEditing {
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
