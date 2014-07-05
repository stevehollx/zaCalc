//
//  savedRecipesTableViewController.m
//  zaCalc
//
//  Created by sholl on 3/31/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import "savedRecipesTableViewController.h"

@interface savedRecipesTableViewController ()

@end

@implementation savedRecipesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _recipeArray = [[defaults objectForKey:@"recipeArray"] mutableCopy];

    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Load aray at first run an set to NP
    
   if (![defaults objectForKey:@"firstRunRecipe"]) {
        [defaults setObject:[NSDate date] forKey:@"firstRunRecipe"];
    
        _recipeArray  = [[NSMutableArray alloc] init];
    
        //set stock recipes
        //     quantity, diameter, thickness, hydration, salt, oil, sugar

        NSMutableArray *recipe1;
        recipe1 = [[NSMutableArray alloc] init];
        recipe1 = [NSMutableArray arrayWithObjects:@"Neapolitan",@"1",@"13",@".070",@"62.5",@"3",@"0",@"0",nil];
        [_recipeArray insertObject:recipe1 atIndex:_recipeArray.count];
         
        NSMutableArray *recipe2;
        recipe2 = [[NSMutableArray alloc] init];
        recipe2 = [NSMutableArray arrayWithObjects:@"NY",@"1",@"16",@".085",@"60",@"1.5",@"1.0",@"0",nil];
        [_recipeArray insertObject:recipe2 atIndex:_recipeArray.count];
    
       NSMutableArray *recipe3;
       recipe3 = [[NSMutableArray alloc] init];
       recipe3 = [NSMutableArray arrayWithObjects:@"Thin Crust",@"1",@"14",@".085",@"36",@"1.2",@"3.5",@"1.2",nil];
       [_recipeArray insertObject:recipe3 atIndex:_recipeArray.count];
       
       NSMutableArray *recipe4;
       recipe4 = [[NSMutableArray alloc] init];
       recipe4 = [NSMutableArray arrayWithObjects:@"Deep Dish",@"1",@"12",@".135",@"52",@"1",@"15",@"0",nil];
       [_recipeArray insertObject:recipe4 atIndex:_recipeArray.count];
    
       
        [defaults setInteger:0 forKey:@"selectedRecipe"];
           
        //save recipe array to user def
        [defaults setObject:_recipeArray forKey:@"recipeArray"];
        [defaults synchronize];
       
   } else {
       _recipeArray = [[defaults objectForKey:@"recipeArray"] mutableCopy];
     }
             
    //load preselected recipe parameers into memory
    [defaults setFloat:[[[_recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:1] floatValue] forKey:@"quantityN"];
    [defaults setFloat:[[[_recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:2] floatValue] forKey:@"diameterN"];
    [defaults setFloat:[[[_recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:3] floatValue] forKey:@"thicknessN"];
    [defaults setFloat:[[[_recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:4] floatValue] forKey:@"hydrationN"];
    [defaults setFloat:[[[_recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:5] floatValue] forKey:@"saltN"];
    [defaults setFloat:[[[_recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:6] floatValue] forKey:@"oilN"];
    [defaults setFloat:[[[_recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:7] floatValue] forKey:@"sugarN"];
    [defaults synchronize];

    [self.tableView reloadData];
    
        self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0 && indexPath.row==0) {
        [self performSegueWithIdentifier:@"newRecipeSegue" sender:self];

    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return 1;
    }
    
    else if(section == 1) {
        return _recipeArray.count;
    }
    
    else { // do nothing
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Customize", @"Customize");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Recipe Book", @"Recipe Book");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"Add a New Recipe";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }

        NSMutableArray *recipe = [self.recipeArray objectAtIndex:indexPath.row];

        cell.textLabel.text = [recipe objectAtIndex:0];
        return cell;
    }
    else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    
}



 





/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){ return NO; } else return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        //remove item from data source
        [_recipeArray removeObjectAtIndex:(int)indexPath.row];
        
        //save recipe array to user def
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        [defaults setObject:_recipeArray forKey:@"recipeArray"];
        [defaults synchronize];
        
        //remove from tableview
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}






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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
