// iOS Dev Tutorial series on http://mobileorchard.com

#import "StarterProofViewController.h"
#import "MySingletonClass.h"

@implementation StarterProofViewController
-(IBAction)calculate {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

	//Here we are creating two strings and assigning the value of the tfTimes to the strings.
	NSString *sTime1 = tfTime1.text;
	NSString *sTime2 = tfTime2.text;
	NSString *sTime3 = tfTime3.text;
	NSString *sTime4 = tfTime4.text;
	NSString *sTime5 = tfTime5.text;
    
    NSString *sTemp1 = tfTemp1.text;
	NSString *sTemp2 = tfTemp2.text;
	NSString *sTemp3 = tfTemp3.text;
	NSString *sTemp4 = tfTemp4.text;
	NSString *sTemp5 = tfTemp5.text;
    

    
	//Here we are assigning the values 
	fTime1 = [sTime1 floatValue];
	fTime2 = [sTime2 floatValue];
    fTime3 = [sTime3 floatValue];
	fTime4 = [sTime4 floatValue];
	fTime5 = [sTime5 floatValue];

    fTemp1 = [sTemp1 floatValue];
	fTemp2 = [sTemp2 floatValue];
    fTemp3 = [sTemp3 floatValue];
	fTemp4 = [sTemp4 floatValue];
	fTemp5 = [sTemp5 floatValue];
    
    
    //conver to F if needed
    if( [defaults integerForKey:@"prefTemp"]  == 1) {
        fTemp1 = fTemp1 * 9/5 + 32;
        fTemp2 = fTemp2 * 9/5 + 32;
        fTemp3 = fTemp3 * 9/5 + 32;
        fTemp4 = fTemp4 * 9/5 + 32;
        fTemp5 = fTemp5 * 9/5 + 32;
    }
    
    
	//Now we are going to add the two integers and assign the value to the output integer.
	fOutput = fTime1 + fTime2 + fTime3 + fTime4 + fTime5;
    starterPercentOutput =89.4/(pow(2,((fTime1/((((((((((-0.0000336713*(pow(fTemp1,4)))+(0.0105207916*(pow(fTemp1,3))))-(1.2495985607*(pow(fTemp1,2))))+(67.0024722564*fTemp1))-1374.6540546564)*log((.01)))+ (((((-0.000003773*(pow(fTemp1,4))) +( 0.0011788625*(pow(fTemp1,3)))) -( 0.1400139318*(pow(fTemp1,2)))) +( 7.5072379375*fTemp1)) - 154.0188143761))-(((((((-0.0000336713*(pow(fTemp1,4)))+(0.0105207916*(pow(fTemp1,3))))-(1.2495985607*(pow(fTemp1,2))))+(67.0024722564*fTemp1))-1374.6540546564)*log((.4)))+ (((((-0.000003773*(pow(fTemp1,4))) +( 0.0011788625*(pow(fTemp1,3)))) -( 0.1400139318*(pow(fTemp1,2)))) +( 7.5072379375*fTemp1)) - 154.0188143761)))/(log((40))/log(2))))
    +
    fTime2/((((((((((-0.0000336713*(pow(fTemp2,4)))+(0.0105207916*(pow(fTemp2,3))))-(1.2495985607*(pow(fTemp2,2))))+(67.0024722564*fTemp2))-1374.6540546564)*log((.01)))+ (((((-0.000003773*(pow(fTemp2,4))) +( 0.0011788625*(pow(fTemp2,3)))) -( 0.1400139318*(pow(fTemp2,2)))) +( 7.5072379375*fTemp2)) - 154.0188143761))-(((((((-0.0000336713*(pow(fTemp2,4)))+(0.0105207916*(pow(fTemp2,3))))-(1.2495985607*(pow(fTemp2,2))))+(67.0024722564*fTemp2))-1374.6540546564)*log((.4)))+ (((((-0.000003773*(pow(fTemp2,4))) +( 0.0011788625*(pow(fTemp2,3)))) -( 0.1400139318*(pow(fTemp2,2)))) +( 7.5072379375*fTemp2)) - 154.0188143761)))/(log((40))/log(2))))
    +
    fTime3/((((((((((-0.0000336713*(pow(fTemp3,4)))+(0.0105207916*(pow(fTemp3,3))))-(1.2495985607*(pow(fTemp3,2))))+(67.0024722564*fTemp3))-1374.6540546564)*log((.01)))+ (((((-0.000003773*(pow(fTemp3,4))) +( 0.0011788625*(pow(fTemp3,3)))) -( 0.1400139318*(pow(fTemp3,2)))) +( 7.5072379375*fTemp3)) - 154.0188143761))-(((((((-0.0000336713*(pow(fTemp3,4)))+(0.0105207916*(pow(fTemp3,3))))-(1.2495985607*(pow(fTemp3,2))))+(67.0024722564*fTemp3))-1374.6540546564)*log((.4)))+ (((((-0.000003773*(pow(fTemp3,4))) +( 0.0011788625*(pow(fTemp3,3)))) -( 0.1400139318*(pow(fTemp3,2)))) +( 7.5072379375*fTemp3)) - 154.0188143761)))/(log((40))/log(2))))
    +
    fTime4/((((((((((-0.0000336713*(pow(fTemp4,4)))+(0.0105207916*(pow(fTemp4,3))))-(1.2495985607*(pow(fTemp4,2))))+(67.0024722564*fTemp4))-1374.6540546564)*log((.01)))+ (((((-0.000003773*(pow(fTemp4,4))) +( 0.0011788625*(pow(fTemp4,3)))) -( 0.1400139318*(pow(fTemp4,2)))) +( 7.5072379375*fTemp4)) - 154.0188143761))-(((((((-0.0000336713*(pow(fTemp4,4)))+(0.0105207916*(pow(fTemp4,3))))-(1.2495985607*(pow(fTemp4,2))))+(67.0024722564*fTemp4))-1374.6540546564)*log((.4)))+ (((((-0.000003773*(pow(fTemp4,4))) +( 0.0011788625*(pow(fTemp4,3)))) -( 0.1400139318*(pow(fTemp4,2)))) +( 7.5072379375*fTemp4)) - 154.0188143761)))/(log((40))/log(2))))
    +
    fTime5/((((((((((-0.0000336713*(pow(fTemp5,4)))+(0.0105207916*(pow(fTemp5,3))))-(1.2495985607*(pow(fTemp5,2))))+(67.0024722564*fTemp5))-1374.6540546564)*log((.01)))+ (((((-0.000003773*(pow(fTemp5,4))) +( 0.0011788625*(pow(fTemp5,3)))) -( 0.1400139318*(pow(fTemp5,2)))) +( 7.5072379375*fTemp5)) - 154.0188143761))-(((((((-0.0000336713*(pow(fTemp5,4)))+(0.0105207916*(pow(fTemp5,3))))-(1.2495985607*(pow(fTemp5,2))))+(67.0024722564*fTemp5))-1374.6540546564)*log((.4)))+ (((((-0.000003773*(pow(fTemp5,4))) +( 0.0011788625*(pow(fTemp5,3)))) -( 0.1400139318*(pow(fTemp5,2)))) +( 7.5072379375*fTemp5)) - 154.0188143761)))/(log((40))/log(2))))))));

    //Correct for yeast correction factor
    starterPercentOutput = starterPercentOutput * [defaults floatForKey:@"ycfN"];
    
	//Now we are going to display the output in the label.
	lTotalTime.text = [NSString stringWithFormat:@"%.01f",fOutput];
    lTotalTime.text = [lTotalTime.text stringByAppendingString:@"h"];
    starterPercent.text = [NSString stringWithFormat:@"%.02f",starterPercentOutput];
    starterPercent.text = [starterPercent.text stringByAppendingString:@"%"];
    
    //store preferment amount in memory
    [defaults setFloat:starterPercentOutput forKey:@"prefermentAmountN"];
    
    //save user settings
    [defaults setFloat:fTime1 forKey:@"fTime1N"];
    [defaults setFloat:fTime2 forKey:@"fTime2N"];
    [defaults setFloat:fTime3 forKey:@"fTime3N"];
    [defaults setFloat:fTime4 forKey:@"fTime4N"];
    [defaults setFloat:fTime5 forKey:@"fTime5N"];
    
    [defaults setFloat:fTemp1 forKey:@"fTemp1N"];
    [defaults setFloat:fTemp2 forKey:@"fTemp2N"];
    [defaults setFloat:fTemp3 forKey:@"fTemp3N"];
    [defaults setFloat:fTemp4 forKey:@"fTemp4N"];
    [defaults setFloat:fTemp5 forKey:@"fTemp5N"];
    
    [defaults synchronize];
}
-(IBAction)closeKeyboard {
	//Here we are closing the keyboard for both of the tfTimes.
	[tfTime1 resignFirstResponder];
	[tfTime2 resignFirstResponder];
    [tfTime3 resignFirstResponder];
    [tfTime4 resignFirstResponder];
    [tfTime5 resignFirstResponder];

    [tfTemp1 resignFirstResponder];
    [tfTemp2 resignFirstResponder];
    [tfTemp3 resignFirstResponder];
    [tfTemp4 resignFirstResponder];
    [tfTemp5 resignFirstResponder];
}
-(void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
-(void)viewDidLoad {
    
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    //MySingletonClass *global = [MySingletonClass sharedSingleton];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    tempUnit.text = @"(F)";
    
    //conver to F if needed
    if( [defaults integerForKey:@"prefTemp"] ) {
        tempUnit.text = @"(C)";
    }
    
    //load last saved settings
    tfTime1.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTime1N"]];
    tfTime2.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTime2N"]];
    tfTime3.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTime13"]];
    tfTime4.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTime4N"]];
    tfTime5.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTime5N"]];
    
    tfTemp1.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTemp1N"]];
    tfTemp2.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTemp2N"]];
    tfTemp3.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTemp13"]];
    tfTemp4.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTemp4N"]];
    tfTemp5.text = [NSString stringWithFormat:@"%.01f",[defaults floatForKey:@"fTemp5N"]];
    
   [defaults synchronize];
}




- (void)viewWillDisappear:(BOOL)animated {
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //save user settings
    [defaults setFloat:[tfTime1.text floatValue] forKey:@"fTime1N"];
    [defaults setFloat:[tfTime2.text floatValue] forKey:@"fTime2N"];
    [defaults setFloat:[tfTime3.text floatValue] forKey:@"fTime3N"];
    [defaults setFloat:[tfTime4.text floatValue] forKey:@"fTime4N"];
    [defaults setFloat:[tfTime5.text floatValue] forKey:@"fTime5N"];
    
    [defaults setFloat:[tfTemp1.text floatValue] forKey:@"fTemp1N"];
    [defaults setFloat:[tfTemp2.text floatValue] forKey:@"fTemp2N"];
    [defaults setFloat:[tfTemp3.text floatValue] forKey:@"fTemp3N"];
    [defaults setFloat:[tfTemp4.text floatValue] forKey:@"fTemp4N"];
    [defaults setFloat:[tfTemp5.text floatValue] forKey:@"fTemp5N"];
    
    [defaults synchronize];

}

-(void)dealloc {
	//This release the decleration we made in the header file

}

//}

@end

