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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    if (![defaults objectForKey:@"firstRunSettings"]) {
        [defaults setObject:[NSDate date] forKey:@"firstRunSettings"];
        [defaults setInteger:0 forKey:@"prefTemp"];
        [defaults setInteger:0 forKey:@"prefDistance"];
        [defaults setInteger:0 forKey:@"prefWeight"];
        [defaults synchronize];
        
    }
    
    [defaults synchronize];
    
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (indexPath.section == 0) {
        if (indexPath.row==[defaults integerForKey:@"prefDistance"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row==[defaults integerForKey:@"prefTemp"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row==[defaults integerForKey:@"prefWeight"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];

    int settingDistance = (int)[defaults integerForKey:@"prefDistance"];

    if (indexPath.section == 0)
    {
        NSNumber *rowNumber = [NSNumber numberWithUnsignedInt:(int)indexPath.row];


        //get selected cell
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        //if cell isn't currently selected do something
         if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            //get old selected cell and remove mark on it
            UITableViewCell *oldSelection = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:settingDistance inSection:0]];
            oldSelection.accessoryType = UITableViewCellAccessoryNone;

            //mark new cell
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            //set global values
            [defaults setInteger:indexPath.row forKey:@"prefDistance"];
            [defaults synchronize];
            
            if ( [firstSelectedCellsArray containsObject:rowNumber]  )
            {
                [firstSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [firstSelectedCellsArray addObject:rowNumber];
            }
        }
    }
    

        int settingTemp = (int)[defaults integerForKey:@"prefTemp"];
   
        if (indexPath.section == 1)
        {
            NSNumber *rowNumber = [NSNumber numberWithUnsignedInt:(int)indexPath.row];
            
            
            //get selected cell
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            //if cell isn't currently selected do something
            if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
            {
                //get old selected cell and remove mark on it
                UITableViewCell *oldSelection = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:settingTemp inSection:1]];
                oldSelection.accessoryType = UITableViewCellAccessoryNone;
                
                //mark new cell
                selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                //set global values
                [defaults setInteger:indexPath.row forKey:@"prefTemp"];
                [defaults synchronize];
                
                if ( [secondSelectedCellsArray containsObject:rowNumber]  )
                {
                    [secondSelectedCellsArray removeObject:rowNumber];
                }
                else
                {
                    [secondSelectedCellsArray addObject:rowNumber];
                }
            }

        }


        int settingWeight = (int)[defaults integerForKey:@"prefWeight"];
            
            if (indexPath.section == 2)
            {
                NSNumber *rowNumber = [NSNumber numberWithUnsignedInt:(int)indexPath.row];
                
                
                //get selected cell
                UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
                //if cell isn't currently selected do something
                if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
                {
                    //get old selected cell and remove mark on it
                    UITableViewCell *oldSelection = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:settingWeight inSection:2]];
                    oldSelection.accessoryType = UITableViewCellAccessoryNone;
                    
                    //mark new cell
                    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                    //set global values
                    [defaults setInteger:indexPath.row forKey:@"prefWeight"];
                    [defaults synchronize];
                    
                    if ( [ThirdSelectedCellsArray containsObject:rowNumber]  )
                    {
                        [ThirdSelectedCellsArray removeObject:rowNumber];
                    }
                    else
                    {
                        [ThirdSelectedCellsArray addObject:rowNumber];
                    }
            }
  
        
        }
        
}



-(IBAction)closeKeyboard {
	//Here we are closing the keyboard for both of the textfields.
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
