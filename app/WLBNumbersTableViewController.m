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
    NSArray *numbers;
    NSArray *organizations;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // numbers = [NSArray arrayWithInit:[Request @"http://wellbeing.riceapps.org/getNumbers"]
    // {results: ["number 1" : "18374926459", number 2: as28238074]}
    numbers = [NSArray arrayWithObjects:@"RUPD/REMS", @"Student Wellbeing Office", @"Student Judicial Programs", @"Rice Counseling Center", @"Student Health Services", @"Russell Barnes Title IX Coordinator", @"Dr. Donald Ostdiek Deputy Title IX Coordinator (for students)", @"Stacy Mosely Deputy Title IX Coordinator (for athletics)", nil];
    organizations = [NSArray arrayWithObjects:@"7133486000", @"7133483311", @"7133484786", nil];

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
    
    cell.textLabel.text = [numbers objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [organizations objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
