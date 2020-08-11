//
//  GameViewController.h
//  Food Fall
//
//  Created by Willie on 1/30/17.
//  Copyright © 2017 Fluxfire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <StoreKit/StoreKit.h>

BOOL rewarded;
BOOL reward;
BOOL dismissed;
BOOL adsEnabled;
NSInteger timesOpened; // Default - Game 1
NSTimer *interstitalTimer;
NSTimer *bannerTimer;

@interface GameViewController : UIViewController {
   
}

-(void)callInterstitial;
-(GADInterstitial *)createAndLoadInterstitial;


@end
