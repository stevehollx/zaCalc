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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

 //imported global variables from singleton
    
    float DoughWeightN;
    float BallWeightN;
    float SugarN;
    float OilN;
    float SaltN;
    float WaterN;
    float RemainingFlourN;
    float InitFlourN;
    NSString *unitsS;
    NSString *units2S;
    NSString *units3S;
    NSString *units4S;
    
    BallWeightN = 3.1415 * pow(([defaults floatForKey:@"diameterN"]/2),2) * [defaults floatForKey:@"thicknessN"] * 28.3495;
    DoughWeightN = BallWeightN * (1 + [defaults floatForKey:@"wasteN"]/100) * [defaults floatForKey:@"quantityN"];
  
    float totalFlour = DoughWeightN / ([defaults floatForKey:@"hydrationN"]/100 + 1 + [defaults floatForKey:@"saltN"]/100 + [defaults floatForKey:@"oilN"]/100 + [defaults floatForKey:@"sugarN"]/100) - ([defaults floatForKey:@"prefermentAmountN"]/100 * [defaults floatForKey:@"prefermentHydrationN"]);
    
    float totalPreferment = totalFlour * [defaults floatForKey:@"prefermentAmountN"]/100;
    float prefermentFlour = totalPreferment * (1-[defaults floatForKey:@"prefermentHydrationN"]/200);
    
    
    SugarN = (totalFlour + prefermentFlour) * [defaults floatForKey:@"sugarN"]/100;
    OilN = (totalFlour + prefermentFlour) * [defaults floatForKey:@"oilN"]/100;
    SaltN = (totalFlour + prefermentFlour) * [defaults floatForKey:@"saltN"]/100;
    WaterN = (totalFlour + prefermentFlour) * [defaults floatForKey:@"hydrationN"]/100 - (totalPreferment * [defaults floatForKey:@"prefermentHydrationN"]/200) - OilN;
    RemainingFlourN = totalFlour * 1/3;
    InitFlourN = totalFlour * 2/3;
    
    if( [defaults integerForKey:@"prefWeight"] == 0 ) {
        unitsS= @" g";
        units2S= @" g";
        units3S= @" g";
        units4S= @" g";
    } else if ([defaults integerForKey:@"prefWeight"] == 1) {
        unitsS= @" oz";
        units2S= @" oz";
        units3S= @" oz";
        units4S= @" oz";
        DoughWeightN = DoughWeightN * .035274;
        BallWeightN = BallWeightN * .035274;
        SugarN = SugarN * .035274;
        OilN = OilN * .035274;
        SaltN = SaltN * .035274;
        totalPreferment = totalPreferment * .035274;
        WaterN = WaterN * .035274;
        RemainingFlourN = RemainingFlourN * .035274;
        InitFlourN = InitFlourN * .035274;
        
    } else { //convert to volumes
        unitsS= @" cu";
        units2S= @" tsp";
        units3S= @" Tbs";
        units4S= @" oz";
        DoughWeightN = DoughWeightN * .035274;
        BallWeightN = BallWeightN * .035274;
        totalPreferment = totalPreferment / 17;

        OilN = OilN / 15;
        WaterN = WaterN * .00423;
        SaltN = SaltN * .18;
        RemainingFlourN = RemainingFlourN / 125;
        InitFlourN = InitFlourN / 125;
        SugarN = SugarN * 0.0796812749;

    }
    
    lDoughWeight.text = [NSString stringWithFormat:@"%.02f",DoughWeightN];
    lDoughWeight.text = [lDoughWeight.text stringByAppendingString:units4S];
    
    lBallWeight.text = [NSString stringWithFormat:@"%.02f",BallWeightN];
    lBallWeight.text = [lBallWeight.text stringByAppendingString:units4S];

    lSugar.text = [NSString stringWithFormat:@"%.02f",SugarN];
    lSugar.text = [lSugar.text stringByAppendingString:units3S];

    lOil.text = [NSString stringWithFormat:@"%.02f",OilN];
    lOil.text = [lOil.text stringByAppendingString:units3S];
    
    lSalt.text = [NSString stringWithFormat:@"%.02f",SaltN];
    lSalt.text = [lSalt.text stringByAppendingString:units2S];
    
    lPreferment.text = [NSString stringWithFormat:@"%.02f",totalPreferment];
    lPreferment.text = [lPreferment.text stringByAppendingString:units3S];

    lWater.text = [NSString stringWithFormat:@"%.02f",WaterN];
    lWater.text = [lWater.text stringByAppendingString:unitsS];
    
    lRemainingFlour.text = [NSString stringWithFormat:@"%.02f",RemainingFlourN];
    lRemainingFlour.text = [lRemainingFlour.text stringByAppendingString:unitsS];
    
    lInitFlour.text = [NSString stringWithFormat:@"%.02f",InitFlourN];
    lInitFlour.text = [lInitFlour.text stringByAppendingString:unitsS];
    
    [defaults synchronize];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
