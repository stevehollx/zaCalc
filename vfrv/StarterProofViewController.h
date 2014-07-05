// iOS Dev Tutorial series on http://mobileorchard.com

#import <UIKit/UIKit.h>

@interface StarterProofViewController : UIViewController <UITextFieldDelegate>{
	//Here we are declaring the outlet for the textfields
	IBOutlet UITextField *tfTime1;
	IBOutlet UITextField *tfTime2;
    IBOutlet UITextField *tfTime3;
    IBOutlet UITextField *tfTime4;
    IBOutlet UITextField *tfTime5;
	//Here we are declaring the outlet for the label
	IBOutlet UILabel *lTotalTime;
    
    IBOutlet UITextField *tfTemp1;
	IBOutlet UITextField *tfTemp2;
    IBOutlet UITextField *tfTemp3;
    IBOutlet UITextField *tfTemp4;
    IBOutlet UITextField *tfTemp5;
    
	//Here we are declaring the outlet for the label
	IBOutlet UILabel *starterPercent;
    IBOutlet UILabel *tempUnit;
    
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
    
    CGPoint originalCenter;

}


//This is the IBAction that is triggered when you press the calculate button.
-(IBAction)calculate;
//This is the IBAction that is triggered when you press the background button that closes the keyboard.
-(IBAction)closeKeyboard;

@end

