//
//  WaterView.m
//  JustPlaying
//
//  Created by James Emrich on 10/22/18.
//  Copyright © 2018 James Emrich. All rights reserved.
//

#import "GWaterView.h"

@implementation GWaterView

#pragma mark - GWaterView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.39f green:0.83f blue:0.99f alpha:0.7f];
        self.tag = 0x01;
    }
    
    return self;
}

#pragma mark - Public Methods

- (void) moveWaterInDirection:(WaterDirection)direction completion:(void(^)(void))completion {
    CGFloat yOffset = self.frame.origin.y;
    
    switch (direction) {
        case WaterDirectionUp:
            yOffset -= self._waterDirectionOffset;
            if (yOffset <= 0.0) yOffset = 0.0f;
            
            break;
        case WaterDirectionDown:
            yOffset += self._waterDirectionOffset - 2.0f;
            
            CGFloat maxY = CGRectGetHeight(self.frame);
            if (yOffset >= maxY) yOffset = maxY;
            
            break;
    }

    CGRect puddleFrame = self.frame;
    puddleFrame.origin.y = yOffset;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.2f
                          delay:0.1f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         weakSelf.frame = puddleFrame;
                     }
                     completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

#pragma mark - Private methods

- (CGFloat) _waterDirectionOffset {
    return 5.0f;
}

@end
