//
//  VC2ViewController.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/12.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "VC2ViewController.h"

@interface VC2ViewController ()

@end

@implementation VC2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    UIButton *btn1 = [UIButton new];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(50, 50, 100, 50);
    [btn1 setTitle:@"alala" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    // Do any additional setup after loading the view.
}

- (void)tapped:(id)sender{
    NSLog(@"ahaha");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
