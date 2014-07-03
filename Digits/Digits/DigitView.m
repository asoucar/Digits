//
//  DigitView.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "DigitView.h"

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
    self.textColor = [UIColor blackColor];
}

- (void) deselect
{
    self.isDigitSelected = false;
    self.textColor = [UIColor whiteColor];
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
