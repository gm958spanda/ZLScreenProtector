//
//  ViewController.m
//  ZLScreenProtector
//
//  Created by zxs.zl on 2019/2/11.
//  Copyright © 2019 zxs.zl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //一个渐变
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    layer.colors = @[(id)[UIColor yellowColor].CGColor,(id)[UIColor redColor].CGColor];
    [self.view.layer addSublayer:layer];
}


@end
