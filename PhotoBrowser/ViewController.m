//
//  ViewController.m
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "ViewController.h"
#import "WJDataSourceVC.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pushBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushBtnClick:(UIButton *)sender {
    WJDataSourceVC *vc = [[WJDataSourceVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
