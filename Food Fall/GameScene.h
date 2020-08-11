//
//  GameScene.h
//  Food Fall
//
//  Created by Willie on 1/30/17.
//  Copyright © 2017 Fluxfire. All rights reserved.  
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GameplayKit/GameplayKit.h>
#import <StoreKit/StoreKit.h>


SKSpriteNode *character;
NSString *characterName;

SKSpriteNode *text1;
NSString *text1Name;
NSString *text2Name;


AVAudioPlayer *audioPlayer1;
NSString *music;

int scoreValue;
SKLabelNode *score;
SKLabelNode *tutorialLabel;
SKLabelNode *actionLabel;
NSMutableArray *barsArray;
int i;
int j;
SKAction *correctSound;
SKAction *incorrectSound;
SKAction *clickSound;

BOOL showInterstitial;
BOOL showRewarded;

@interface GameScene : SKScene <SKPhysicsContactDelegate, UIGestureRecognizerDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate> {
    
}

-(void)leftSwiped1;
-(void)resumeGame;

@end
