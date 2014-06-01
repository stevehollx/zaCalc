//
//  starterRecipeViewController.m
//  
//
//  Created by sholl on 2/4/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import "starterRecipeViewController.h"
#import "MySingletonClass.h"

@implementation starterRecipeViewController

-(IBAction)viewDidLoad {

   NSString *distanceS = @"(inches)";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    
    prefermentAmount.text = [NSString stringWithFormat:@"%.2f",[defaults floatForKey:@"prefermentAmountN"]];
    
    if( [defaults integerForKey:@"prefDistance"] == 0 ) {
        distanceS = @"(inches)";
    }
    else {
        distanceS = @"(cm)";
    }

    lDistance.text = distanceS;
    
    
}

//This is a fix for when the tab has loaded and the user switches back to the preferment tab to change, since navigating back to recipe doesn't update values.
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    prefermentAmount.text = [NSString stringWithFormat:@"%.2f",[defaults floatForKey:@"prefermentAmountN"]];
}


-(IBAction)calculate {
    
	NSString *quantityS = quantity.text;
	NSString *diameterS = diameter.text;
	NSString *thicknessS = thickness.text;
	NSString *hydrationS = hydration.text;
    NSString *prefermentAmountS = prefermentAmount.text;
    NSString *prefermentHydrationS = prefermentHydration.text;
	NSString *saltS = salt.text;
	NSString *oilS = oil.text;
	NSString *sugarS = sugar.text;
	NSString *wasteS = waste.text;

 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];

    [defaults setFloat:[quantityS floatValue] forKey:@"quantityN"];
    [defaults setFloat:[diameterS floatValue] forKey:@"diameterN"];
    [defaults setFloat:[thicknessS floatValue] forKey:@"thicknessN"];
    [defaults setFloat:[hydrationS floatValue] forKey:@"hydrationN"];
    [defaults setFloat:[prefermentAmountS floatValue] forKey:@"prefermentAmountN"];
    [defaults setFloat:[prefermentHydrationS floatValue] forKey:@"prefermentHydrationN"];
    [defaults setFloat:[saltS floatValue] forKey:@"saltN"];
    [defaults setFloat:[oilS floatValue] forKey:@"oilN"];
    [defaults setFloat:[sugarS floatValue] forKey:@"sugarN"];
    [defaults setFloat:[wasteS floatValue] forKey:@"wasteS"];
    
    if( [defaults integerForKey:@"prefDistance"] == 1) {
        [defaults setInteger:[defaults integerForKey:@"prefDistance"] * 0.39370 forKey:@"diameterN"];

    }
    
    [defaults synchronize];
    
}

-(IBAction)closeKeyboard {
	//Here we are closing the keyboard for both of the textfields.
	[quantity resignFirstResponder];
	[diameter resignFirstResponder];
    [thickness resignFirstResponder];
    [hydration resignFirstResponder];
    [prefermentAmount resignFirstResponder];
    [prefermentHydration resignFirstResponder];
    [salt resignFirstResponder];
    [oil resignFirstResponder];
    [sugar resignFirstResponder];
    [waste resignFirstResponder];
}
-(void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
-(void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
-(void)dealloc {
    //nothing here
}
@end
