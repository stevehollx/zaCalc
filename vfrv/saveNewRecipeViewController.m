//
//  saveNewRecipeViewController.m
//  zaCalc
//
//  Created by sholl on 3/31/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import "saveNewRecipeViewController.h"

@interface saveNewRecipeViewController ()

@end

@implementation saveNewRecipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    originalCenter = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveRecipe:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *recipeArray = [[defaults objectForKey:@"recipeArray"] mutableCopy];

    NSString *recipeNameS = recipeName.text;
    NSNumber *quantityN = [NSNumber numberWithFloat:[quantity.text floatValue]];
    NSNumber *diameterN = [NSNumber numberWithFloat:[diameter.text floatValue]];
    NSNumber *thicknessN = [NSNumber numberWithFloat:[thickness.text floatValue]];
    NSNumber *hydrationN = [NSNumber numberWithFloat:[hydration.text floatValue]];
    NSNumber *saltN = [NSNumber numberWithFloat:[salt.text floatValue]];
    NSNumber *oilN = [NSNumber numberWithFloat:[oil.text floatValue]];
    NSNumber *sugarN = [NSNumber numberWithFloat:[sugar.text floatValue]];

    NSMutableArray *newRecipe = [[NSMutableArray alloc] init];
    newRecipe = [NSMutableArray arrayWithObjects:recipeNameS,quantityN,diameterN,thicknessN,hydrationN,saltN,oilN,sugarN,nil];
    [recipeArray insertObject:newRecipe atIndex:recipeArray.count];
    
    //save recipe array to user def
    [defaults setObject:recipeArray forKey:@"recipeArray"];
    
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES]; //simulates pressing back

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag==8 || textField.tag==9 ) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self->originalCenter.x,self->originalCenter.x-50);
    [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==8 || textField.tag==9 ) {

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = self->originalCenter;
        [UIView commitAnimations];
    }
}


-(IBAction)closeKeyboard {
	//Here we are closing the keyboard for both of the tfTimes.
	[quantity resignFirstResponder];
    [diameter resignFirstResponder];
    [thickness resignFirstResponder];
    [hydration resignFirstResponder];
    [salt resignFirstResponder];
    [sugar resignFirstResponder];
    [recipeName resignFirstResponder];
    [oil resignFirstResponder];


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[quantity resignFirstResponder];
    [diameter resignFirstResponder];
    [thickness resignFirstResponder];
    [hydration resignFirstResponder];
    [salt resignFirstResponder];
    [sugar resignFirstResponder];
    [recipeName resignFirstResponder];
    [oil resignFirstResponder];

    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
	[quantity resignFirstResponder];
    [diameter resignFirstResponder];
    [thickness resignFirstResponder];
    [hydration resignFirstResponder];
    [salt resignFirstResponder];
    [sugar resignFirstResponder];
    [recipeName resignFirstResponder];
    [oil resignFirstResponder];

    return YES;
}

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
