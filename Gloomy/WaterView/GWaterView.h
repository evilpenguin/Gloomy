//
//  WaterView.h
//  JustPlaying
//
//  Created by James Emrich on 10/22/18.
//  Copyright © 2018 James Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WaterDirection) {
    WaterDirectionUp    = 0x00,
    WaterDirectionDown  = 0x01
};

@interface GWaterView : UIView

- (nonnull instancetype) initWithFrame:(CGRect)frame;
- (void) moveWaterInDirection:(WaterDirection)direction completion:(void(^__nullable)(void))completion;

@end
