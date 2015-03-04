//
//  WLBWebViewController.m
//  Wellbeing App
//
//  Created by Xilin Liu on 3/4/15.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import "WLBWebViewController.h"

@interface WLBWebViewController ()

@end

@implementation WLBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self loadRequestFromString:@"http://10.115.78.45:19125/login"];
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
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
