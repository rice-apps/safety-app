//
//  WLBNumbersTableViewController.m
//  Wellbeing App
//
//  Created by Xilin Liu on 9/16/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import "WLBNumbersTableViewController.h"
#import "WLBNumbersDetailViewController.h"

@interface WLBNumbersTableViewController ()

@end

@implementation WLBNumbersTableViewController
{
    NSMutableArray *numbers;
    NSMutableArray *organizations;
    NSMutableData *_receivedData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLRequest *theRequest=[NSURLRequest
                              requestWithURL:[NSURL URLWithString:
                                              @"http://104.236.61.111:19125/api/numbers"]
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                              timeoutInterval:60.0];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (con) {
        _receivedData=[NSMutableData data];
    } else {
        NSLog(@"No data received from backend");
    }

}


-(void)connection:(NSConnection*)conn didReceiveResponse:(NSURLResponse *)response
{
    if (_receivedData == NULL) {
        _receivedData = [[NSMutableData alloc] init];
    }
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    numbers = [NSMutableArray arrayWithObjects:nil];
    organizations = [NSMutableArray arrayWithObjects:nil];
    
    NSDictionary *jsonObject=[NSJSONSerialization
                                JSONObjectWithData:_receivedData
                                options:NSJSONReadingMutableLeaves
                                error:nil];
    NSArray *obtainedNumbers = jsonObject[@"result"];
    for (NSDictionary *entry in obtainedNumbers) {
        [numbers addObject:[NSString stringWithFormat:@"%@",entry[@"number"]]];
        [organizations addObject:[NSString stringWithFormat:@"%@",entry[@"name"]]];
            
    }
    
    //delete the following two lines
    [numbers addObject:[NSString stringWithFormat:@"8328070265"]];
    [organizations addObject:[NSString stringWithFormat:@"Leo's number"]];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [organizations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *numberTableIdentifier = @"numberTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:numberTableIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numberTableIdentifier];
    }
    
    cell.textLabel.text = [organizations objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [numbers objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"ShowNumberDetails"]) {
        WLBNumbersDetailViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        long row = [myIndexPath row];
        
        detailViewController.numberDetail = @[organizations[row], numbers[row]];
    }
}


@end