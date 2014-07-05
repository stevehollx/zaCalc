//
//  starterRecipeViewController.h
//  vfrv
//
//  Created by sholl on 2/4/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface starterRecipeViewController : UIViewController<UITextFieldDelegate> {
    IBOutlet UITextField *quantity;
    IBOutlet UITextField *diameter;
    IBOutlet UITextField *thickness;
    IBOutlet UITextField *hydration;
    IBOutlet UITextField *prefermentAmount;
    IBOutlet UITextField *prefermentHydration;
    IBOutlet UITextField *salt;
    IBOutlet UITextField *oil;
    IBOutlet UITextField *sugar;
    IBOutlet UITextField *waste;
    IBOutlet UILabel *lDistance;
    CGPoint originalCenter;

}


//This is the IBAction that is triggered when you press the calculate button.
-(IBAction)calculate;
//This is the IBAction that is triggered when you press the background button that closes the keyboard.
-(IBAction)closeKeyboard;

    @end
