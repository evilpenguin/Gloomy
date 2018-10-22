//
//  CloudView.h
//  JustPlaying
//
//  Created by James Emrich on 7/3/18.
//  Copyright © 2018 James Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CloudViewDelegate;
@interface GCloudView : UIView {
    
}
@property (nonatomic, weak, nullable) id<CloudViewDelegate> delegate;
@property (nonatomic, assign) NSInteger rainDropCount;

- (nonnull instancetype) initWithFrame:(CGRect)frame;
+ (nonnull GCloudView *) cloudAtPoint:(CGPoint)point;
- (void) rainWithCompletion:(void(^__nullable)(void))completion;
- (void) breakDownCloud;

@end

@protocol CloudViewDelegate
    @required
    - (CGPoint) rainDropFallToPoint;
    - (void) rainDropDidFinishMovingWithCloud:(nonnull GCloudView *)cloudView;
@end
