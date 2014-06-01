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
    
	//Here we are creating three integers
    float fTime1;
	float fTime2;
    float fTime3;
    float fTime4;
    float fTime5;
	double fOutput;
    
    float fTemp1;
	float fTemp2;
    float fTemp3;
    float fTemp4;
    float fTemp5;
	float starterPercentOutput;
    
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
    NSLog(@"Value of string is %@", [defaults floatForKey:@"ycfN"], starterPercent);
    
	//Now we are going to display the output in the label.
	lTotalTime.text = [NSString stringWithFormat:@"%.01f",fOutput];
    lTotalTime.text = [lTotalTime.text stringByAppendingString:@"h"];
    starterPercent.text = [NSString stringWithFormat:@"%.02f",starterPercentOutput];
    starterPercent.text = [starterPercent.text stringByAppendingString:@"%"];
    
    [defaults setFloat:starterPercentOutput forKey:@"prefermentAmountN"];
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
   [defaults synchronize];
}
-(void)dealloc {
	//This release the decleration we made in the header file

}

//}

@end

