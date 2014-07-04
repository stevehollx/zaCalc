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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //Load aray at first run an set to NP
    
   if (![defaults objectForKey:@"firstRunRecipe"]) {
        [defaults setObject:[NSDate date] forKey:@"firstRunRecipe"];
    
        recipeArray  = [[NSMutableArray alloc] init];
    
        //set stock recipes
        //     quantity, diameter, thickness, hydration, salt, oil, sugar

        NSMutableArray *recipe1;
        recipe1 = [[NSMutableArray alloc] init];
        recipe1 = [NSMutableArray arrayWithObjects:@"Neapolitan",@"1",@"13",@".070",@"62.5",@"3",@"0",@"0",nil];
        [recipeArray insertObject:recipe1 atIndex:recipeArray.count];
         
        NSMutableArray *recipe2;
        recipe2 = [[NSMutableArray alloc] init];
        recipe2 = [NSMutableArray arrayWithObjects:@"NY",@"1",@"16",@".085",@"60",@"1.5",@"1.0",@"0",nil];
        [recipeArray insertObject:recipe2 atIndex:recipeArray.count];
    
       NSMutableArray *recipe3;
       recipe3 = [[NSMutableArray alloc] init];
       recipe3 = [NSMutableArray arrayWithObjects:@"Thin Crust",@"1",@"14",@".085",@"36",@"1.2",@"3.5",@"1.2",nil];
       [recipeArray insertObject:recipe3 atIndex:recipeArray.count];
       
       NSMutableArray *recipe4;
       recipe4 = [[NSMutableArray alloc] init];
       recipe4 = [NSMutableArray arrayWithObjects:@"Deep Dish",@"1",@"12",@".135",@"52",@"1",@"15",@"0",nil];
       [recipeArray insertObject:recipe4 atIndex:recipeArray.count];
    
       
        [defaults setInteger:0 forKey:@"selectedRecipe"];
    
        //save recipe array to user def
        [defaults setObject:recipeArray forKey:@"recipeArray"];
    
        [defaults synchronize];
        
   } else {
       recipeArray = [defaults objectForKey:@"recipeArray"];
   }
             
    //load preselected recipe parameers into memory
    [defaults setFloat:[[[recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:1] floatValue] forKey:@"quantityN"];
    [defaults setFloat:[[[recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:2] floatValue] forKey:@"diameterN"];
    [defaults setFloat:[[[recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:3] floatValue] forKey:@"thicknessN"];
    [defaults setFloat:[[[recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:4] floatValue] forKey:@"hydrationN"];
    [defaults setFloat:[[[recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:5] floatValue] forKey:@"saltN"];
    [defaults setFloat:[[[recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:6] floatValue] forKey:@"oilN"];
    [defaults setFloat:[[[recipeArray objectAtIndex:[defaults integerForKey:@"selectedRecipe"]] objectAtIndex:7] floatValue] forKey:@"sugarN"];
/*
    [recipePicker selectRow:[defaults integerForKey:@"selectedRecipe"] inComponent:0 animated:YES];
    [recipePicker reloadAllComponents];

    [defaults synchronize];
  */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidAppear:(BOOL)animated {
    [self loadPicker];

}

- (void)loadPicker {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"pickerloaded");

    recipeArray = [defaults objectForKey:@"recipeArray"];
    [recipePicker selectRow:[defaults integerForKey:@"selectedRecipe"] inComponent:0 animated:YES];
    
    [recipePicker reloadAllComponents];
    
    [defaults synchronize];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}





-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
   /* if ([pickerView tag] == 0) {
        return sizeof(recipes);
    } else { return 0; } */
    return recipeArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
   /* if ([pickerView tag] == 0) {
        return [recipes objectAtIndex:row];
    } else {
        return 0;
    }
    */
    return recipeArray[row][0];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([pickerView tag] == 0) {
        [defaults setInteger:[pickerView selectedRowInComponent:0] forKey:@"selectedRecipe"];
        
        //load selected recipe parameers into memory
        [defaults setFloat:[[[recipeArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectAtIndex:1] floatValue] forKey:@"quantityN"];
        [defaults setFloat:[[[recipeArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectAtIndex:2] floatValue] forKey:@"diameterN"];
        [defaults setFloat:[[[recipeArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectAtIndex:3] floatValue] forKey:@"thicknessN"];
        [defaults setFloat:[[[recipeArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectAtIndex:4] floatValue] forKey:@"hydrationN"];
        [defaults setFloat:[[[recipeArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectAtIndex:5] floatValue] forKey:@"saltN"];
        [defaults setFloat:[[[recipeArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectAtIndex:6] floatValue] forKey:@"oilN"];
        [defaults setFloat:[[[recipeArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectAtIndex:7] floatValue] forKey:@"sugarN"];
        
        [defaults synchronize];
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
