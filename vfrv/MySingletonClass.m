//
//  MySingletonClass.m
//  GlobalSingletonTut
//
//  Created by Emir Fithri Samsuddin on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MySingletonClass.h"

@interface MySingletonClass ()

@end

@implementation MySingletonClass


static MySingletonClass *shared = NULL;
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

- (id)init
{
    if ( self = [super init] )
    {
        // initialize your singleton variable here (i.e. set to initial value that you require)
        quantityN=2;
        diameterN=13;
        thicknessN=.7;
        hydrationN=60;
        prefermentAmountN=1.3;
        prefermentHydrationN=90;
        saltN=3;
        oilN=0;
        sugarN=0;
        wasteN=1.2;
        prefTemp=0;
        prefDistance=0;
        prefWeight=0;
    }
    return self;
    
}



+ (MySingletonClass *)sharedSingleton
{
    @synchronized(shared)
    {
        if ( !shared || shared == NULL )
        {
            // allocate the shared instance, because it hasn't been done yet
            shared = [[MySingletonClass alloc] init];
        }
        
        return shared;
    }
}

@synthesize  quantityN;
@synthesize  diameterN;
@synthesize  thicknessN;
@synthesize  hydrationN;
@synthesize  prefermentAmountN;
@synthesize  prefermentHydrationN;
@synthesize  saltN;
@synthesize  oilN;
@synthesize  sugarN;
@synthesize  wasteN;
@synthesize prefTemp;
@synthesize prefDistance;
@synthesize prefWeight;

@end
