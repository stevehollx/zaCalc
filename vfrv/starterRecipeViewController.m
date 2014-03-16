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
    
    MySingletonClass *global = [MySingletonClass sharedSingleton];
    prefermentAmount.text = [NSString stringWithFormat:@"%.02f",global.prefermentAmountN];
    if( global.prefDistance == 0) {
        distanceS = @"(inches)";
    }
    else {
        distanceS = @"(cm)";
    }
    
    lDistance.text = distanceS;
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

 
    MySingletonClass *global = [MySingletonClass sharedSingleton];

	global.quantityN= [quantityS floatValue];
	global.diameterN = [diameterS floatValue];
    global.thicknessN = [thicknessS floatValue];
	global.hydrationN = [hydrationS floatValue];
	global.prefermentAmountN = [prefermentAmountS floatValue];
    global.prefermentHydrationN = [prefermentHydrationS floatValue];
	global.saltN = [saltS floatValue];
    global.oilN = [oilS floatValue];
	global.sugarN = [sugarS floatValue];
	global.wasteN = [wasteS floatValue];
    
    
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
