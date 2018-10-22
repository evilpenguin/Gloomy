//
//  CloudView.m
//  JustPlaying
//
//  Created by James Emrich on 7/3/18.
//  Copyright © 2018 James Emrich. All rights reserved.
//

#import "GCloudView.h"

@interface GCloudView ()
@property (nonatomic, copy) void (^completionBlock)(void);
@property (nonatomic, assign, getter=isCanceled) BOOL cancel;
@property (nonatomic, strong) UIView *pipeLineView;
@end

@implementation GCloudView

#pragma mark - GCloudView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0f;
        self.rainDropCount = arc4random_uniform(25) ?: 5;
        self.cancel = NO;
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:self.bounds];
        view.image = [UIImage imageNamed:@"cloud"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:view];
    }
    
    return self;
}

+ (GCloudView *) cloudAtPoint:(CGPoint)point {
    CGFloat height = 75.0f;
    CGFloat offset = height / 2.0f;
    
    return [[GCloudView alloc] initWithFrame:CGRectMake(point.x - offset, point.y - offset, height, height)];
}

#pragma mark - Public Methods

- (void) rainWithCompletion:(void(^)(void))completion {
    self.completionBlock = completion;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.45f
                     animations:^{
                         weakSelf.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf _makePipelineView];
                         [weakSelf _startRaining];
                     }];
}

- (void) breakDownCloud {
    self.cancel = YES;
    [self _removeCloud];
}

#pragma mark - Getters

- (UIView *) pipeLineView {
    if (!_pipeLineView) {
        _pipeLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _pipeLineView.backgroundColor = [UIColor clearColor];
    }
    
    return _pipeLineView;
}

#pragma mark - Private Methods

- (void) _removeCloud {
    __weak typeof(self) weakSelf = self;
    
    [self.pipeLineView removeFromSuperview];
    [UIView animateWithDuration:0.45f
                     animations:^{
                         weakSelf.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                         if (weakSelf.completionBlock) weakSelf.completionBlock();
                     }];
}

- (UIView *) _rainDropView {
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    view.backgroundColor = [UIColor clearColor];
    view.image = [UIImage imageNamed:@"drop"];
    view.contentMode = UIViewContentModeScaleAspectFit;
    view.alpha = 0.5f;
    
    return view;
}

- (void) _makePipelineView {
    if (!self.pipeLineView.superview) {
        self.pipeLineView.frame = CGRectMake(self.center.x - 15.0f, self.center.y - 15.0f, 30.0f, (self.delegate.rainDropFallToPoint.y - CGRectGetMaxY(self.frame)) + CGRectGetHeight(self.bounds));
        [self.superview insertSubview:self.pipeLineView belowSubview:self];
    }
}

- (void) _startRaining {
    __weak typeof(self) weakSelf = self;
    CGFloat durationOffset = 0.2f;

    for (NSInteger i = 0; i < self.rainDropCount; i++) {
        if (self.isCanceled) break;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!weakSelf.isCanceled) {
                UIView *rainDrop = [weakSelf _rainDropView];
                [weakSelf.pipeLineView addSubview:rainDrop];
                [weakSelf _moveDrop:rainDrop atIndex:i];
            }
        });
        
        durationOffset += arc4random_uniform(300) / 100.0f;
    }
}

- (void) _moveDrop:(UIView *)view atIndex:(NSInteger)index {
    if (view) {
        __weak typeof(self) weakSelf = self;
        
        CGRect frame = view.frame;
        frame.origin.y = CGRectGetHeight(self.pipeLineView.bounds);
        
        [UIView animateWithDuration:1.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.alpha = 1.0f;
                             view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [view removeFromSuperview];
                             [weakSelf.delegate rainDropDidFinishMovingWithCloud:weakSelf];
                             
                             if (!self.isCanceled && index == weakSelf.rainDropCount - 1) {
                                 [weakSelf _removeCloud];
                             }
                         }];
    }
}

@end
