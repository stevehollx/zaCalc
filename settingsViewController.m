//
//  settingsViewController.m
//  zaCalc
//
//  Created by sholl on 2/9/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import "settingsViewController.h"
#import "MySingletonClass.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

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

    weights = [[NSArray alloc] initWithObjects:@"Grams",@"Ounces",@"Cups & Tsp", nil];
    distances = [[NSArray alloc] initWithObjects:@"Inches",@"Centimeters", nil];
    temps = [[NSArray alloc] initWithObjects:@"Farenheit",@"Celsius", nil];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//picker stuff


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    if ([pickerView tag] == 0) {
        return 2;
    }
    else if([pickerView tag] == 1)
    {
        return 2;
    }
    else if([pickerView tag] == 2)
    {
        return 3;
    } else {
        return 0;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    if ([pickerView tag] == 0) {
            return [distances objectAtIndex:row];
    }
    else if([pickerView tag] == 1)
    {
            return [temps objectAtIndex:row];
    }
    else if([pickerView tag] == 2)
    {
            return [weights objectAtIndex:row];
    } else {
        return 0;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    MySingletonClass *global = [MySingletonClass sharedSingleton];
    global.prefDistance = [pickerView selectedRowInComponent:0];
    global.prefTemp = [pickerView selectedRowInComponent:0];
    global.prefWeight = [pickerView selectedRowInComponent:0];

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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
