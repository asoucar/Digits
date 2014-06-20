//
//  ViewController.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *onScreenNums;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.onScreenNums = [NSMutableArray array];
    
    UILabel *num1Label = [[UILabel alloc] initWithFrame:self.num1.frame];
    num1Label.text = @"123.456";
    num1Label.font = self.num1.font;
    num1Label.userInteractionEnabled = YES;
    
    UILabel *num2Label = [[UILabel alloc] initWithFrame:self.numb2.frame];
    num2Label.text = @"65.43";
    num2Label.font = self.num1.font;
    num2Label.userInteractionEnabled = YES;
    
    UILabel *num3Label = [[UILabel alloc] initWithFrame:self.numb2.frame];
    num3Label.center = CGPointMake(num3Label.center.x + 40, num3Label.center.y + 100);
    num3Label.text = @"22";
    num3Label.font = self.num1.font;
    num3Label.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(labelDragged:)];
    
    UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(labelDragged:)];
    UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(labelDragged:)];

    
	[num1Label addGestureRecognizer:gesture];
    [num2Label addGestureRecognizer:gesture2];
    [num3Label addGestureRecognizer:gesture3];
    
    [self.num1 removeFromSuperview];
    [self.numb2 removeFromSuperview];
    
    [self.view addSubview:num1Label];
    [self.view addSubview:num2Label];
    [self.view addSubview:num3Label];
    
    [self.onScreenNums addObject:num1Label];
    [self.onScreenNums addObject:num2Label];
    [self.onScreenNums addObject:num3Label];
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	UILabel *label = (UILabel *)gesture.view;
	CGPoint translation = [gesture translationInView:label];
    
	// move label
	label.center = CGPointMake(label.center.x + translation.x,
                               label.center.y + translation.y);
    
    for (UILabel *otherLabel in self.onScreenNums) {
        if (label != otherLabel && CGRectIntersectsRect(label.frame, otherLabel.frame)) {
            //pretending alignment
//            if (YES) {
//                
//                NSDecimalNumber *decNum1 = [NSDecimalNumber decimalNumberWithString:label.text];
//                NSDecimalNumber *decNum2 = [NSDecimalNumber decimalNumberWithString:otherLabel.text];
//                
//                NSDecimalNumber *sumVal = [decNum2 decimalNumberByAdding:decNum1];
//                
//                UILabel *sumLabel = [[UILabel alloc] initWithFrame:label.frame];
//                sumLabel.text = sumVal.stringValue;
//                sumLabel.font = [UIFont systemFontOfSize:30.0];
//                
//                sumLabel.userInteractionEnabled = YES;
//                
//                UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
//                                                    initWithTarget:self
//                                                    action:@selector(labelDragged:)];
//                [sumLabel addGestureRecognizer:gesture3];
//                
//                [self.onScreenNums removeObject:label];
//                [self.onScreenNums removeObject:otherLabel];
//                [label removeFromSuperview];
//                [otherLabel removeFromSuperview];
//                
//                // add it
//                [self.view addSubview:sumLabel];
//                [self.onScreenNums addObject:sumLabel];
//                
//                break;
//            }
            
            
            //for not aligned
            
            otherLabel.center = CGPointMake(otherLabel.center.x + translation.x,
                                                otherLabel.center.y + translation.y);

        }

    }
    
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:label];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
