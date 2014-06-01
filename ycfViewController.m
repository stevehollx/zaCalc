//
//  ycfViewController.m
//  zaCalc
//
//  Created by sholl on 5/31/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import "ycfViewController.h"

@interface ycfViewController ()

@end

@implementation ycfViewController

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    ycf.text = [NSString stringWithFormat: @"%f", [defaults floatForKey:@"ycfN"]];
    
    NSString *sYcf = ycf.text;
    [defaults setFloat:[sYcf floatValue] forKey:@"ycfN"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeKeyboard {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sYcf = ycf.text;
    [defaults setFloat:[sYcf floatValue] forKey:@"ycfN"];

    [defaults synchronize];

	//Here we are closing the keyboard for both of the tfTimes.
	[ycf resignFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        // Do your stuff here

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sYcf = ycf.text;
    [defaults setFloat:[sYcf floatValue] forKey:@"ycfN"];
    
    [defaults synchronize];
    
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

 NSString *sYcf = ycf.text;
 [defaults setFloat:[sYcf floatValue] forKey:@"ycfN"];
 
 [defaults synchronize];
 

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

@end
