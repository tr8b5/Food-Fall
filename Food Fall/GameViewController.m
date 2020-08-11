//
//  GameViewController.m
//  Food Fall
//
//  Created by Willie on 1/30/17.
//  Copyright © 2017 Fluxfire. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>


@import GoogleMobileAds;
@import UIKit;

@interface GameViewController () <GADBannerViewDelegate, GADInterstitialDelegate, GADRewardedAdDelegate>


@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;


@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rewardedAd = [self createAndLoadRewardedAd];
    NSTimer *rewardedTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkCanRewardedAdBeDisplayed) userInfo:nil repeats:TRUE];
    [rewardedTimer fire];
    
    if (timesOpened == 0) {
        
        adsEnabled = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:adsEnabled forKey:@"adsEnabled"];
        [defaults synchronize];
        
    }
    
    if (adsEnabled == YES) {

    self.interstitial = [self createAndLoadInterstitial];
    
    // In this case, we instantiate the banner with desired ad size.
      self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
      [self addBannerViewToView:self.bannerView];
    
    // Timer that checks if Interstitial Ad can display
    interstitalTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkCanInterstitialBeAdDisplayed) userInfo:nil repeats:TRUE];
    [interstitalTimer fire];
    
    }
    
    bannerTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkCanBannerAdBeDismissed) userInfo:nil repeats:TRUE];
    [bannerTimer fire];
    
    // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
    // including entities and graphs.
    GKScene *scene = [GKScene sceneWithFileNamed:@"GameScene"];

    // Get the SKScene from the loaded GKScene
    GameScene *sceneNode = (GameScene *)scene.rootNode;

    // Copy gameplay related content over to the scene
    //sceneNode.entities = [scene.entities mutableCopy];
    //sceneNode.graphs = [scene.graphs mutableCopy];

    // Set the scale mode to scale to fit the window
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;

    SKView *skView = (SKView *)self.view;

    // Present the scene
    [skView presentScene:sceneNode];

    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    }

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Banner Ad

-(void)checkCanBannerAdBeDismissed {
    if (adsEnabled == NO) {
        [self.bannerView removeFromSuperview];
        [bannerTimer invalidate];
    }
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
    [NSLayoutConstraint constraintWithItem:bannerView
                                attribute:NSLayoutAttributeBottom
                                relatedBy:NSLayoutRelationEqual
                                    toItem:self.bottomLayoutGuide
                                attribute:NSLayoutAttributeTop
                                multiplier:1
                                constant:0],
    [NSLayoutConstraint constraintWithItem:bannerView
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                constant:0]
                                ]];
    
    //Real Ad
    //self.bannerView.adUnitID = @"ca-app-pub-3526204639815359/8548421085";
    //Test Ad
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];

    self.bannerView.delegate = self;

}

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
    didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
  NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
  NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
  NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
  NSLog(@"adViewWillLeaveApplication");
}

#pragma mark - Interstitial Ad

-(void)checkCanInterstitialBeAdDisplayed {
    if (showInterstitial == YES & adsEnabled == YES) {
        [self callInterstitial];
        showInterstitial = NO;
    } else {
        //NSLog(@"Ad Cam't Be Displayed");
    }
}

-(void)callInterstitial {
    if (self.interstitial.isReady) {
      [self.interstitial presentFromRootViewController:self];
    } else {
      NSLog(@"Ad wasn't ready");
    }
}

- (GADInterstitial *)createAndLoadInterstitial {
    //Real Ad
  //GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3526204639815359/5880528168"];
    //Test Ad
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
  interstitial.delegate = self;
  [interstitial loadRequest:[GADRequest request]];
  return interstitial;
}

/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    //[interstitial presentFromRootViewController:self];
  NSLog(@"interstitialDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
    didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
  NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
  NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    self.interstitial = [self createAndLoadInterstitial];
  NSLog(@"interstitialDidDismissScreen");
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
  NSLog(@"interstitialWillLeaveApplication");
}

#pragma mark - Rewarded Ad

- (GADRewardedAd *)createAndLoadRewardedAd {
    //Real Ad
  //GADRewardedAd *rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:@"ca-app-pub-3526204639815359/6198493875"];
    //Test Ad
    GADRewardedAd *rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/1712485313"];
  GADRequest *request = [GADRequest request];
  [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
    if (error) {
      // Handle ad failed to load case.
        NSLog(@"Error loading Ad");
    } else {
      // Ad successfully loaded.
      NSLog(@"Successfully loaded Ad");
    }
  }];
  return rewardedAd;
}

-(void)checkCanRewardedAdBeDisplayed {
    if (showRewarded == YES) {
        [self showRewardedAd];
        showRewarded = NO;
    } else {
        //NSLog(@"Ad Cam't Be Displayed");
    }
}

-(void)showRewardedAd {
    if (self.rewardedAd.isReady) {
        [self.rewardedAd presentFromRootViewController:self delegate:self];
    } else {
        NSLog(@"Rewarded Ad Cannot be Displayed");
    }
}

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    rewarded = YES;
  NSLog(@"rewardedAd:userDidEarnReward:");
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
  NSLog(@"rewardedAdDidPresent:");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
  NSLog(@"rewardedAd:didFailToPresentWithError");
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    if (rewarded == YES) {
        reward = YES;
    } else {
        dismissed = YES;
    }
    //rewarded = NO;
  self.rewardedAd = [self createAndLoadRewardedAd];
  NSLog(@"rewardedAdDidDismiss:");
}

@end
