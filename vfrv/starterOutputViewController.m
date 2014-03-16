//
//  starterOutputViewController.m
//  vfrv
//
//  Created by sholl on 2/4/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import "starterOutputViewController.h"
#import "MySingletonClass.h"

@interface starterOutputViewController ()

@end

@implementation starterOutputViewController

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
    
   MySingletonClass *global = [MySingletonClass sharedSingleton];

 //imported global variables from singleton
/*  global.quantityN;
    global.diameterN;
    global.thicknessN;
    global.hydrationN;
    global.prefermentAmountN;
    global.prefermentHydrationN;
    global.saltN;
    global.oilN;
    global.sugarN;
    global.wasteN;
    */
    
    float DoughWeightN;
    float BallWeightN;
    float SugarN;
    float OilN;
    float SaltN;
    float WaterN;
    float RemainingFlourN;
    float InitFlourN;

    BallWeightN = 3.1415 * pow((global.diameterN/2),2) * global.thicknessN * 28.3495;
    DoughWeightN = BallWeightN * (1 + global.wasteN/100) * global.quantityN;
  
    float totalFlour = DoughWeightN / (global.hydrationN/100 + 1 + global.saltN/100 + global.oilN/100 + global.sugarN/100) - (global.prefermentAmountN/100 * global.prefermentHydrationN);
    
    float totalPreferment = totalFlour * global.prefermentAmountN/100;
    float prefermentFlour = totalPreferment * (1-global.prefermentHydrationN/200);
    
    
    
    SugarN = (totalFlour + prefermentFlour) * global.sugarN/100;
    OilN = (totalFlour + prefermentFlour) * global.oilN/100;
    SaltN = (totalFlour + prefermentFlour) * global.saltN/100;
    WaterN = (totalFlour + prefermentFlour) * global.hydrationN/100 - (totalPreferment * global.prefermentHydrationN/200) - OilN;
    RemainingFlourN = totalFlour * 1/3;
    InitFlourN = totalFlour * 2/3;
    
    lDoughWeight.text = [NSString stringWithFormat:@"%.02f",DoughWeightN];
    lBallWeight.text = [NSString stringWithFormat:@"%.02f",BallWeightN];
    lSugar.text = [NSString stringWithFormat:@"%.02f",SugarN];
    lOil.text = [NSString stringWithFormat:@"%.02f",OilN];
    lSalt.text = [NSString stringWithFormat:@"%.02f",SaltN];
    lPreferment.text = [NSString stringWithFormat:@"%.02f",totalPreferment];
    lWater.text = [NSString stringWithFormat:@"%.02f",WaterN];
    lRemainingFlour.text = [NSString stringWithFormat:@"%.02f",RemainingFlourN];
    lInitFlour.text = [NSString stringWithFormat:@"%.02f",InitFlourN];
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
