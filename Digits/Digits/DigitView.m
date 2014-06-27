//
//  DigitView.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "DigitView.h"
#import "BigNumber.h"

@implementation DigitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UISwipeGestureRecognizer *gesture2 = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(numberSwiped:)];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andValue:(NSDecimalNumber *)value
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.value = value;
        
        UISwipeGestureRecognizer *gesture2 = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(numberSwiped:)];
        
    }
    return self;
}

- (void) numberSwiped:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp || gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        //tell big number to tell view controller to create a new big number
        //with value of this digit
        //and subtract value from first big number
        //and remove this digit from big number
        NSLog(@"swipe up/down");
    }
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        //tell big number to tell view controller to create a new big number
        //with value of whole number with digits to right of this number, inclusive
        //and subtract value from first big number
        //and remove this digit from big number
    }
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
