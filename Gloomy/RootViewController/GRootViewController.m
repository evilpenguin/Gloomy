//
//  GRootViewController.m
//  JustPlaying
//
//  Created by James Emrich on 7/2/18.
//  Copyright © 2018 James Emrich. All rights reserved.
//

#import "GRootViewController.h"
#import "GCloudView.h"
#import "GWaterView.h"

@interface GRootViewController() <CloudViewDelegate>
@property (nonatomic, strong) GWaterView *puddleView;
@property (nonatomic, strong) NSTimer *removeRainTimer;
@property (nonatomic, strong) UIView *cloudContainer;
@end

@implementation GRootViewController

#pragma mark - GRootViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cloudContainer];
    [self.view addSubview:self.puddleView];
}

#pragma mark - Getters

- (GWaterView *) puddleView {
    if (!_puddleView) _puddleView = [[GWaterView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    return _puddleView;
}

- (UIView *) cloudContainer {
    if (!_cloudContainer) _cloudContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    
    return _cloudContainer;
}

#pragma mark - Private methods

-  (void) _checkAndStartRainRemoveTimer {
    if (self.cloudContainer.subviews.count == 0x00 && !self.removeRainTimer.isValid) {
        __weak typeof(self) weakSelf = self;
        self.removeRainTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf.puddleView moveWaterInDirection:WaterDirectionDown completion:^{
                if (weakSelf.puddleView.frame.origin.y >= CGRectGetHeight(weakSelf.puddleView.frame)) {
                    [weakSelf.removeRainTimer invalidate];
                    weakSelf.removeRainTimer = nil;
                }
            }];
        }];
    }
}

#pragma mark - Touches

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.puddleView.frame.origin.y > 0.0f) {
        UITouch *touch = [touches anyObject];
        if (touch.view == self.cloudContainer) {
            if (self.removeRainTimer.isValid) [self.removeRainTimer invalidate];
            
            CGPoint point = [touch locationInView:self.view];
            GCloudView *view = [GCloudView cloudAtPoint:point];
            view.delegate = self;
            [self.cloudContainer addSubview:view];
            
            __weak typeof(self) weakSelf = self;
            [view rainWithCompletion:^{
                [weakSelf _checkAndStartRainRemoveTimer];
            }];
        }
    }
}

#pragma mark - CloudViewDelegate

- (CGPoint) rainDropFallToPoint {
    return self.puddleView.frame.origin;
}

- (void) rainDropDidFinishMovingWithCloud:(GCloudView *)cloudView {
    __weak typeof(self) weakSelf = self;
    [self.puddleView moveWaterInDirection:WaterDirectionUp completion:^{
        // Remove the cloud if the water is too high
        if (weakSelf.puddleView.frame.origin.y <= CGRectGetMaxY(cloudView.frame)) {
            [cloudView breakDownCloud];
        }
    }];
}

@end
