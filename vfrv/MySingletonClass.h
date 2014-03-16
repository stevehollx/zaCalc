//
//  MySingletonClass.h
//  GlobalSingletonTut
//
//  Created by Emir Fithri Samsuddin on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySingletonClass : UIViewController {
  
    float quantityN;
    float diameterN;
    float thicknessN;
    float hydrationN;
    float prefermentAmountN;
    float prefermentHydrationN;
    float saltN;
    float oilN;
    float sugarN;
    float wasteN;
    int prefTemp;
    int prefDistance;
    int prefWeight;
    NSArray *_volume; //huh?
}


@property(nonatomic, assign) float  quantityN;
@property(nonatomic, assign) float  diameterN;
@property(nonatomic, assign) float  thicknessN;
@property(nonatomic, assign) float  hydrationN;
@property(nonatomic, assign) float  prefermentAmountN;
@property(nonatomic, assign) float  prefermentHydrationN;
@property(nonatomic, assign) float  saltN;
@property(nonatomic, assign) float  oilN;
@property(nonatomic, assign) float  sugarN;
@property(nonatomic, assign) float  wasteN;
@property(nonatomic, assign) int  prefTemp;
@property(nonatomic, assign) int  prefDistance;
@property(nonatomic, assign) int  prefWeight;

+ (MySingletonClass *)sharedSingleton;


@end
