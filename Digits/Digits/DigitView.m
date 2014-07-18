//
//  DigitView.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "DigitView.h"

#define DISSOLVE_TO_SELECTED_TIME .6
#define DISSOLVE_TO_UNSELECTED_TIME .2
#define SECONDS_UNTIL_DESELECT 3.0

@interface DigitView ()

@property (nonatomic) id fullNum;

@end

@implementation DigitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andValue:(NSDecimalNumber *)value
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.value = value;
        self.isDigitSelected = false;
        
    }
    return self;
}

- (void)selected
{
    self.isDigitSelected = true;
    
    [UIView transitionWithView:self duration:DISSOLVE_TO_SELECTED_TIME options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.textColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
    }];
    
    
    self.deselectTimer  = [NSTimer scheduledTimerWithTimeInterval:SECONDS_UNTIL_DESELECT
                                                           target:self
                                                         selector:@selector(deselect)
                                                         userInfo:nil
                                                          repeats:NO];
}

- (void) deselect
{
    [self.deselectTimer invalidate];

    self.isDigitSelected = false;
    
    [UIView transitionWithView:self duration:DISSOLVE_TO_UNSELECTED_TIME options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.textColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
    }];

    
    [self removeGestureRecognizer:[self.gestureRecognizers objectAtIndex:1]];
}

- (id)fullNum
{
    return self.fullNum;
}
- (void)setFullNum:(id)fullNumber
{
    self.fullNum = fullNumber;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
