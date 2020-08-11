//
//  GameScene.m
//  Food Fall
//
//  Created by Willie on 1/30/17.
//  Copyright © 2017 Fluxfire. All rights reserved.
//

#import "GameScene.h"
#import "GameViewController.h"
#import "Bars.h"
@import GoogleMobileAds;

#define kAddSupportCreatorProductIdentifier @"Fluxfire.FoodFall.SupportCreator"

@interface GameScene () <AVAudioPlayerDelegate>

// TO DO
// Spawn tutorial bars function
//

@property (strong, nonatomic) SKNode *gameLayer;
@property (strong, nonatomic) SKNode *foodlayer;
@property (strong, nonatomic) SKNode *obsticleLayer;
@property (strong, nonatomic) SKNode *orbLayer;
@property (strong, nonatomic) SKNode *barLayer;

@end


@implementation GameScene  {
    
    //start up
    int m; // Tutorial Main Text Array Value
    int w; // Tutorial Action Text Array Value
    int n; // Tutorial Bar 1 Array Value
    int x; // Tutoril Character Array Value
    int o; // Tutorial Bar 2 Array Value
    int cd; // Countdown Array Value
    int adNum;
    int size;
    int proBarNum;
    int properBar;
    int lvlInt;
    int seqNum;
    int spawnCode;
    int set;
    int extraLifeInt;
    
    float spawntime;
    
    BOOL newSeq;
    BOOL veryEasy;
    BOOL easy;
    BOOL medium;
    BOOL veryMedium;
    BOOL hard;
    BOOL veryHard;
    BOOL blackandWhite;
    BOOL canSwipe;
    BOOL activatedtut;
    BOOL soundOn;
    BOOL tutorialOn;
    BOOL endTutorial;
    BOOL storyModeOn;
    BOOL quickPlayOn;
    BOOL gameOne;
    BOOL victory;
    BOOL clicked;
    BOOL correctBar;
    BOOL checkingPurchase;
    __block BOOL tutGame;
    BOOL arrowClicked;
    
    SKLabelNode *aLabel;
    
    SKSpriteNode *bar1;
    NSString *bar1Name;
    SKSpriteNode *bar2;
    NSString *bar2Name;
    SKSpriteNode *bar3;
    NSString *bar3Name;
    SKSpriteNode *bar4;
    NSString *bar4Name;
    SKSpriteNode *bar5;
    NSString *bar5Name;
    SKSpriteNode *bar6;
    NSString *bar6Name;
    NSArray *barArray;
    
    SKSpriteNode *scoreBoard;
    
    CGPoint a;
    CGPoint b;
    CGPoint c;
    CGPoint d;
    CGPoint e;
    
    
    NSInteger highScore;
    NSInteger gameNumber;
    NSInteger level;
    NSInteger highLevel;
    
    NSTimer *rewardedTimer;
    
    NSArray *characterArray;
    
    
}

#pragma mark - Sprite Actions

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.contactDelegate = self;
    
    //start up
    m = 0;
    n = 0;
    x = 0;
    o = 0;
    w = 0;
    cd = 0;
    adNum = 0;
    extraLifeInt = 0;
    
    timesOpened = [[NSUserDefaults standardUserDefaults] integerForKey:@"timesOpened"];
    
    if (timesOpened == 0) {
        level = 1;
        highLevel = 1;
        timesOpened++;
        activatedtut = YES;
        clicked = YES;
        soundOn = YES;
        NSUserDefaults *levelData = [NSUserDefaults standardUserDefaults];
        [levelData setInteger:level forKey:@"level"];
        [levelData synchronize];
        NSUserDefaults *highLevelData = [NSUserDefaults standardUserDefaults];
        [highLevelData setInteger:highLevel forKey:@"highLevel"];
        [highLevelData synchronize];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:timesOpened forKey:@"timesOpened"];
        [defaults synchronize];
        NSUserDefaults* soundDefaults = [NSUserDefaults standardUserDefaults];
        [soundDefaults setBool:soundOn forKey:@"soundOn"];
        [soundDefaults synchronize];
        NSUserDefaults* tutorialDefaults = [NSUserDefaults standardUserDefaults];
        [tutorialDefaults setBool:activatedtut forKey:@"activatedtut"];
        [tutorialDefaults synchronize];
    } else {
        NSUserDefaults *openData = [NSUserDefaults standardUserDefaults];
        timesOpened = [openData integerForKey:@"timesOpened"];
        timesOpened++;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:timesOpened forKey:@"timesOpened"];
        [defaults synchronize];
        NSUserDefaults *highLevelData = [NSUserDefaults standardUserDefaults];
        highLevel = [highLevelData integerForKey:@"highLevel"];
        NSUserDefaults *soundData = [NSUserDefaults standardUserDefaults];
        soundOn = [soundData boolForKey:@"soundOn"];
        NSUserDefaults *tutorialData = [NSUserDefaults standardUserDefaults];
        activatedtut = [tutorialData boolForKey:@"activatedtut"];
        if (activatedtut == YES) {
            clicked = YES;
        }
    }
    
    NSUserDefaults *levelData = [NSUserDefaults standardUserDefaults];
    level = [levelData integerForKey:@"level"];
    NSLog(@"Times Opened: " @"%li",timesOpened);
    NSLog(@"Level: " @"%li",level);
    if (level == 0) {
        level = 1;
        NSUserDefaults *levelData = [NSUserDefaults standardUserDefaults];
        [levelData setInteger:level forKey:@"level"];
        [levelData synchronize];
    }
    
    self.gameLayer = [SKNode node];
    [self addChild:self.gameLayer];
    
    self.foodlayer = [SKNode node];
    self.foodlayer.position = CGPointZero;
    [self.gameLayer addChild:self.foodlayer];
    
    self.obsticleLayer = [SKNode node];
    self.obsticleLayer.position = CGPointZero;
    [self.gameLayer addChild:self.obsticleLayer];
    
    self.orbLayer = [SKNode node];
    self.orbLayer.position = CGPointZero;
    [self.gameLayer addChild:self.orbLayer];
    
    self.barLayer = [SKNode node];
    self.barLayer.position = CGPointZero;
    [self.gameLayer addChild:self.barLayer];
    
    //SKTextureAtlas *images = [SKTextureAtlas atlasNamed:@"Images"];
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Background1"]];
    background.position = CGPointMake(0, -self.frame.size.height/2 + background.size.height/3);
    background.size = CGSizeMake(background.size.width/1.44, background.size.height/1.44);
    background.name = @"background";
    [self.gameLayer addChild:background];
    
    [background runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveToY:-400 duration:25],[SKAction moveToY:400 duration:25]]]]];
    
    [self homeSprites];
    
    score = [SKLabelNode labelNodeWithFontNamed:@"Dimitri"];
    score.position = CGPointMake(0, self.frame.size.height/2.5);
    score.zPosition = 6;
    score.fontSize = 150;
    score.name = @"score";
    score.text = [NSString stringWithFormat:@"%i", scoreValue++];
    
    [self swipeGestures];
    
    correctSound = [SKAction playSoundFileNamed:@"Ching" waitForCompletion:NO];
    incorrectSound = [SKAction playSoundFileNamed:@"Buzzer" waitForCompletion:NO];
    clickSound = [SKAction playSoundFileNamed:@"dink" waitForCompletion:NO];
    
    music = [[NSBundle mainBundle]pathForResource:@"GAMEBOY" ofType:@"mp3"];
    audioPlayer1 = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:music]  error:NULL];
    audioPlayer1.delegate = self;
    audioPlayer1.numberOfLoops = -1;
    audioPlayer1.volume = 8;
    
    if (soundOn == YES) {
        [audioPlayer1 play];
    }
    
    seqNum = 0;
    spawntime = 0.5;
    //level = 50;
    
}
-(void)homeSprites {
    
    SKSpriteNode *playStoryButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"PlayStoryButton"]];
    playStoryButton.position = CGPointMake(-self.frame.size.width/4.25, -self.frame.size.height/4.5);
    playStoryButton.zPosition = 6;
    playStoryButton.name = @"PlayButton";
    [self.gameLayer addChild:playStoryButton];
    
    SKSpriteNode *quickPlayButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"QuickPlayButton"]];
    quickPlayButton.position = CGPointMake(self.frame.size.width/4.7, -self.frame.size.height/3.3);
    quickPlayButton.zPosition = 6;
    quickPlayButton.name = @"QuickPlayButton";
    [self.gameLayer addChild:quickPlayButton];
    
    SKSpriteNode *tutorialButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"TutorialButton"]];
    tutorialButton.position = CGPointMake(-self.frame.size.width/3.9, self.frame.size.height/2.3);
    tutorialButton.zPosition = 6;
    tutorialButton.name = @"TutorialButton";
    [self.gameLayer addChild:tutorialButton];
    
    SKSpriteNode *soundButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"SoundButton"]];
    soundButton.position = CGPointMake(self.frame.size.width/3.5, self.frame.size.height/2.3);
    soundButton.zPosition = 6;
    soundButton.name = @"SoundButton";
    [self.gameLayer addChild:soundButton];
    
    SKSpriteNode *menu = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"MainMenu"]];
    menu.position = CGPointZero;
    menu.zPosition = 5;
    menu.name = @"MainMenu";
    [self.gameLayer addChild:menu];
    
    /*SKSpriteNode *removeAdButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"SupportCreatorButton"]];
     removeAdButton.position = CGPointMake(0, -self.frame.size.height/2.5);
     removeAdButton.zPosition = 5;
     removeAdButton.name = @"RemoveAdsButton";
     [self.gameLayer addChild:removeAdButton];*/
    
    if (activatedtut == YES) {
        SKSpriteNode *check = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Check"]];
        check.position = CGPointMake(-self.frame.size.width/2.7, self.frame.size.height/2.2);
        check.zPosition = 10;
        check.name = @"Check1";
        [self.gameLayer addChild:check];
    }
    if (soundOn == YES) {
        SKSpriteNode *check = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Check"]];
        check.position = CGPointMake(self.frame.size.width/2.3, self.frame.size.height/2.2);
        check.zPosition = 10;
        check.name = @"Check2";
        [self.gameLayer addChild:check];
    }
    
}
-(void)characters {
    
    if (activatedtut == YES) {
        characterArray = @[
            @"Apple",
            @"BellPepper",
            @"CandyApple",
            @"Apple",
            @"BellPepper",
            @"CandyApple",
        ];
    } else {
        characterArray = @[
            @"Apple", //0 <-
            @"BellPepper", //1
            @"CandyApple", //2
            @"Pomegranate", //3
            @"RedPear", //4
            @"n&nDark", //5
            @"RedVelvetCupCake", //6 <- 11
            @"Strawberry",  //7
            @"n&n", //8
            @"Tomato", //9
            @"GreenApple", //10
            @"GreenBellpepper", //11
            @"Muffin", //12
            @"Pear", //13
            @"Broccoli", //14
            @"Potato", //15
            @"CornDog", //16
        ];
    }
    
}
-(void)quickPlayLogic {
    
    self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.1);
    NSUInteger charNum = arc4random() % 3;
    if (scoreValue < 10) {
        set = 1;
        veryEasy = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 10 && scoreValue < 20) {
        charNum = arc4random() % 3;
        set = arc4random() % 2 + 1;
        veryEasy = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 20 && scoreValue < 30) {
        charNum = arc4random() % 3;
        set = 3;
        veryEasy = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 30 && scoreValue < 40) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = arc4random() % 3 + 3;
        set = arc4random() % 3 + 1;
        easy = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 40 && scoreValue < 50) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = arc4random() % 3 + 3;
        set = 4;
        blackandWhite = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 50 && scoreValue < 60) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = arc4random() % 6;
        set = arc4random() % 5 + 1;
        veryMedium = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 60 && scoreValue < 70) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = 6 + arc4random() % 4;
        set = arc4random() % 7 + 1;
        veryMedium = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 70 && scoreValue < 80) {
        self.physicsWorld.gravity = CGVectorMake(0, -11);
        charNum = 6 + arc4random() % 4;
        set = arc4random() % 7 + 1;
        medium = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 80 && scoreValue < 90) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = 6 + arc4random() % 4;
        set = arc4random() % 7 + 1;
        medium = YES;
        spawntime = arc4random() % 1 + 0.5;
    }
    if (scoreValue >= 90 && scoreValue < 100) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = arc4random() % (characterArray.count-7);
        set = 9 + arc4random() % 2;
        hard = YES;
        spawntime = arc4random() % 1 + 0.5;
    }
    if (scoreValue >= 100 && scoreValue < 110) {
        self.physicsWorld.gravity = CGVectorMake(0, -12);
        charNum = arc4random() % (characterArray.count-7);
        set = 11;
        hard = YES;
        spawntime = 1;
    }
    if (scoreValue >= 110 && scoreValue < 120) {
        self.physicsWorld.gravity = CGVectorMake(0, -12);
        charNum = arc4random() % (characterArray.count-7);
        set = 8;
        veryHard = YES;
        spawntime = arc4random() % 1 + 0.5;
    }
    if (scoreValue >= 120) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = arc4random() % (characterArray.count-7);
        set = arc4random() % 11 + 1;
        veryHard = YES;
        spawntime = 1.5;
    }
    if (scoreValue >= 130) {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        charNum = arc4random() % (characterArray.count-6);
        set = arc4random() % 11 + 1;
        veryHard = YES;
        spawntime = 1.5;
    }
    NSString *charType = [characterArray objectAtIndex:charNum];
    characterName = [NSString stringWithString:charType];
    
    NSLog(@"Score --------------------------- " @"%i", scoreValue);
    NSLog(blackandWhite ? @"Black&White: " @"YES" : @"Black&White: " @"NO");
    NSLog(veryEasy ? @"VeryEasy: " @"YES" : @"VeryEasy: " @"NO");
    NSLog(easy ? @"Easy: " @"YES" : @"Easy: " @"NO");
    NSLog(veryMedium ? @"VeryMedium: " @"YES" : @"VeryMedium: " @"NO");
    NSLog(medium ? @"Medium: " @"YES" : @"Medium: " @"NO");
    NSLog(hard ? @"Hard: " @"YES" : @"Hard: " @"NO");
    NSLog(veryHard ? @"VeryHard: " @"YES" : @"VeryHard: " @"NO");
}
-(void)levelLogic {
    
    if (level == 1)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -6);
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = 1;
        veryEasy = YES;
        spawntime = 0.1;
    }
    if (level == 2)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -6.5);
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 2 + 1;
        veryEasy = YES;
        spawntime = 0.2;
    }
    if (level == 3)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -6);
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 2 + 1;
        veryEasy = YES;
        spawntime = 1.0;
    }
    if (level == 4)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -6);
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 2 + 1;
        veryEasy = YES;
        spawntime = ((float)rand() / RAND_MAX) * 1.5 + 0.3;
    }
    if (level == 5)
    {
        self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.2);
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 2 + 1;
        veryEasy = YES;
        spawntime = 0.2;
    }
    if (level == 6)
    {
        self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.1);
        
        NSUInteger charNum = arc4random() % (characterArray.count-12);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 0;
        }
        if (numnum1 == 1) {
            charNum = 2;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 2 + 1;
        hard = YES;
        spawntime = 0.1;
    }
    if (level == 7)
    {
        if (self.physicsWorld.gravity.dy >= -12) {
            self.physicsWorld.gravity = CGVectorMake(0,  self.physicsWorld.gravity.dy - 0.5);
        }
        NSUInteger charNum = arc4random() % (characterArray.count-13);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 0;
        }
        if (numnum1 == 1) {
            charNum = 1;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = 2;
        veryEasy = YES;
        spawntime = 0.5;
    }
    if (level == 8)
    {
        if (scoreValue < 15) {
            self.physicsWorld.gravity = CGVectorMake(0, -7.5);
        }
        
        if (scoreValue > 15) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = 1;
        veryHard = YES;
        spawntime = 1;
    }
    if (level == 9)
    {
        self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.2);
        
        NSUInteger charNum = arc4random() % (characterArray.count-13);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 1;
        }
        if (numnum1 == 1) {
            charNum = 2;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 2 + 1;
        hard = YES;
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.5;}
        if (scoreValue > 10){spawntime = 1;}
        if (scoreValue > 12){spawntime = 0.3;}
        if (scoreValue > 18){spawntime = 1;}
        if (scoreValue > 21){spawntime = 0.1;}
        if (scoreValue > 22){spawntime = 1;}
    }
    if (level == 10) //Fix Crash Problem
    {
        if (scoreValue == 0) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
        } else {
            self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.2);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = 1;
        veryEasy = YES;
        spawntime = 0.5;
    }
    if (level == 11)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-13) + (3);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 2 + 1;
        medium = YES;
        spawntime = 0.2;
    }
    if (level == 12)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-13) + (3);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            set = 3;
        }
        if (numnum == 1) {
            set = 7;
        }
        medium = YES;
        spawntime = 1.5;
    }
    if (level == 13)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        
        NSUInteger charNum = arc4random() % (characterArray.count-13) + (3);
        int numnum1 = arc4random() % 2;
        if (scoreValue < 15) {
            if (numnum1 == 0) {
                charNum = 3;
            }
            if (numnum1 == 1) {
                charNum = 5;
            }
        }
        if (scoreValue > 14) {
            if (numnum1 == 0) {
                charNum = 1;
            }
            if (numnum1 == 1) {
                charNum = 6;
            }
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 3 + 1;
        medium = YES;
        spawntime = 0.9;
    }
    if (level == 14)
    {
        if (scoreValue < 26) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
        } else {
            self.physicsWorld.gravity = CGVectorMake(0, -12);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-10);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 5;
        }
        if (numnum1 == 1) {
            charNum = 4;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = 1;
        veryHard = YES;
        spawntime = 1;
    }
    if (level == 15)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-13) + (3);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            set = 4;
        }
        if (numnum == 1) {
            set = 5;
        }
        medium = YES;
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.3;}
        if (scoreValue > 10){spawntime = 0.4;}
        if (scoreValue > 12){spawntime = 0.5;}
        if (scoreValue > 18){spawntime = 0.6;}
        if (scoreValue > 21){spawntime = 0.7;}
        if (scoreValue > 22){spawntime = 0.8;}
    }
    if (level == 16)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-10);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = arc4random() % 5 + 1;
        medium = YES;
        spawntime = 1.5;
    }
    if (level == 17)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-10);
        int numnum1 = arc4random() % 4;
        if (numnum1 == 0) {
            charNum = 0;
        }
        if (numnum1 == 1) {
            charNum = 1;
        }
        if (numnum1 == 2) {
            charNum = 2;
        }
        if (numnum1 == 3) {
            charNum = 3;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 6;
        veryMedium = YES;
        spawntime = 0.5;
    }
    if (level == 18)
    {
        self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.3);
        
        NSUInteger charNum = arc4random() % (characterArray.count-10);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 1;
        veryMedium = YES;
        spawntime = 2;
    }
    if (level == 19)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -6);
        
        NSUInteger charNum = arc4random() % (characterArray.count-10);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 2;
        veryMedium = YES;
        spawntime = 2;
    }
    if (level == 20)
    {
        if (scoreValue <= 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -8);
        }
        if (scoreValue > 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -6);
        }
        if (scoreValue > 20) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-10);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        if (scoreValue <= 10) {
            set = arc4random() % 7 + 1;
        }
        if (scoreValue > 10) {
            set = arc4random() % 2 + 1;
        }
        if (scoreValue > 20) {
            set = 6;
        }
        medium = YES;
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.8;}
        if (scoreValue > 10){spawntime = 2;}
        if (scoreValue > 20){spawntime = 1;}
        
        medium = YES;
        //spawntime = 0.1;
    }
    if (level == 21)
    {
        self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.2);
        
        NSUInteger charNum = 7 + arc4random() % 3;
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 3 + 1;
        medium = YES;
        spawntime = 0.2;
    }
    if (level == 22)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -6);
        
        NSUInteger charNum = 7 + arc4random() % 3;
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = arc4random() % 7 + 1;
        veryMedium = YES;
        spawntime = 1;
    }
    if (level == 23)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-8);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 9;
        }
        if (numnum1 == 1) {
            charNum = 8;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        if (scoreValue >= 0) {
            set = 1;
        }
        if (scoreValue >= 5) {
            set = 2;
        }
        if (scoreValue >= 10) {
            set = 3;
        }
        if (scoreValue >= 15) {
            set = 4;
        }
        if (scoreValue >= 20) {
            set = 5;
        }
        if (scoreValue >= 25) {
            set = 6;
        }
        veryHard = YES;
        spawntime = 0.4;
    }
    if (level == 24)
    {
        if (scoreValue == 0) {
            self.physicsWorld.gravity = CGVectorMake(0, -7);
        } else  {
            self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.1);
        }
        NSUInteger charNum = arc4random() % (characterArray.count-9);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 1;
        }
        if (numnum1 == 1) {
            charNum = 6;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 3;
        if (numnum == 0) {
            set = 2;
        }
        if (numnum == 1) {
            set = 7;
        }
        if (numnum == 2) {
            set = 6;
        }
        veryMedium = YES;
        spawntime = 1;
    }
    if (level == 25)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -7);
        
        NSUInteger charNum = 7 + arc4random() % 3;
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 6;
        veryMedium = YES;
        spawntime = 2;
    }
    if (level == 26)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            set = 2;
        }
        if (numnum == 1) {
            set = 6;
        }
        blackandWhite = YES;
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.3;}
        if (scoreValue > 10){spawntime = 0.4;}
        if (scoreValue > 12){spawntime = 0.5;}
        if (scoreValue > 18){spawntime = 0.6;}
        if (scoreValue > 21){spawntime = 0.7;}
        if (scoreValue > 22){spawntime = 0.8;}
    }
    if (level == 27)
    {
        if (scoreValue < 15) {
            self.physicsWorld.gravity = CGVectorMake(0, -15);
            set = 1;
            spawntime = 0.2;
        }
        if (scoreValue >= 15) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
            int numnum = arc4random() % 4;
            if (numnum == 0) {
                set = 4;
            }
            if (numnum == 1) {
                set = 6;
            }
            if (numnum == 2) {
                set = 7;
            }
            if (numnum == 3) {
                set = 3;
            }
            spawntime = 1.5;
        }
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        veryMedium = YES;
    }
    if (level == 28)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -7);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 6;
        veryMedium = YES;
        spawntime = 1;
    }
    if (level == 29)
    {
        if (scoreValue <= 1) {
            self.physicsWorld.gravity = CGVectorMake(0, -7);
        } else {
            self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.15);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum1 = arc4random() % 2;
        if (scoreValue < 15) {
            if (numnum1 == 0) {
                charNum = 3;
            }
            if (numnum1 == 1) {
                charNum = 5;
            }
        }
        if (scoreValue > 14) {
            if (numnum1 == 0) {
                charNum = 8;
            }
            if (numnum1 == 1) {
                charNum = 9;
            }
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 3;
        if (numnum == 0) {
            set = 2;
        }
        if (numnum == 1) {
            set = 7;
        }
        if (numnum == 2) {
            set = 6;
        }
        blackandWhite = YES;
        spawntime = 1;
    }
    if (level == 30)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 0;
        }
        if (numnum1 == 1) {
            charNum = 2;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        if (scoreValue <= 3) {
            set = 1;
        }
        if (scoreValue >= 8) {
            set = 2;
        }
        if (scoreValue >= 11) {
            set = 3;
        }
        if (scoreValue >= 14) {
            set = 4;
        }
        if (scoreValue >= 17) {
            set = 5;
        }
        if (scoreValue >= 20) {
            set = arc4random() % 5 + 1;
        }
        blackandWhite = YES;
        spawntime = 0.4;
    }
    if (level == 31)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum1 = arc4random() % 3;
        if (numnum1 == 0) {
            charNum = 0;
        }
        if (numnum1 == 1) {
            charNum = 2;
        }
        if (numnum1 == 2) {
            charNum = 8;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            set = 2;
        }
        if (numnum == 1) {
            set = 5;
        }
        blackandWhite = YES;
        spawntime = 0.5;
    }
    if (level == 32)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -12);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            charNum = 6;
        }
        if (numnum == 1) {
            charNum = 1;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = arc4random() % 2 + 1;
        blackandWhite = YES;
        if (scoreValue < 15) {
            spawntime = 1;
        } else  {
            spawntime = 1.5;
        }
    }
    if (level == 33)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            charNum = 5;
        }
        if (numnum == 1) {
            charNum = 4;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            set = 4;
        }
        if (numnum1 == 1) {
            set = 6;
        }
        blackandWhite = YES;
        if (scoreValue < 15) {
            spawntime = 1.5;
        } else  {
            spawntime = 1.8;
        }
    }
    if (level == 34)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum1 = arc4random() % 2;
        if (scoreValue < 12) {
            if (numnum1 == 0) {
                charNum = 3;
            }
            if (numnum1 == 1) {
                charNum = 6;
            }
        }
        if (scoreValue > 11) {
            
            if (numnum1 == 0) {
                charNum = 1;
            }
            if (numnum1 == 1) {
                charNum = 6;
            }
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 5;
        blackandWhite = YES;
        spawntime = 1.7;
    }
    if (level == 35) //Good Level
    {
        if (scoreValue <= 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -9);
        }
        if (scoreValue > 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -7);
        }
        if (scoreValue > 20) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 2;
        }
        if (numnum1 == 1) {
            charNum = 7;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        if (scoreValue <= 10) {
            int numnum = arc4random() % 2;
            if (numnum == 0) {
                set = 3;
            }
            if (numnum == 1) {
                set = 7;
            }
        }
        if (scoreValue > 10) {
            int numnum1 = arc4random() % 2;
            if (numnum1 == 0) {
                set = 4;
            }
            if (numnum1 == 1) {
                set = 5;
            }
        }
        if (scoreValue > 20) {
            set = 6;
        }
        blackandWhite = YES;
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.8;}
        if (scoreValue > 10){spawntime = 2;}
        if (scoreValue > 20){spawntime = 1;}
    }
    if (level == 36)
    {
        self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.1);
        
        NSUInteger charNum = arc4random() % (characterArray.count-13) + (6);
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            charNum = 9;
        }
        if (numnum == 1) {
            charNum = 8;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 6;
        blackandWhite = YES;
        if (scoreValue < 2) {
            spawntime = 0.2;
        }
        if (scoreValue > 2) {
            spawntime = spawntime+0.07;
        }
    }
    if (level == 37)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9);
        
        NSUInteger charNum = 3 + arc4random() % 3;
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 7 + 1;
        blackandWhite = YES;
        if (scoreValue % 2) {
            // odd
            spawntime = 0.2;
        } else {
            // even
            spawntime = 1;
        }
        //spawntime = ((float)rand() / RAND_MAX) * 1.5 + 0.5;
    }
    if (level == 38)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9);
        
        NSUInteger charNum = arc4random() % (characterArray.count-14);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 5;
        blackandWhite = YES;
        
        if (scoreValue % 2) {
            // odd
            spawntime = 1.5;
        } else {
            // even
            spawntime = 0.5;
        }
    }
    if (level == 39)
    {
        if (scoreValue <= 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -7);
        }
        if (scoreValue > 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -11);
        }
        if (scoreValue > 20) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-10);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        if (scoreValue <= 10) {
            set = arc4random() % 7 + 1;
        }
        if (scoreValue > 10) {
            set = arc4random() % 2 + 1;
        }
        if (scoreValue > 20) {
            int numnum = arc4random() % 2;
            if (numnum == 0) {
                set = 6;
            }
            if (numnum == 1) {
                set = 5;
            }
        }
        blackandWhite = YES;
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.8;}
        if (scoreValue > 10){spawntime = 1.5;}
        if (scoreValue > 20){spawntime = 1;}
    }
    if (level == 40)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -7);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            set = 4;
        }
        if (numnum == 1) {
            set = 5;
        }
        veryHard = YES;
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.4;}
        if (scoreValue > 10){spawntime = 0.6;}
        if (scoreValue > 12){spawntime = 0.8;}
        if (scoreValue > 18){spawntime = 1;}
        if (scoreValue > 21){spawntime = 1.5;}
        if (scoreValue > 22){spawntime = 2;}
    }
    if (level == 41)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -12);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum = arc4random() % 2;
        if (numnum == 0) {
            charNum = 8;
        }
        if (numnum == 1) {
            charNum = 9;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            set = 2;
        }
        if (numnum1 == 1) {
            set = 1;
        }
        veryHard = YES;
        spawntime = 1;
    }
    if (level == 42)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        
        int numnum = arc4random() % 2;
        if (scoreValue < 15) {
            if (numnum == 0) {
                charNum = 2;
            }
            if (numnum == 1) {
                charNum = 0;
            }
        }
        if (scoreValue >= 15) {
            if (numnum == 0) {
                charNum = 1;
            }
            if (numnum == 1) {
                charNum = 6;
            }
        }
        
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            set = 6;
        }
        if (numnum1 == 1) {
            set = 8;
        }
        if (scoreValue < 15) {
            veryHard = YES;
        }
        if (scoreValue >= 15) {
            blackandWhite = YES;
        }
        spawntime = 1.5;
    }
    if (level == 43) // Too easy
    {
        if (scoreValue <= 1) {
            self.physicsWorld.gravity = CGVectorMake(0, -7);
        } else {
            self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.2);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            charNum = 4;
        }
        if (numnum1 == 1) {
            charNum = 5;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 4;
        if (numnum == 0) {
            set = 1;
        }
        if (numnum == 1) {
            set = 2;
        }
        if (numnum == 2) {
            set = 3;
        }
        if (numnum == 3) {
            set = 11;
        }
        veryHard = YES;
        spawntime = 0.2;
    }
    if (level == 44)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        
        set = arc4random() % 11 + 1;
        veryHard = YES;
        spawntime = ((float)rand() / RAND_MAX) * 1.5 + 0.5;
    }
    if (level == 45)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -9);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum1 = arc4random() % 2;
        if (scoreValue <= 15) {
            if (numnum1 == 0) {
                charNum = 2;
            }
            if (numnum1 == 1) {
                charNum = 0;
            }
        } else {
            if (numnum1 == 0) {
                charNum = 9;
            }
            if (numnum1 == 1) {
                charNum = 8;
            }
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum = arc4random() % 4;
        if (numnum == 0) {
            set = 8;
        }
        if (numnum == 1) {
            set = 9;
        }
        if (numnum == 2) {
            set = 10;
        }
        if (numnum == 3) {
            set = 11;
        }
        veryHard = YES;
        spawntime = 1.5;
    }
    if (level == 46)
    {
        if (scoreValue <= 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -9);
        }
        if (scoreValue > 10) {
            self.physicsWorld.gravity = CGVectorMake(0, -8);
        }
        if (scoreValue > 20) {
            self.physicsWorld.gravity = CGVectorMake(0, -10);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-9);
        int numnum = arc4random() % 3;
        if (numnum == 0) {
            charNum = 3;
        }
        if (numnum == 1) {
            charNum = 5;
        }
        if (numnum == 2) {
            charNum = 6;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        if (scoreValue <= 10) {
            set = arc4random() % 11 + 1;
        }
        if (scoreValue > 10) {
            set = arc4random() % 2 + 1;
        }
        if (scoreValue > 20) {
            int numnum1 = arc4random() % 2;
            if (numnum1 == 0) {
                set = 6;
            }
            if (numnum1 == 1) {
                set = 8;
            }
        }
        if (scoreValue < 15) {
            veryHard = YES;
        }
        if (scoreValue >= 15) {
            blackandWhite = YES;
        }
        if (scoreValue < 5){spawntime = 0.2;}
        if (scoreValue > 5){spawntime = 0.8;}
        if (scoreValue > 10){spawntime = 2;}
        if (scoreValue > 20){spawntime = 1;}
    }
    if (level == 47)
    {
        if (scoreValue % 2) {
            // odd
            self.physicsWorld.gravity = CGVectorMake(0, -11);
        } else {
            // even
            self.physicsWorld.gravity = CGVectorMake(0, -9);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        
        int numnum = arc4random() % 4;
        if (numnum == 0) {
            charNum = 4;
        }
        if (numnum == 1) {
            charNum = 5;
        }
        if (numnum == 2) {
            charNum = 3;
        }
        if (numnum == 3) {
            charNum = 1;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            set = 9;
        }
        if (numnum1 == 1) {
            set = 10;
        }
        veryHard = YES;
        if (scoreValue % 2) {
            // odd
            spawntime = 0.2;
        } else {
            // even
            spawntime = 1.5;
        }
    }
    if (level == 48) // Too Hard
    {
        if (scoreValue <= 1) {
            self.physicsWorld.gravity = CGVectorMake(0, -9);
        } else {
            self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.1);
        }
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        int numnum = arc4random() % 3;
        if (numnum == 0) {
            charNum = 0;
        }
        if (numnum == 1) {
            charNum = 9;
        }
        if (numnum == 2) {
            charNum = 8;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        set = 7 + arc4random() % 5;
        veryHard = YES;
        if (scoreValue < 2) {
            spawntime = 0.2;
        }
        if (spawntime <= 1.5) {
            spawntime = spawntime+0.05;
        }
    }
    if (level == 49)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        
        NSUInteger charNum = arc4random() % (characterArray.count-7);
        
        int numnum = arc4random() % 3;
        if (numnum == 0) {
            charNum = 0;
        }
        if (numnum == 1) {
            charNum = 2;
        }
        if (numnum == 2) {
            charNum = 7;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum1 = arc4random() % 2;
        if (numnum1 == 0) {
            set = 9;
        }
        if (numnum1 == 1) {
            set = 10;
        }
        if (scoreValue < 15) {
            veryHard = YES;
        }
        if (scoreValue >= 15) {
            blackandWhite = YES;
        }
        spawntime = 1.5;
    }
    if (level == 50)
    {
        if (scoreValue <= 1) {
            self.physicsWorld.gravity = CGVectorMake(0, -8);
        } else {
            self.physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy - 0.2);
        }
        NSUInteger charNum = arc4random() % (characterArray.count-9);
        if (scoreValue <= 5) {
            charNum = arc4random() % 3;
        }
        if (scoreValue > 5) {
            charNum = 3 + arc4random() % 3;
        }
        if (scoreValue >= 10) {
            charNum = arc4random() % 10;
        }
        NSString *charType = [characterArray objectAtIndex:charNum];
        characterName = [NSString stringWithString:charType];
        int numnum1 = arc4random() % 3;
        if (numnum1 == 0) {
            set = 4;
        }
        if (numnum1 == 1) {
            set = 10;
        }
        if (numnum1 == 2) {
            set = 9;
        }
        if (scoreValue <= 5) {
            veryHard = YES;
        }
        if (scoreValue > 5) {
            blackandWhite = YES;
        }
        if (scoreValue >= 10) {
            blackandWhite = NO;
            veryHard = YES;
        }
        if (scoreValue >= 15) {
            blackandWhite = YES;
        }
        if (scoreValue >= 20) {
            blackandWhite = NO;
            veryHard = YES;
        }
        spawntime = 1;
    }
    
}
-(void)gameOverActions {
    
    if (arrowClicked == NO) {
        adNum++;
        if (adNum == 3) {
            showInterstitial = YES;
            adNum = 0;
        }
    }
    arrowClicked = NO;
    
    SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"HomeButton"]];
    
    if (quickPlayOn == YES) {
        NSUserDefaults *highScoreData = [NSUserDefaults standardUserDefaults];
        highScore = [highScoreData integerForKey:@"highScore"];
        
        scoreBoard = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ScoreBoard"]];
        scoreBoard.position = CGPointMake(0, self.frame.size.height/17);
        scoreBoard.name = @"ScoreBoard";
        scoreBoard.zPosition = 4;
        [self.gameLayer addChild:scoreBoard];
        
        if (victory == NO) {
            SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"RetryButton"]];
            playButton.position = CGPointMake(0, -self.frame.size.height/3.5);
            playButton.zPosition = 5;
            playButton.name = @"RetryButton";
            [scoreBoard addChild:playButton];
        }
        
        homeButton.position = CGPointMake(-self.frame.size.width/3.75, self.frame.size.height/5.5);
        
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dimitri"];
        highScoreLabel.position = CGPointMake(0, -self.frame.size.height/9.1);
        highScoreLabel.zPosition = 6;
        highScoreLabel.fontSize = 150;
        highScoreLabel.name = @"highScoreLabel";
        highScoreLabel.text = [NSString stringWithFormat:@"%li", (long)highScore];
        [self.gameLayer addChild:highScoreLabel];
        if (scoreValue > highScore) {
            highScore = scoreValue-1;
            highScoreLabel.text = [NSString stringWithFormat:@"%li", (long)highScore];
            NSUserDefaults *highScoreData1 = [NSUserDefaults standardUserDefaults];
            [highScoreData1 setInteger:highScore forKey:@"highScore"];
            [highScoreData1 synchronize];
        }
    }
    
    if (storyModeOn == YES && level < 51) {
        
        NSUserDefaults *highLevelData = [NSUserDefaults standardUserDefaults];
        highLevel = [highLevelData integerForKey:@"highLevel"];
        
        NSUserDefaults *levelData = [NSUserDefaults standardUserDefaults];
        [levelData setInteger:level forKey:@"level"];
        [levelData synchronize];
        
        scoreBoard = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"LevelScoreBoard"]];
        scoreBoard.position = CGPointMake(0, -self.frame.size.height/150);
        scoreBoard.name = @"ScoreBoard";
        scoreBoard.zPosition = 4;
        [self.gameLayer addChild:scoreBoard];
        
        homeButton.position = CGPointMake(-self.frame.size.width/3.75, self.frame.size.height/4.2);
        score.alpha = 1;
        
        SKLabelNode *levelLabel = [SKLabelNode labelNodeWithFontNamed:@"Dimitri"];
        levelLabel.position = CGPointMake(0, -self.frame.size.height/9.1);
        levelLabel.zPosition = 6;
        levelLabel.fontSize = 150;
        levelLabel.name = @"levelLabel";
        levelLabel.text = [NSString stringWithFormat:@"%li", (long)level];
        [self.gameLayer addChild:levelLabel];
        
        if (victory == NO) {
            SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"RetryButton"]];
            playButton.position = CGPointMake(0, -self.frame.size.height/4.5);
            playButton.zPosition = 5;
            playButton.name = @"RetryButton";
            [scoreBoard addChild:playButton];
        } else {
            SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"PlayButton"]];
            playButton.position = CGPointMake(0, -self.frame.size.height/4.5);
            playButton.zPosition = 5;
            playButton.name = @"ContinueButton";
            [scoreBoard addChild:playButton];
            SKAction *startGameFade = [SKAction fadeAlphaTo:0.1 duration:1];
            SKAction *wait = [SKAction waitForDuration:2];
            SKAction *startGameColor = [SKAction fadeAlphaTo:1.0 duration:1];
            SKAction *startGameSequence = [SKAction sequence:@[startGameFade,startGameColor,wait]];
            SKAction *startGameActionRepeatForever = [SKAction repeatActionForever:startGameSequence];
            [playButton runAction:startGameActionRepeatForever];
        }
        
        if (level > highLevel) {
            highLevel = level;
            NSUserDefaults *highLevelData = [NSUserDefaults standardUserDefaults];
            [highLevelData setInteger:highLevel forKey:@"highLevel"];
            [highLevelData synchronize];
        }
        
        if ((level <= highLevel) && (level != 1)) {
            SKSpriteNode *arrow1 = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow"];
            arrow1.position = CGPointMake(-self.frame.size.width/4, 0 + arrow1.frame.size.height/5);
            arrow1.zPosition = 5;
            arrow1.name = @"Arrow1";
            [self.gameLayer addChild:arrow1];
        }
        if (level+1 <= highLevel) {
            SKSpriteNode *arrow2 = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow"];
            arrow2.position = CGPointMake(self.frame.size.width/4, 0 + arrow2.frame.size.height/5);
            arrow2.zPosition = 5;
            arrow2.xScale = -1;
            arrow2.name = @"Arrow2";
            [self.gameLayer addChild:arrow2];
        }
    }
    
    if (storyModeOn == YES && level == 51) {
        
        clicked = YES;
        
        NSUserDefaults *levelData = [NSUserDefaults standardUserDefaults];
        [levelData setInteger:level forKey:@"level"];
        [levelData synchronize];
        
        SKSpriteNode *blackScreen = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.frame.size];
        blackScreen.position = CGPointZero;
        blackScreen.zPosition = 15;
        blackScreen.name = @"BlackScreen";
        [self.gameLayer addChild:blackScreen];
        
        score.alpha = 0;
        
        SKLabelNode *stayTunedLabel = [SKLabelNode labelNodeWithFontNamed:@"ArialMT"];
        stayTunedLabel.position = CGPointMake(0, self.frame.size.height/2.5 - self.frame.size.height);
        stayTunedLabel.zPosition = 16;
        stayTunedLabel.fontSize = 40;
        stayTunedLabel.lineBreakMode = NSLineBreakByWordWrapping;
        stayTunedLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        stayTunedLabel.numberOfLines = 20;
        stayTunedLabel.preferredMaxLayoutWidth = 650.0;
        stayTunedLabel.name = @"stayTunedLabel";
        stayTunedLabel.text = @"      Congratulations! You Made It To The End Of The Story.\n \n       Words Cannot Describe How Thankful I Am For You Playing And Beating My Game.\n \n       If You Love The Game Please Rate It On The App Store And Share It On Your Social Media Right Now!\n \n      As Your Seeing This New Levels, Characters And Maps Are Being Developed For Your Pleasure, So Please Stay Tuned For Updates.\n \n                       Credits \n \nGraphic Design: William Miller \n \nProgrammer: William Miller \n \nSound Effects: William Miller \n \nTheme Music: Walter Thomas \n \nDeveloper: FluxFire LLC\n \n \n--Thanks For Playing Food Fall!!!--";
        [self addChild:stayTunedLabel];
        
        SKLabelNode *continueLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        continueLabel.position = CGPointMake(0, -self.frame.size.height/2.5);
        continueLabel.zPosition = 16;
        continueLabel.fontSize = 35;
        continueLabel.preferredMaxLayoutWidth = 650.0;
        continueLabel.name = @"continueLabel";
        continueLabel.text = @"Click Anywhere To Continue...";
        [self addChild:continueLabel];
        
        [blackScreen runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0],[SKAction fadeInWithDuration:30]]]];
        [stayTunedLabel runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0, self.frame.size.height + self.frame.size.height) duration:60]]]];
        [continueLabel runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0],[SKAction waitForDuration:30],[SKAction fadeInWithDuration:1]]]];
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:31],[SKAction runBlock:^{clicked = NO;}]]]];
        
        victory = NO;
        
    }
    
    homeButton.name = @"HomeButton";
    homeButton.zPosition = 4;
    [scoreBoard addChild:homeButton];
    
    if (extraLifeInt == 0 & victory == NO) {
        SKSpriteNode *videoButton = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"VideoButton"]];
        videoButton.position = CGPointMake(0, -self.frame.size.height/2.8);
        videoButton.zPosition = 4;
        videoButton.name = @"VideoButton";
        [self.gameLayer addChild:videoButton];
    }
    
    [score runAction:[SKAction moveTo:CGPointMake(0, 0+140) duration:0]];
    
    [bar1 removeFromParent];
    [bar2 removeFromParent];
    [bar3 removeFromParent];
    [bar4 removeFromParent];
    [bar5 removeFromParent];
    [bar6 removeFromParent];
    
    bar1.name = nil;
    bar2.name = nil;
    bar3.name = nil;
    bar4.name = nil;
    bar5.name = nil;
    bar6.name = nil;
    
    veryEasy = NO;
    easy = NO;
    medium = NO;
    veryMedium = NO;
    hard = NO;
    veryHard = NO;
    blackandWhite = NO;
    
}
-(void)resumeGame {
    
    if (reward == YES) {
        [score removeFromParent];
        [score setText:[NSString stringWithFormat:@"%i", scoreValue]];
        [score runAction:[SKAction moveTo:CGPointMake(0, self.frame.size.height/2.5) duration:0]];
        [[self.gameLayer childNodeWithName:@"ScoreBoard"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"highScoreLabel"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"MainMenu"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"RemoveAdsButton"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"PlayButton"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"TutorialButton"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"SoundButton"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"Check1"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"Check2"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"Arrow1"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"Arrow2"] removeFromParent];
        [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
        [self addChild:score];
        [self characters];
        [self SpawnFood];
        rewarded = NO;
        reward = NO;
        [rewardedTimer invalidate];
    } else  {
        NSLog(@"Did Not Recieve Reawrd");
    }
    if (dismissed == YES) {
        [rewardedTimer invalidate];
        dismissed = NO;
    }
    
}
-(void)spawnTutorialLabel {
    
}
-(void)activateTutorial {
    
    [self.foodlayer removeAllChildren];
    [character removeFromParent];
    [character removeAllActions];
    [tutorialLabel removeFromParent];
    [actionLabel removeFromParent];
    [aLabel removeFromParent];
    [bar1 removeFromParent];
    [bar2 removeFromParent];
    bar1 = nil;
    bar2 = nil;
    
    NSLog(correctBar ? @"Correct Bar: " @"YES" : @"Correct Bar: " @"NO");
    
    if (storyModeOn == YES) {
        
        if (level == 1) {
            
            NSArray *text1Array = @[
                @"Swipe Fruits & Veggies To Corresponding Color",
                @"Swipe Apple To Light Red Bar",
                @"Swipe BellPepper Dark Red Bar",
                @"Swipe Candy Apple (AKA JunkFood) to Black Bar",
                @"Fruits & Veggies Can Also Hit The White Bar",
                @"Fruits & Veggies Can Never Hit The Black Bar!",
                @"Only JunkFood Can Hit The Black Bar!",
                @"Congratulations You're Ready Good Luck"
            ];
            
            NSArray *text2Array = @[
                @"Tap anywhere...",
                @"Tap to begin game!"
            ];
            
            NSArray *tutArray1 = @[
                @"LightRedBar",
                @"BlackBar",
                @"WhiteBar",
                @"WhiteBar",
                @"BlackBar",
            ];
            
            NSArray *tutArray2 = @[
                @"DarkRedBar",
                @"WhiteBar",
                @"BlackBar",
                @"BlackBar",
            ];
            
            if (m < 8) {
                
                if (correctBar == YES) {
                    m++;
                }
                
                NSUInteger charNum = m;
                NSString *charType = [text1Array objectAtIndex:charNum];
                text1Name = [NSString stringWithString:charType];
                tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                tutorialLabel.zPosition = 6;
                tutorialLabel.fontSize = 45;
                tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                tutorialLabel.numberOfLines = 5;
                tutorialLabel.preferredMaxLayoutWidth = 500.0;
                tutorialLabel.name = @"tutorialLabel";
                tutorialLabel.text = text1Name;
                [self addChild:tutorialLabel];
                
            } // Text 1 Array
            
            if ((m==0)||(m==7)) {
                
                if (correctBar == YES) {
                    w++;
                }
                
                NSUInteger charNum = w;
                NSString *charType = [text2Array objectAtIndex:charNum];
                text2Name = [NSString stringWithString:charType];
                actionLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                actionLabel.position = CGPointMake(0, -self.frame.size.height/2.5);
                actionLabel.zPosition = 6;
                actionLabel.fontSize = 45;
                actionLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
                actionLabel.numberOfLines = 5;
                actionLabel.preferredMaxLayoutWidth = 500.0;
                actionLabel.name = @"actionLabel";
                actionLabel.text = text2Name;
                [self addChild:actionLabel];
                
            } // Text 2 Array
            
            if ((m==1)||(m==2)||(m==3)||(m==4)||(m==5)||(m==6)) {
                
                if (correctBar == YES) {
                    x++;
                }
                
                [self characters];
                NSUInteger charNum1 = x;
                NSString *charType1 = [characterArray objectAtIndex:charNum1];
                characterName = [NSString stringWithString:charType1];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
            } // Character Sprites
            
            if ((m==1)||(m==3)||(m==4)||(m==5)||(m==6)) {
                
                if (correctBar == YES) {
                    n++;
                }
                
                NSUInteger bar1Num = n;
                NSString *bar1Type = [tutArray1 objectAtIndex:bar1Num];
                bar1Name = [NSString stringWithString:bar1Type];
                
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
            } // Bar 1 Sprites
            
            if ((m==2)||(m==4)||(m==5)||(m==6)) {
                
                if (correctBar == YES & m != 2) {
                    o++;
                }
                
                
                
                NSUInteger bar2Num = o;
                NSString *bar2Type = [tutArray2 objectAtIndex:bar2Num];
                bar2Name = [NSString stringWithString:bar2Type];
                
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
            } // Bar 2 Sprites
            
            if (m==0) {
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],[SKAction runBlock:^{clicked = NO;}]]]];
            } // Prevents double click upon tutorial initialization
            
            if (m == 7) {
                if (clicked == YES) {
                    endTutorial = YES;
                    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],[SKAction runBlock:^{clicked = NO;}]]]];
                    correctBar = NO;
                }
                if (clicked == NO) {
                    [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
                        [tutorialLabel removeFromParent];
                        [actionLabel removeFromParent];
                        activatedtut = NO;
                        
                        NSUserDefaults* tutorialDefaults = [NSUserDefaults standardUserDefaults];
                        [tutorialDefaults setBool:activatedtut forKey:@"activatedtut"];
                        [tutorialDefaults synchronize];
                        
                        correctBar = NO;
                        endTutorial = NO;
                        [self addChild:score];
                        self.physicsWorld.gravity = CGVectorMake(0, -6);
                        [self characters];
                        [self SpawnFood];
                        
                        m = 0;
                        w = 0;
                        n = 0;
                        x = 0;
                        o = 0;
                        
                    }]]]];
                }
            } // End tutorial & start game
            
            [self barLogic];
            
        }
        
        if (level == 11) {
            
            if (correctBar == YES & x == 1) {
                m++;
            }
            
            NSArray *text3Array = @[
                @"Congratulations you've made it!",
                @"This is where things get tricky.",
                @"Say Hello to your new friends The Red Pear & The Pomegranate",
                @"The Red Pear & Pomegranate can hit either The Dark Red Bar or The White Bar",
                @"Go ahead and try",
                @"Easy right? Now remember this.",
                @"The Red Jelly Bean can only hit the black bar",
                @"Go ahead and try",
                @"Great Job!",
                @"Last is the Red Cupcake",
                @"Just like the Jelly Bean the cupcake can only hit the black bar",
                @"Go Ahead and Try",
                @"Congratulations you're ready! Good Luck!!!"
            ];
            
            NSArray *foodArray = @[
                @"RedPear",
                @"Pomegranate"
            ];
            
            NSUInteger charNum = m;
            NSString *charType = [text3Array objectAtIndex:charNum];
            text1Name = [NSString stringWithString:charType];
            tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
            tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
            tutorialLabel.zPosition = 6;
            tutorialLabel.fontSize = 45;
            tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
            tutorialLabel.numberOfLines = 5;
            tutorialLabel.preferredMaxLayoutWidth = 500.0;
            tutorialLabel.name = @"tutorialLabel";
            tutorialLabel.text = text1Name;
            [self addChild:tutorialLabel];
            
            if (m == 0) {
                
                [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction waitForDuration:2.5],[SKAction runBlock:^{
                    m++;
                    [tutorialLabel removeFromParent];
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                }]]] count:2],[SKAction runBlock:^{
                    characterName = [NSString stringWithFormat:@"RedPear"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    characterName = [NSString stringWithFormat:@"Pomegranate"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6 + character.frame.size.height);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"WhiteBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    [[self.foodlayer childNodeWithName:@"RedPear"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointZero duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [[self.foodlayer childNodeWithName:@"Pomegranate"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0, 0 + character.frame.size.height*1.5) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                }],[SKAction sequence:@[[SKAction waitForDuration:2.5],[SKAction runBlock:^{
                    m++;
                    [tutorialLabel removeFromParent];
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                }],[SKAction sequence:@[[SKAction waitForDuration:7],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    [self.foodlayer removeAllChildren];
                    [self.foodlayer removeAllActions];
                    [bar1 removeFromParent];
                    [bar2 removeFromParent];
                    [bar1 removeAllActions];
                    [bar2 removeAllActions];
                    
                    characterName = [NSString stringWithFormat:@"RedPear"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                    character.physicsBody.dynamic = YES;
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"WhiteBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                    
                    [self barLogic];
                    
                    NSLog(@"m: "@"%d", m);
                    
                }]]]]]]]];
                
            }
            
            if (m == 4) {
                
                if (correctBar == YES) {
                    x++;
                }
                
                NSUInteger charNum1 = x;
                NSString *charType1 = [foodArray objectAtIndex:charNum1];
                
                characterName = [NSString stringWithString:charType1];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                if (x == 0) {
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                } else {
                    bar1Name = [NSString stringWithFormat:@"BlackBar"];
                }
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                if (x == 0) {
                    bar2Name = [NSString stringWithFormat:@"WhiteBar"];
                } else {
                    bar2Name = [NSString stringWithFormat:@"DarkRedBar"];
                }
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
                [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
                [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
            }
            
            if (m == 5) {
                
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:3],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    
                    characterName = [NSString stringWithFormat:@"n&nDark"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"BlackBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    [character runAction:[SKAction sequence:@[[SKAction moveTo:CGPointZero duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar1 runAction:[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                }],[SKAction sequence:@[[SKAction waitForDuration:7],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    [character removeAllActions];
                    [character removeFromParent];
                    [bar1 removeFromParent];
                    [bar2 removeFromParent];
                    [bar1 removeAllActions];
                    [bar2 removeAllActions];
                    
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"BlackBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    characterName = [NSString stringWithFormat:@"n&nDark"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                    character.physicsBody.dynamic = YES;
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                    
                    [self barLogic];
                    
                }]]]]]];
                
            }
            
            if (m == 7) {
                
                bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                bar2Name = [NSString stringWithFormat:@"BlackBar"];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
                characterName = [NSString stringWithFormat:@"n&nDark"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
                [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
            }
            
            if (m == 8) {
                
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:3],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    
                    characterName = [NSString stringWithFormat:@"RedVelvetCupCake"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    [character runAction:[SKAction sequence:@[[SKAction moveTo:CGPointZero duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                }],[SKAction waitForDuration:6],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    
                    bar1Name = [NSString stringWithFormat:@"BlackBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar2 runAction:[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3]];
                    
                }],[SKAction sequence:@[[SKAction waitForDuration:7],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    [character removeAllActions];
                    [character removeFromParent];
                    [bar1 removeFromParent];
                    [bar2 removeFromParent];
                    [bar1 removeAllActions];
                    [bar2 removeAllActions];
                    
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text3Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    bar1Name = [NSString stringWithFormat:@"BlackBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    characterName = [NSString stringWithFormat:@"RedVelvetCupCake"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                    character.physicsBody.dynamic = YES;
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                    
                    [self barLogic];
                    
                }]]]]]];
            }
            
            if (m == 11) {
                
                bar1Name = [NSString stringWithFormat:@"BlackBar"];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                bar2Name = [NSString stringWithFormat:@"DarkRedBar"];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
                characterName = [NSString stringWithFormat:@"RedVelvetCupCake"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
                [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
            }
            
            if (m == 12) {
                
                NSArray *countdown = @[
                    @"3",
                    @"2",
                    @"1"
                ];
                
                NSUInteger charNum = cd;
                NSString *charType = [countdown objectAtIndex:charNum];
                NSString *countdownString = [NSString stringWithString:charType];
                SKLabelNode *countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                countdownLabel.position = CGPointZero;
                countdownLabel.zPosition = 6;
                countdownLabel.fontSize = 100;
                countdownLabel.name = @"countdown";
                countdownLabel.text = countdownString;
                [self addChild:countdownLabel];
                
                [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction runBlock:^{
                    
                    cd++;
                    [[self childNodeWithName:@"countdown"] removeFromParent];
                    
                    NSUInteger charNum = cd;
                    NSString *charType = [countdown objectAtIndex:charNum];
                    NSString *countdownString = [NSString stringWithString:charType];
                    SKLabelNode *countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    countdownLabel.position = CGPointZero;
                    countdownLabel.zPosition = 6;
                    countdownLabel.fontSize = 100;
                    countdownLabel.name = @"countdown";
                    countdownLabel.text = countdownString;
                    [self addChild:countdownLabel];
                    
                }]]] count:2],[SKAction waitForDuration:1],[SKAction runBlock:^{
                    
                    [tutorialLabel removeFromParent];
                    [[self childNodeWithName:@"countdown"] removeFromParent];
                    
                    activatedtut = NO;
                    
                    NSUserDefaults* tutorialDefaults = [NSUserDefaults standardUserDefaults];
                    [tutorialDefaults setBool:activatedtut forKey:@"activatedtut"];
                    [tutorialDefaults synchronize];
                    
                    correctBar = NO;
                    endTutorial = NO;
                    [self addChild:score];
                    self.physicsWorld.gravity = CGVectorMake(0, -6);
                    [self characters];
                    [self SpawnFood];
                    
                    m = 0;
                    w = 0;
                    n = 0;
                    x = 0;
                    o = 0;
                    cd = 0;
                    
                }]]]];
                
            }
            
            [self barLogic];
            
        }
        
        if (level == 21) {
            
            if (correctBar == YES) {
                m++;
            } else {
                
            }
            NSArray *text4Array = @[
                @"Congratulations you have strived on and for your efforts, allow me to introduce you to your new friend...",
                @"The Tomato, similar to the apple can be swiped to the light red bar or the white bar",
                @"Go ahead and try",
                @"Great Job! Now meet the strawberry",
                @"The strawberry can hit the light red bar and the white bar",
                @"Give it a try!",
                @"Nice job! At last meet the m&m!",
                @"The m&m can only hit the black bar",
                @"Go ahead and try",
                @"Congratulations! You're ready! Good Luck."
            ];
            
            NSUInteger charNum = m;
            NSString *charType = [text4Array objectAtIndex:charNum];
            text1Name = [NSString stringWithString:charType];
            tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
            tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
            tutorialLabel.zPosition = 6;
            tutorialLabel.fontSize = 45;
            tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
            tutorialLabel.numberOfLines = 5;
            tutorialLabel.preferredMaxLayoutWidth = 500.0;
            tutorialLabel.name = @"tutorialLabel";
            tutorialLabel.text = text1Name;
            [self addChild:tutorialLabel];
            
            if (m == 0) {
                
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],[SKAction runBlock:^{clicked = NO;}]]]];
                
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:6],[SKAction runBlock:^{
                    m++;
                    [tutorialLabel removeFromParent];
                    NSUInteger charNum = m;
                    NSString *charType = [text4Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    characterName = [NSString stringWithFormat:@"Tomato"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"LightRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"BlackBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    [character runAction:[SKAction sequence:@[[SKAction moveTo:CGPointZero duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3]]]];
                    
                }],[SKAction waitForDuration:7],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    [character removeAllActions];
                    [character removeFromParent];
                    [bar1 removeFromParent];
                    [bar2 removeFromParent];
                    [bar1 removeAllActions];
                    [bar2 removeAllActions];
                    
                    characterName = [NSString stringWithFormat:@"Tomato"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                    character.physicsBody.dynamic = YES;
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"LightRedBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text4Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:0.5]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:0.5]]]];
                    
                    [self barLogic];
                    
                    NSLog(@"m: "@"%d", m);
                }]]]];
            }
            
            if (m == 2) {
                
                characterName = [NSString stringWithFormat:@"Tomato"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                bar2Name = [NSString stringWithFormat:@"LightRedBar"];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
            }
            
            if (m == 3) {
                
                characterName = [NSString stringWithFormat:@"Strawberry"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                [character runAction:[SKAction sequence:@[[SKAction moveTo:CGPointZero duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:6],[SKAction runBlock:^{
                    m++;
                    [tutorialLabel removeFromParent];
                    NSUInteger charNum = m;
                    NSString *charType = [text4Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    bar1Name = [NSString stringWithFormat:@"LightRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3]]]];
                    
                }],[SKAction waitForDuration:8],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    [character removeAllActions];
                    [character removeFromParent];
                    [bar1 removeFromParent];
                    [bar2 removeFromParent];
                    [bar1 removeAllActions];
                    [bar2 removeAllActions];
                    
                    characterName = [NSString stringWithFormat:@"Strawberry"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                    character.physicsBody.dynamic = YES;
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"LightRedBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text4Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:0.5]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:0.5]]]];
                    
                    [self barLogic];
                    
                    NSLog(@"m: "@"%d", m);
                    
                }]]]];
            }
            
            if (m == 5) {
                
                characterName = [NSString stringWithFormat:@"Strawberry"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                bar2Name = [NSString stringWithFormat:@"LightRedBar"];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
            }
            
            if (m == 6) {
                
                characterName = [NSString stringWithFormat:@"n&n"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                [character runAction:[SKAction sequence:@[[SKAction moveTo:CGPointZero duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:8], [SKAction runBlock:^{
                    
                    m++;
                    [tutorialLabel removeFromParent];
                    NSUInteger charNum = m;
                    NSString *charType = [text4Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    bar1Name = [NSString stringWithFormat:@"BlackBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"BlackBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                }],[SKAction waitForDuration:10],[SKAction runBlock:^{
                    
                    m++;
                    
                    [tutorialLabel removeFromParent];
                    [character removeAllActions];
                    [character removeFromParent];
                    [bar1 removeFromParent];
                    [bar2 removeFromParent];
                    [bar1 removeAllActions];
                    [bar2 removeAllActions];
                    
                    characterName = [NSString stringWithFormat:@"n&n"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                    character.physicsBody.dynamic = YES;
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"BlackBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"WhiteBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    NSUInteger charNum = m;
                    NSString *charType = [text4Array objectAtIndex:charNum];
                    text1Name = [NSString stringWithString:charType];
                    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
                    tutorialLabel.zPosition = 6;
                    tutorialLabel.fontSize = 45;
                    tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
                    tutorialLabel.numberOfLines = 5;
                    tutorialLabel.preferredMaxLayoutWidth = 500.0;
                    tutorialLabel.name = @"tutorialLabel";
                    tutorialLabel.text = text1Name;
                    [self addChild:tutorialLabel];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:0.5]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:0.5]]]];
                    
                    [self barLogic];
                    
                    NSLog(@"m: "@"%d", m);
                }]]]];
                
            }
            
            if (m == 8) {
                
                characterName = [NSString stringWithFormat:@"n&n"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                bar1Name = [NSString stringWithFormat:@"BlackBar"];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                bar2Name = [NSString stringWithFormat:@"WhiteBar"];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
            }
            
            if (m == 9) {
                
                NSArray *countdown = @[
                    @"3",
                    @"2",
                    @"1"
                ];
                
                NSUInteger charNum = cd;
                NSString *charType = [countdown objectAtIndex:charNum];
                NSString *countdownString = [NSString stringWithString:charType];
                SKLabelNode *countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                countdownLabel.position = CGPointZero;
                countdownLabel.zPosition = 6;
                countdownLabel.fontSize = 100;
                countdownLabel.name = @"countdown";
                countdownLabel.text = countdownString;
                [self addChild:countdownLabel];
                
                [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction runBlock:^{
                    
                    cd++;
                    [[self childNodeWithName:@"countdown"] removeFromParent];
                    
                    NSUInteger charNum = cd;
                    NSString *charType = [countdown objectAtIndex:charNum];
                    NSString *countdownString = [NSString stringWithString:charType];
                    SKLabelNode *countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    countdownLabel.position = CGPointZero;
                    countdownLabel.zPosition = 6;
                    countdownLabel.fontSize = 100;
                    countdownLabel.name = @"countdown";
                    countdownLabel.text = countdownString;
                    [self addChild:countdownLabel];
                    
                }]]] count:2],[SKAction waitForDuration:1],[SKAction runBlock:^{
                    
                    [tutorialLabel removeFromParent];
                    [[self childNodeWithName:@"countdown"] removeFromParent];
                    
                    activatedtut = NO;
                    
                    NSUserDefaults* tutorialDefaults = [NSUserDefaults standardUserDefaults];
                    [tutorialDefaults setBool:activatedtut forKey:@"activatedtut"];
                    [tutorialDefaults synchronize];
                    
                    correctBar = NO;
                    endTutorial = NO;
                    [self addChild:score];
                    self.physicsWorld.gravity = CGVectorMake(0, -6);
                    [self characters];
                    [self SpawnFood];
                    
                    m = 0;
                    w = 0;
                    n = 0;
                    x = 0;
                    o = 0;
                    cd = 0;
                    
                }]]]];
                
            }
            
            [self barLogic];
            
        }
        
    }
    
    if (quickPlayOn == YES || ((storyModeOn == YES) && ((level != 1) && (level != 11) && (level != 21)))) {
        
        NSArray *text5Array = @[
            @"Remember This.",
            @"Swipe Fruits & Veggies To Corresponding Color",
            @"The Apple, Strawberry and Tomato can only hit the Light Red Bar or the White Bar",
            @"Go ahead and try",
            @"Great Job",
            @"The Bellpepper, Red Pear and Pomegranate can only hit the Dark Red Bar or and the White Bar",
            @"Give it a practice run",
            @"Great Job!",
            @"Now Remeber This",
            @"Swipe Junkfood to ONLY the Black Bar",
            @"The Candy Apple, Jelly Bean, Cupcake and m&m can only hit the Black Bar",
            @"Go ahead and try",
            @"Congratulations you got it!",
            @"Now your ready, Let the game begin!"
        ];
        
        NSArray *aArray = @[
            @"Correct!",
            @"Try Again."
        ];
        
        NSArray *foodArray = @[
            @"Apple",
            @"Tomato",
            @"Strawberry",
            @"BellPepper",
            @"RedPear",
            @"Pomegranate",
            @"CandyApple",
            @"n&nDark",
            @"n&n",
            @"RedVelvetCupCake"
        ];
        
        NSArray *barArray = @[
            @"LightRedBar",
            @"BlackBar",
            @"WhiteBar",
            @"DarkRedBar"
        ];
        
        NSArray *countdown = @[
            @"3",
            @"2",
            @"1"
        ];
        
        NSUInteger cdNum = cd;
        NSString *cdType = [countdown objectAtIndex:cdNum];
        NSString *countdownString = [NSString stringWithString:cdType];
        SKLabelNode *countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        countdownLabel.position = CGPointZero;
        countdownLabel.zPosition = 6;
        countdownLabel.fontSize = 100;
        countdownLabel.name = @"countdown";
        countdownLabel.text = countdownString;
        if (endTutorial == YES) {
            [self addChild:countdownLabel];
        }
        
        NSUInteger charNum = m;
        NSString *charType = [text5Array objectAtIndex:charNum];
        text1Name = [NSString stringWithString:charType];
        tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        tutorialLabel.position = CGPointMake(0, self.frame.size.height/2.5);
        tutorialLabel.zPosition = 6;
        tutorialLabel.fontSize = 45;
        tutorialLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        tutorialLabel.numberOfLines = 5;
        tutorialLabel.preferredMaxLayoutWidth = 500.0;
        tutorialLabel.name = @"tutorialLabel";
        tutorialLabel.text = text1Name;
        if (tutGame == NO) {
            [self addChild:tutorialLabel];
        }
        
        NSUInteger charNum1 = 0;
        if (correctBar == NO) {
            charNum1 = 1;
        }
        if (correctBar == YES) {
            charNum1 = 0;
        }
        NSString *charType1 = [aArray objectAtIndex:charNum1];
        NSString *text = [NSString stringWithString:charType1];
        aLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        aLabel.position = CGPointMake(0, self.frame.size.height/2.5);
        aLabel.zPosition = 6;
        aLabel.fontSize = 45;
        aLabel.name = @"aLabel";
        aLabel.text = text;
        if (tutGame == YES) {
            [self addChild:aLabel];
        }
        
        NSLog(tutGame ? @"tutGame: " @"YES" : @"tutGame: " @"NO");
        
        if (m < 2) {
            [self runAction:[SKAction sequence:@[[SKAction waitForDuration:3],[SKAction runBlock:^{
                m++;
                [self activateTutorial];
            }]]]];
        }
        
        if (m == 2) {
            [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
                
                characterName = [NSString stringWithFormat:@"Tomato"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                characterName = [NSString stringWithFormat:@"Apple"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                characterName = [NSString stringWithFormat:@"Strawberry"];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                bar1Name = [NSString stringWithFormat:@"LightRedBar"];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                bar2Name = [NSString stringWithFormat:@"WhiteBar"];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
                [[self.foodlayer childNodeWithName:@"Tomato"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointZero duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                
                [[self.foodlayer childNodeWithName:@"Apple"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 - character.frame.size.width, 0 + character.frame.size.height) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                
                [[self.foodlayer childNodeWithName:@"Strawberry"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 + character.frame.size.width, 0 + character.frame.size.height) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                
                [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                
                [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                
            }],[SKAction waitForDuration:9],[SKAction runBlock:^{
                m++;
                [self activateTutorial];
            }],[SKAction waitForDuration:2],[SKAction runBlock:^{
                tutGame = YES;
                [tutorialLabel removeFromParent];
            }]]]];
        }
        
        if (m == 3) {
            
            if (correctBar == YES) {
                x++;
            }
            
            if (x < 3) {
                
                int correctBarNum = arc4random() % 2;
                int barType = arc4random() % 3 + 1;
                
                NSUInteger charNum2;
                NSString *charType2;
                
                NSUInteger charNum1 = x;
                NSString *charType1 = [foodArray objectAtIndex:charNum1];
                
                characterName = [NSString stringWithString:charType1];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                if (correctBarNum == 0) {
                    charNum2 = 0;
                } else {
                    charNum2 = barType;
                }
                charType2 = [barArray objectAtIndex:charNum2];
                bar1Name = [NSString stringWithString:charType2];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                if (correctBarNum == 1) {
                    charNum2 = 0;
                } else {
                    charNum2 = barType;
                }
                charType2 = [barArray objectAtIndex:charNum2];
                bar2Name = [NSString stringWithString:charType2];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
                
                [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
                [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
            } else {
                [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
                    m++;
                    tutGame = NO;
                    correctBar = NO;
                    [self activateTutorial];
                }],[SKAction waitForDuration:3], [SKAction runBlock:^{
                    m++;
                    [self activateTutorial];
                    
                    characterName = [NSString stringWithFormat:@"BellPepper"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    characterName = [NSString stringWithFormat:@"RedPear"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    characterName = [NSString stringWithFormat:@"Pomegranate"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"DarkRedBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"WhiteBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    [[self.foodlayer childNodeWithName:@"BellPepper"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 - character.frame.size.width, 0) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [[self.foodlayer childNodeWithName:@"RedPear"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 + character.frame.size.width, 0) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [[self.foodlayer childNodeWithName:@"Pomegranate"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0, 0 + character.frame.size.height * 1.5) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                }],[SKAction waitForDuration:9],[SKAction runBlock:^{
                    m++;
                    [self activateTutorial];
                }],[SKAction waitForDuration:2],[SKAction runBlock:^{
                    tutGame = YES;
                    [tutorialLabel removeFromParent];
                }]]]];
            }
            
        }
        
        if (m == 6) {
            
            if (correctBar == YES) {
                x++;
            }
            
            if (x < 6) {
                
                int correctBarNum = arc4random() % 2;
                int barType = arc4random() % 3;
                
                NSUInteger charNum2;
                NSString *charType2;
                
                NSUInteger charNum1 = x;
                NSString *charType1 = [foodArray objectAtIndex:charNum1];
                
                characterName = [NSString stringWithString:charType1];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                if (correctBarNum == 0) {
                    charNum2 = 3;
                } else {
                    charNum2 = barType;
                }
                charType2 = [barArray objectAtIndex:charNum2];
                bar1Name = [NSString stringWithString:charType2];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                if (correctBarNum == 1) {
                    charNum2 = 3;
                } else {
                    charNum2 = barType;
                }
                charType2 = [barArray objectAtIndex:charNum2];
                bar2Name = [NSString stringWithString:charType2];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
                
                [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
                [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
            } else {
                [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
                    m++;
                    tutGame = NO;
                    correctBar = NO;
                    [self activateTutorial];
                }],[SKAction waitForDuration:3],[SKAction runBlock:^{
                    m++;
                    [self activateTutorial];
                }],[SKAction waitForDuration:3],[SKAction runBlock:^{
                    m++;
                    [self activateTutorial];
                }],[SKAction waitForDuration:3],[SKAction runBlock:^{
                    m++;
                    [self activateTutorial];
                    
                    characterName = [NSString stringWithFormat:@"CandyApple"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    characterName = [NSString stringWithFormat:@"n&nDark"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    characterName = [NSString stringWithFormat:@"RedVelvetCupcake"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    characterName = [NSString stringWithFormat:@"n&n"];
                    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                    character.name = characterName;
                    character.position = CGPointMake(0, self.frame.size.height/1.6);
                    character.zPosition = 1;
                    [self.foodlayer addChild:character];
                    
                    bar1Name = [NSString stringWithFormat:@"BlackBar"];
                    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                    bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                    bar1.zPosition = 1.1;
                    [self.gameLayer addChild:bar1];
                    
                    bar2Name = [NSString stringWithFormat:@"BlackBar"];
                    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                    bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                    bar2.zPosition = 1.1;
                    [self.gameLayer addChild:bar2];
                    
                    [[self.foodlayer childNodeWithName:@"CandyApple"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 - character.frame.size.width, 0 - character.frame.size.height/2) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [[self.foodlayer childNodeWithName:@"n&nDark"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 - character.frame.size.width, 0 + character.frame.size.height) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [[self.foodlayer childNodeWithName:@"RedVelvetCupcake"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 + character.frame.size.width, 0 + character.frame.size.height) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [[self.foodlayer childNodeWithName:@"n&n"] runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0 + character.frame.size.width, 0 - character.frame.size.height/2) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar1 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                    [bar2 runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.frame.size.width/2.25, self.frame.size.height/50.4) duration:3],[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],[SKAction fadeInWithDuration:0.5]]]]]]];
                    
                }],[SKAction waitForDuration:8],[SKAction runBlock:^{
                    m++;
                    [self activateTutorial];
                }],[SKAction waitForDuration:2],[SKAction runBlock:^{
                    tutGame = YES;
                    [tutorialLabel removeFromParent];
                }]]]];
            }
        }
        
        if (m == 11) {
            
            if (correctBar == YES) {
                x++;
            }
            
            if (x < 10) {
                
                int correctBarNum = arc4random() % 2;
                int barType = arc4random() % 4;
                
                NSUInteger charNum2;
                NSString *charType2;
                
                NSUInteger charNum1 = x;
                NSString *charType1 = [foodArray objectAtIndex:charNum1];
                
                characterName = [NSString stringWithString:charType1];
                character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
                character.name = characterName;
                character.position = CGPointMake(0, self.frame.size.height/1.6);
                character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
                character.physicsBody.dynamic = YES;
                character.zPosition = 1;
                [self.foodlayer addChild:character];
                
                if (correctBarNum == 0) {
                    charNum2 = 1;
                } else {
                    charNum2 = barType;
                }
                charType2 = [barArray objectAtIndex:charNum2];
                bar1Name = [NSString stringWithString:charType2];
                bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
                bar1.position = CGPointMake(-self.frame.size.width/2.25, self.frame.size.height/50.4 - self.frame.size.height);
                bar1.zPosition = 1.1;
                [self.gameLayer addChild:bar1];
                
                if (correctBarNum == 1) {
                    charNum2 = 1;
                } else {
                    charNum2 = barType;
                }
                charType2 = [barArray objectAtIndex:charNum2];
                bar2Name = [NSString stringWithString:charType2];
                bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
                bar2.position = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4 - self.frame.size.height);
                bar2.zPosition = 1.1;
                [self.gameLayer addChild:bar2];
                
                
                [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
                [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:self.frame.size.height/50.4 duration:0.2]]]];
                
            } else {
                [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
                    m++;
                    tutGame = NO;
                    correctBar = NO;
                    [self activateTutorial];
                }],[SKAction waitForDuration:3],[SKAction runBlock:^{
                    m++;
                    endTutorial = YES;
                    [self activateTutorial];
                }],[SKAction repeatAction:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction runBlock:^{
                    
                    cd++;
                    [[self childNodeWithName:@"countdown"] removeFromParent];
                    
                    NSUInteger charNum = cd;
                    NSString *charType = [countdown objectAtIndex:charNum];
                    NSString *countdownString = [NSString stringWithString:charType];
                    SKLabelNode *countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
                    countdownLabel.position = CGPointZero;
                    countdownLabel.zPosition = 6;
                    countdownLabel.fontSize = 100;
                    countdownLabel.name = @"countdown";
                    countdownLabel.text = countdownString;
                    [self addChild:countdownLabel];
                    
                }]]] count:2],[SKAction waitForDuration:1],[SKAction runBlock:^{
                    
                    [tutorialLabel removeFromParent];
                    [[self childNodeWithName:@"countdown"] removeFromParent];
                    
                    activatedtut = NO;
                    correctBar = NO;
                    endTutorial = NO;
                    
                    NSUserDefaults* tutorialDefaults = [NSUserDefaults standardUserDefaults];
                    [tutorialDefaults setBool:activatedtut forKey:@"activatedtut"];
                    [tutorialDefaults synchronize];
                    
                    [self addChild:score];
                    self.physicsWorld.gravity = CGVectorMake(0, -6);
                    [self characters];
                    [self SpawnFood];
                    
                    m = 0;
                    w = 0;
                    n = 0;
                    x = 0;
                    o = 0;
                    cd = 0;
                    
                }]]]];
            }
            
        }
        
        [self barLogic];
        
    }
    
    NSLog(@"m: "@"%d", m);
    
}

#pragma mark - Logic

-(void)setLogic {
    
    if (set == 1) { // Very Easy
        
        proBarNum = 2;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        b = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
    }
    if (set == 2) { // Easy
        
        proBarNum = 3;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        b = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        c = CGPointMake(0 , -self.frame.size.height/2.1);
        
    }
    if (set == 3) { // Medium
        
        proBarNum = 3;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        b = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        c = CGPointMake(self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
    }
    if (set == 4) { // Hard
        
        proBarNum = 4;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        b = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        c = CGPointMake(-self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
        d = CGPointMake(self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
        
    }
    if (set == 5) { // Hard
        
        proBarNum = 5;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        b = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        c = CGPointMake(-self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
        d = CGPointMake(self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
        e = CGPointMake(0 , -self.frame.size.height/2.1);
        
    }
    if (set == 6) { // Very Hard
        
        proBarNum = 4;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        b = CGPointMake(-self.frame.size.width/3.25 , self.frame.size.height/3.4);
        
        c = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        d = CGPointMake(self.frame.size.width/3.25 , -self.frame.size.height/3.4);
        
    }
    if (set == 7) { // Medium
        
        proBarNum = 3;
        
        a = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        b = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        c = CGPointMake(-self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
    }
    if (set == 8) { // Very Hard
        
        proBarNum = 4;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        b = CGPointMake(-self.frame.size.width/3.25 , 0);
        
        c = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        d = CGPointMake(self.frame.size.width/3.25 , 0);
        
    }
    if (set == 9) { // Very Hard
        
        proBarNum = 2;
        
        a = CGPointMake(-self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
        b = CGPointMake(self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
    }
    if (set == 10) { // Medium
        
        proBarNum = 3;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        b = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        c = CGPointMake(0 , -self.frame.size.height/2.1);
        
    }
    if (set == 11) { // Very Hard
        
        proBarNum = 4;
        
        a = CGPointMake(-self.frame.size.width/2.25 , self.frame.size.height/50.4);
        
        b = CGPointMake(-self.frame.size.width/3.25 , 0);
        
        c = CGPointMake(self.frame.size.width/2.25 , self.frame.size.height/3.4);
        
        d = CGPointMake(self.frame.size.width/2.25 , -self.frame.size.height/3.4);
        
    }
    
    
    properBar = arc4random() % proBarNum+1;
    int barC = 1; //Bar color (red v White)
    int zz=5;  //ratio for white bar to spawn
    barC = arc4random() % zz+1;
    if (blackandWhite == YES) {
        barC = zz;
    }
    
    
    if ([characterName isEqualToString:@"Apple"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"LightRedBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"LightRedBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"LightRedBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"LightRedBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"LightRedBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"LightRedBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"BellPepper"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"DarkRedBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"DarkRedBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"DarkRedBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"DarkRedBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"DarkRedBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"DarkRedBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"RedPear"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"DarkRedBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"DarkRedBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"DarkRedBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"DarkRedBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"DarkRedBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"DarkRedBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Pomegranate"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"DarkRedBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"DarkRedBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"DarkRedBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"DarkRedBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"DarkRedBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"DarkRedBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Tomato"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"LightRedBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"LightRedBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"LightRedBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"LightRedBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"LightRedBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"LightRedBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Strawberry"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"LightRedBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"LightRedBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"LightRedBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"LightRedBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"LightRedBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"LightRedBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"GreenApple"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"AppleGreenBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"AppleGreenBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"AppleGreenBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"AppleGreenBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"AppleGreenBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"AppleGreenBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"GreenBellpepper"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"DarkGreenBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"DarkGreenBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"DarkGreenBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"DarkGreenBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"DarkGreenBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"DarkGreenBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Broccoli"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"DarkGreenBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"DarkGreenBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"DarkGreenBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"DarkGreenBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"DarkGreenBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"DarkGreenBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Pear"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"LightGreenBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"LightGreenBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"LightGreenBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"LightGreenBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"LightGreenBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"LightGreenBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Watermelon"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"DarkGreenBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"DarkGreenBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"DarkGreenBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"DarkGreenBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"DarkGreenBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"DarkGreenBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Carrot"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"DarkOrangeBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"DarkOrangeBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"DarkOrangeBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"DarkOrangeBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"DarkOrangeBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"DarkOrangeBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Orange"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"LightOrangeBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"LightOrangeBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"LightOrangeBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"LightOrangeBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"LightOrangeBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"LightOrangeBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"Potato"]) {
        if (properBar == 1) {if(barC < zz){bar1Name = @"BrownBar";}if(barC == zz){bar1Name = @"WhiteBar";}}
        if (properBar == 2) {if(barC < zz){bar2Name = @"BrownBar";}if(barC == zz){bar2Name = @"WhiteBar";}}
        if (properBar == 3) {if(barC < zz){bar3Name = @"BrownBar";}if(barC == zz){bar3Name = @"WhiteBar";}}
        if (properBar == 4) {if(barC < zz){bar4Name = @"BrownBar";}if(barC == zz){bar4Name = @"WhiteBar";}}
        if (properBar == 5) {if(barC < zz){bar5Name = @"BrownBar";}if(barC == zz){bar5Name = @"WhiteBar";}}
        if (properBar == 6) {if(barC < zz){bar6Name = @"BrownBar";}if(barC == zz){bar6Name = @"WhiteBar";}}
    }
    if ([characterName isEqualToString:@"CandyApple"]) {
        if (properBar == 1) {bar1Name = @"BlackBar";}
        if (properBar == 2) {bar2Name = @"BlackBar";}
        if (properBar == 3) {bar3Name = @"BlackBar";}
        if (properBar == 4) {bar4Name = @"BlackBar";}
        if (properBar == 5) {bar5Name = @"BlackBar";}
        if (properBar == 6) {bar6Name = @"BlackBar";}
    }
    if ([characterName isEqualToString:@"RedVelvetCupCake"]) {
        if (properBar == 1) {bar1Name = @"BlackBar";}
        if (properBar == 2) {bar2Name = @"BlackBar";}
        if (properBar == 3) {bar3Name = @"BlackBar";}
        if (properBar == 4) {bar4Name = @"BlackBar";}
        if (properBar == 5) {bar5Name = @"BlackBar";}
        if (properBar == 6) {bar6Name = @"BlackBar";}
    }
    if ([characterName isEqualToString:@"IceCreamCone"]) {
        if (properBar == 1) {bar1Name = @"BlackBar";}
        if (properBar == 2) {bar2Name = @"BlackBar";}
        if (properBar == 3) {bar3Name = @"BlackBar";}
        if (properBar == 4) {bar4Name = @"BlackBar";}
        if (properBar == 5) {bar5Name = @"BlackBar";}
        if (properBar == 6) {bar6Name = @"BlackBar";}
    }
    if ([characterName isEqualToString:@"CornDog"]) {
        if (properBar == 1) {bar1Name = @"BlackBar";}
        if (properBar == 2) {bar2Name = @"BlackBar";}
        if (properBar == 3) {bar3Name = @"BlackBar";}
        if (properBar == 4) {bar4Name = @"BlackBar";}
        if (properBar == 5) {bar5Name = @"BlackBar";}
        if (properBar == 6) {bar6Name = @"BlackBar";}
    }
    if ([characterName isEqualToString:@"Muffin"]) {
        if (properBar == 1) {bar1Name = @"BlackBar";}
        if (properBar == 2) {bar2Name = @"BlackBar";}
        if (properBar == 3) {bar3Name = @"BlackBar";}
        if (properBar == 4) {bar4Name = @"BlackBar";}
        if (properBar == 5) {bar5Name = @"BlackBar";}
        if (properBar == 6) {bar6Name = @"BlackBar";}
    }
    if ([characterName isEqualToString:@"n&n"]) {
        if (properBar == 1) {bar1Name = @"BlackBar";}
        if (properBar == 2) {bar2Name = @"BlackBar";}
        if (properBar == 3) {bar3Name = @"BlackBar";}
        if (properBar == 4) {bar4Name = @"BlackBar";}
        if (properBar == 5) {bar5Name = @"BlackBar";}
        if (properBar == 6) {bar6Name = @"BlackBar";}
    }
    if ([characterName isEqualToString:@"n&nDark"]) {
        if (properBar == 1) {bar1Name = @"BlackBar";}
        if (properBar == 2) {bar2Name = @"BlackBar";}
        if (properBar == 3) {bar3Name = @"BlackBar";}
        if (properBar == 4) {bar4Name = @"BlackBar";}
        if (properBar == 5) {bar5Name = @"BlackBar";}
        if (properBar == 6) {bar6Name = @"BlackBar";}
    }
    
    if ([characterName isEqualToString:@"Apple"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar"
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar",
                @"DarkRedBar",@"DarkRedBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"BlackBar",@"BlackBar",@"WhiteBar",@"BlackBar",@"BlackBar"
            ];
        }
        
    }
    
    if ([characterName isEqualToString:@"BellPepper"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar"
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"LightRedBar",@"BlackBar"
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar",
                @"LightRedBar",@"LightRedBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"BlackBar",@"BlackBar",@"WhiteBar",@"BlackBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"Pomegranate"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar"
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"LightRedBar",@"BlackBar"
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar",
                @"LightRedBar",@"LightRedBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"BlackBar",@"BlackBar",@"WhiteBar",@"BlackBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"RedPear"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar"
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"LightRedBar",@"BlackBar"
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"WhiteBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar",
                @"LightRedBar",@"LightRedBar",@"BlackBar",@"LightRedBar",@"LightRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"BlackBar",@"BlackBar",@"WhiteBar",@"BlackBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"Tomato"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar"
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar",
                @"DarkRedBar",@"DarkRedBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"BlackBar",@"BlackBar",@"WhiteBar",@"BlackBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"CandyApple"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"DarkRedBar",@"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar",
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"RedVelvetCupCake"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar"
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"n&n"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"DarkRedBar",@"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar",
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar",@"LightRedBar",@"LightRedBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"n&nDark"]) {
        
        if (veryEasy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar"
            ];
        }
        if (easy == YES) {
            barArray = @[
                @"LightRedBar",@"LightRedBar",@"LightRedBar",@"DarkRedBar",@"DarkRedBar"
            ];
        }
        if (medium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"WhiteBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"LightRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"DarkRedBar",@"LightRedBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"WhiteBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"Strawberry"]) {
        
        if (medium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar"
            ];
        }
        if (veryMedium == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar"
            ];
        }
        if (hard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (veryHard == YES) {
            barArray = @[
                @"DarkRedBar",@"DarkRedBar",@"WhiteBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar",
                @"DarkRedBar",@"DarkRedBar",@"BlackBar",@"DarkRedBar",@"DarkRedBar",@"BlackBar",@"BlackBar"
            ];
        }
        if (blackandWhite == YES) {
            barArray = @[
                @"BlackBar",@"BlackBar",@"WhiteBar",@"BlackBar",@"BlackBar"
            ];
        }
    }
    
    if ([characterName isEqualToString:@"Pear"]) {
        barArray = @[
            @"WhiteBar",@"BlackBar",@"DarkGreenBar",@"DarkGreenBar",@"DarkGreenBar",@"BlackBar",@"DarkGreenBar",@"DarkGreenBar",@"DarkGreenBar",
        ];
    }
    
    if ([characterName isEqualToString:@"Carrot"]) {
        barArray = @[
            @"WhiteBar",
            @"BlackBar",
            @"BlackBar",
            @"BlackBar",
        ];
    }
    
    if ([characterName isEqualToString:@"GreenApple"]) {
        barArray = @[
            @"WhiteBar",
            @"DarkGreenBar",
            @"DarkGreenBar",
            @"DarkGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"BlackBar",
            @"BlackBar",
        ];
    }
    
    if ([characterName isEqualToString:@"Broccoli"]) {
        barArray = @[
            @"WhiteBar",
            @"AppleGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"BlackBar",
            @"BlackBar",
        ];
    }
    
    if ([characterName isEqualToString:@"GreenBellpepper"]) {
        barArray = @[
            @"WhiteBar",
            @"AppleGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"BlackBar",
            @"BlackBar",
        ];
    }
    
    if ([characterName isEqualToString:@"Watermelon"]) {
        barArray = @[
            @"WhiteBar",@"LightGreenBar",@"LightGreenBar",@"LightGreenBar",@"LightGreenBar",@"LightGreenBar",@"LightGreenBar",
        ];
    }
    
    if ([characterName isEqualToString:@"Orange"]) {
        barArray = @[
            @"DarkOrangeBar",
            @"DarkOrangeBar",
            @"WhiteBar",
            @"DarkOrangeBar",
            @"BlackBar",
            @"DarkOrangeBar",
        ];
    }
    
    if ([characterName isEqualToString:@"Potato"]) {
        barArray = @[
            @"BlackBar",
            @"BlackBar",
            @"BlackBar",
            @"BlackBar",
            @"WhiteBar",
            @"BlackBar",
        ];
    }
    
    if ([characterName isEqualToString:@"IceCreamCone"]) {
        barArray = @[
            @"DarkOrangeBar",
            @"DarkOrangeBar",
            @"DarkOrangeBar",
            @"LightOrangeBar",
            @"LightOrangeBar",
            @"LightOrangeBar",
        ];
    }
    
    if ([characterName isEqualToString:@"CornDog"]) {
        barArray = @[
            @"BrownBar",
            @"BrownBar",
            @"BrownBar",
            @"BrownBar",
            @"WhiteBar",
            @"BrownBar",
        ];
    }
    
    if ([characterName isEqualToString:@"Muffin"]) {
        barArray = @[
            @"AppleGreenBar",
            @"AppleGreenBar",
            @"WhiteBar",
            @"AppleGreenBar",
            @"LightGreenBar",
            @"LightGreenBar",
            @"DarkGreenBar",
            @"DarkGreenBar",
        ];
    }
    
    if (veryEasy == YES) {
        easy = NO;
        medium = NO;
        veryMedium = NO;
        hard = NO;
        veryHard = NO;
        blackandWhite = NO;
    }
    if (easy == YES) {
        veryEasy = NO;
        medium = NO;
        veryMedium = NO;
        hard = NO;
        veryHard = NO;
        blackandWhite = NO;
    }
    if (medium == YES) {
        veryEasy = NO;
        easy = NO;
        veryMedium = NO;
        hard = NO;
        veryHard = NO;
        blackandWhite = NO;
    }
    if (veryMedium == YES) {
        veryEasy = NO;
        easy = NO;
        medium = NO;
        hard = NO;
        veryHard = NO;
        blackandWhite = NO;
    }
    if (hard == YES) {
        veryEasy = NO;
        easy = NO;
        medium = NO;
        veryMedium = NO;
        veryHard = NO;
        blackandWhite = NO;
    }
    if (veryHard == YES) {
        veryEasy = NO;
        easy = NO;
        medium = NO;
        veryMedium = NO;
        hard = NO;
        blackandWhite = NO;
    }
    if (blackandWhite == YES) {
        veryEasy = NO;
        easy = NO;
        medium = NO;
        veryMedium = NO;
        hard = NO;
        veryHard = NO;
    }
    
} //Creates block structure defines proper and improper bars per apple Creates bar pattern variations for each food
-(void)SpawnFood {
    
    if (storyModeOn == YES) {
        [self levelLogic];
    }
    if (quickPlayOn == YES) {
        [self quickPlayLogic];
    }
    
    character = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:characterName]];
    character.name = characterName;
    character.position = CGPointMake(0, self.frame.size.height/1.6);
    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.size];
    character.physicsBody.dynamic = YES;
    character.zPosition = 7;
    [self.foodlayer addChild:character];
    
    [self spawnBars];
    
    
}
-(void)spawnBars {
    
    bar1 = nil;
    bar2 = nil;
    bar3 = nil;
    bar4 = nil;
    bar5 = nil;
    bar6 = nil;
    
    
    [self setLogic];
    
    NSUInteger bar1Num = arc4random() % (barArray.count - 1);
    NSString *bar1Type = [barArray objectAtIndex:bar1Num];
    if (properBar != 1) {
        bar1Name = [NSString stringWithString:bar1Type];
    }
    
    bar1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar1Name]];
    [self barLogic];
    bar1.position = CGPointMake(a.x, a.y - self.frame.size.height);
    bar1.zPosition = 1.1;
    if ((set == 4) || (set == 5) || (set == 9) || (set == 10)) {
        bar1.yScale = 0.50;
    }
    [self.gameLayer addChild:bar1];
    
    
    
    NSUInteger bar2Num = arc4random() % (barArray.count - 1);
    NSString *bar2Type = [barArray objectAtIndex:bar2Num];
    if (properBar != 2) {
        bar2Name = [NSString stringWithString:bar2Type];
    }
    
    bar2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar2Name]];
    [self barLogic];
    bar2.position = CGPointMake(b.x, b.y - self.frame.size.height);
    bar2.zPosition = 1.1;
    if ((set == 3) || (set == 4) || (set == 5) || (set == 6) || (set == 7) || (set == 9) || (set == 10)) {
        bar2.yScale = 0.50;
    }
    if ((set == 8) || (set == 11)) {
        bar2.yScale = 0.35;
    }
    [self.gameLayer addChild:bar2];
    
    
    
    
    if (proBarNum >= 3) {
        NSUInteger bar3Num = arc4random() % (barArray.count - 1);
        NSString *bar3Type = [barArray objectAtIndex:bar3Num];
        if (properBar != 3) {
            bar3Name = [NSString stringWithString:bar3Type];
        }
        
        bar3 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar3Name]];
        [self barLogic];
        if ((set == 3) || (set == 4) || (set == 5) || (set == 7) || (set == 11)) {
            bar3.yScale = 0.50;
        }
        if ((set == 2) || (set == 10)) {
            bar3.zRotation = M_PI_2;
            bar3.yScale = 0.25;
        }
        bar3.position = CGPointMake(c.x, c.y - self.frame.size.height);
        bar3.zPosition = 1.1;
        [self.gameLayer addChild:bar3];
    }
    
    
    
    
    if (proBarNum >= 4) {
        NSUInteger bar4Num = arc4random() % (barArray.count - 1);
        NSString *bar4Type = [barArray objectAtIndex:bar4Num];
        if (properBar != 4) {
            bar4Name = [NSString stringWithString:bar4Type];
        }
        
        bar4 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar4Name]];
        [self barLogic];
        bar4.position = CGPointMake(d.x, d.y - self.frame.size.height);
        bar4.zPosition = 1.1;
        if ((set == 4) || (set == 5) || (set == 6) || (set == 11)) {
            bar4.yScale = 0.50;
        }
        if (set == 8) {
            bar4.yScale = 0.35;
        }
        [self.gameLayer addChild:bar4];
    }
    
    
    
    
    if (proBarNum >= 5) {
        NSUInteger bar5Num = arc4random() % (barArray.count - 1);
        NSString *bar5Type = [barArray objectAtIndex:bar5Num];
        if (properBar != 5) {
            bar5Name = [NSString stringWithString:bar5Type];
        }
        
        bar5 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:bar5Name]];
        [self barLogic];
        bar5.position = CGPointMake(e.x, e.y - self.frame.size.height);
        bar5.zPosition = 1.1;
        if (set == 5) {
            bar5.zRotation = M_PI_2;
            bar5.yScale = 0.25;
        }
        [self.gameLayer addChild:bar5];
    }
    
    [bar1 runAction:[SKAction sequence:@[[SKAction moveToY:a.y duration:spawntime]]]];
    
    [bar2 runAction:[SKAction sequence:@[[SKAction moveToY:b.y duration:spawntime]]]];
    
    [bar3 runAction:[SKAction sequence:@[[SKAction moveToY:c.y duration:spawntime]]]];
    
    [bar4 runAction:[SKAction sequence:@[[SKAction moveToY:d.y duration:spawntime]]]];
    
    [bar5 runAction:[SKAction sequence:@[[SKAction moveToY:e.y duration:spawntime]]]];
    
    
} //spawns bars and scales them to there set position
-(void)barLogic {
    
    if ([characterName isEqualToString:@"Apple"]) {
        if (![bar1Name isEqualToString:@"LightRedBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"LightRedBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"LightRedBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"LightRedBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"LightRedBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"LightRedBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Apple"]) {
        if ([bar1Name isEqualToString:@"LightRedBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"LightRedBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"LightRedBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"LightRedBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"LightRedBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"LightRedBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"BellPepper"]) {
        if (![bar1Name isEqualToString:@"DarkRedBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"DarkRedBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"DarkRedBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"DarkRedBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"DarkRedBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"DarkRedBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"BellPepper"]) {
        if ([bar1Name isEqualToString:@"DarkRedBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"DarkRedBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"DarkRedBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"DarkRedBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"DarkRedBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"DarkRedBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Pomegranate"]) {
        if (![bar1Name isEqualToString:@"DarkRedBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"DarkRedBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"DarkRedBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"DarkRedBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"DarkRedBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"DarkRedBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Pomegranate"]) {
        if ([bar1Name isEqualToString:@"DarkRedBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"DarkRedBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"DarkRedBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"DarkRedBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"DarkRedBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"DarkRedBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"RedPear"]) {
        if (![bar1Name isEqualToString:@"DarkRedBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"DarkRedBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"DarkRedBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"DarkRedBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"DarkRedBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"DarkRedBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"RedPear"]) {
        if ([bar1Name isEqualToString:@"DarkRedBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"DarkRedBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"DarkRedBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"DarkRedBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"DarkRedBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"DarkRedBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Tomato"]) {
        if (![bar1Name isEqualToString:@"LightRedBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"LightRedBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"LightRedBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"LightRedBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"LightRedBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"LightRedBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Tomato"]) {
        if ([bar1Name isEqualToString:@"LightRedBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"LightRedBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"LightRedBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"LightRedBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"LightRedBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"LightRedBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Strawberry"]) {
        if (![bar1Name isEqualToString:@"LightRedBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"LightRedBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"LightRedBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"LightRedBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"LightRedBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"LightRedBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Strawberry"]) {
        if ([bar1Name isEqualToString:@"LightRedBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"LightRedBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"LightRedBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"LightRedBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"LightRedBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"LightRedBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Pear"]) {
        if (![bar1Name isEqualToString:@"LightGreenBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"LightGreenBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"LightGreenBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"LightGreenBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"LightGreenBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"LightGreenBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Pear"]) {
        if ([bar1Name isEqualToString:@"LightGreenBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"LightGreenBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"LightGreenBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"LightGreenBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"LightGreenBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"LightGreenBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"GreenApple"]) {
        if (![bar1Name isEqualToString:@"AppleGreenBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"AppleGreenBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"AppleGreenBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"AppleGreenBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"AppleGreenBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"AppleGreenBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"GreenApple"]) {
        if ([bar1Name isEqualToString:@"AppleGreenBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"AppleGreenBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"AppleGreenBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"AppleGreenBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"AppleGreenBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"AppleGreenBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Broccoli"]) {
        if (![bar1Name isEqualToString:@"DarkGreenBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"DarkGreenBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"DarkGreenBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"DarkGreenBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"DarkGreenBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"DarkGreenBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Broccoli"]) {
        if ([bar1Name isEqualToString:@"DarkGreenBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"DarkGreenBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"DarkGreenBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"DarkGreenBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"DarkGreenBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"DarkGreenBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"GreenBellpepper"]) {
        if (![bar1Name isEqualToString:@"DarkGreenBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"DarkGreenBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"DarkGreenBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"DarkGreenBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"DarkGreenBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"DarkGreenBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"GreenBellpepper"]) {
        if ([bar1Name isEqualToString:@"DarkGreenBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"DarkGreenBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"DarkGreenBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"DarkGreenBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"DarkGreenBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"DarkGreenBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Carrot"]) {
        if (![bar1Name isEqualToString:@"DarkOrangeBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"DarkOrangeBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"DarkOrangeBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"DarkOrangeBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"DarkOrangeBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"DarkOrangeBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Carrot"]) {
        if ([bar1Name isEqualToString:@"DarkOrangeBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"DarkOrangeBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"DarkOrangeBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"DarkOrangeBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"DarkOrangeBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"DarkOrangeBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Watermelon"]) {
        if (![bar1Name isEqualToString:@"DarkGreenBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"DarkGreenBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"DarkGreenBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"DarkGreenBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"DarkGreenBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"DarkGreenBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Watermelon"]) {
        if ([bar1Name isEqualToString:@"DarkGreenBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"DarkGreenBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"DarkGreenBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"DarkGreenBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"DarkGreenBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"DarkGreenBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Orange"]) {
        if (![bar1Name isEqualToString:@"LightOrangeBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"LightOrangeBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"LightOrangeBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"LightOrangeBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"LightOrangeBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"LightOrangeBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Orange"]) {
        if ([bar1Name isEqualToString:@"LightOrangeBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"LightOrangeBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"LightOrangeBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"LightOrangeBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"LightOrangeBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"LightOrangeBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Potato"]) {
        if (![bar1Name isEqualToString:@"BrownBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BrownBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BrownBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BrownBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BrownBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BrownBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Potato"]) {
        if ([bar1Name isEqualToString:@"BrownBar"]) {bar1.name = @"correctBar";}
        if ([bar1Name isEqualToString:@"WhiteBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BrownBar"]) {bar2.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"WhiteBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BrownBar"]) {bar3.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"WhiteBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BrownBar"]) {bar4.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"WhiteBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BrownBar"]) {bar5.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"WhiteBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BrownBar"]) {bar6.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"WhiteBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"IceCreamCone"]) {
        if ([bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"IceCreamCone"]) {
        if (![bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"CandyApple"]) {
        if ([bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"CandyApple"]) {
        if (![bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"RedVelvetCupCake"]) {
        if ([bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"RedVelvetCupCake"]) {
        if (![bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"CornDog"]) {
        if ([bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"CornDog"]) {
        if (![bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"Muffin"]) {
        if ([bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"Muffin"]) {
        if (![bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"n&n"]) {
        if ([bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"n&n"]) {
        if (![bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"incorrectBar";}
    }
    if ([characterName isEqualToString:@"n&nDark"]) {
        if ([bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"correctBar";}
        if ([bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"correctBar";}
        if ([bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"correctBar";}
        if ([bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"correctBar";}
        if ([bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"correctBar";}
        if ([bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"correctBar";}
    }
    if ([characterName isEqualToString:@"n&nDark"]) {
        if (![bar1Name isEqualToString:@"BlackBar"]) {bar1.name = @"incorrectBar";}
        if (![bar2Name isEqualToString:@"BlackBar"]) {bar2.name = @"incorrectBar";}
        if (![bar3Name isEqualToString:@"BlackBar"]) {bar3.name = @"incorrectBar";}
        if (![bar4Name isEqualToString:@"BlackBar"]) {bar4.name = @"incorrectBar";}
        if (![bar5Name isEqualToString:@"BlackBar"]) {bar5.name = @"incorrectBar";}
        if (![bar6Name isEqualToString:@"BlackBar"]) {bar6.name = @"incorrectBar";}
    }
    
}
-(void)swipeGestures {
    
    UISwipeGestureRecognizer * leftSwipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwiped1)];
    [leftSwipe1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe1 setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftSwipe1];
    
    UISwipeGestureRecognizer * rightSwipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwiped1)];
    [rightSwipe1 setDirection:UISwipeGestureRecognizerDirectionRight];
    [rightSwipe1 setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightSwipe1];
    
    UISwipeGestureRecognizer * downSwipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwiped1)];
    [downSwipe1 setDirection:UISwipeGestureRecognizerDirectionDown];
    [downSwipe1 setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:downSwipe1];
    
    UISwipeGestureRecognizer * leftSwipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwiped2)];
    [leftSwipe2 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [leftSwipe2 setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:leftSwipe2];
    
    UISwipeGestureRecognizer * rightSwipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwiped2)];
    [rightSwipe2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [rightSwipe2 setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:rightSwipe2];
    
    UISwipeGestureRecognizer * downSwipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwiped2)];
    [downSwipe2 setDirection:UISwipeGestureRecognizerDirectionDown];
    [downSwipe2 setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:downSwipe2];
    
    
}
-(void)leftSwiped1 {
    
    character.physicsBody.velocity = CGVectorMake(-1800, 0);
}
-(void)rightSwiped1 {
    character.physicsBody.velocity = CGVectorMake(1800, 0);
}
-(void)downSwiped1 {
    character.physicsBody.velocity = CGVectorMake(0, -2000);
}
-(void)leftSwiped2 {
}
-(void)rightSwiped2 {
}
-(void)downSwiped2 {
}

#pragma mark - Background Actions

-(void)update:(CFTimeInterval)currentTime {
    
    
    if ((CGRectIntersectsRect(character.frame, bar1.frame)) & [bar1.name isEqualToString:@"correctBar"]){
        if (activatedtut == YES) {
            correctBar = YES;
            [self activateTutorial];
            NSLog(@"correctBar 1");
        } else {
            [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
            [character removeFromParent];
            if (soundOn == YES) {
                [self runAction:correctSound];
            }
            SKAction *seq = [SKAction sequence:@[[SKAction moveToY:self.frame.size.height/1.4 *2 duration:spawntime],[SKAction removeFromParent]]];
            [bar1 runAction:seq];
            [bar2 runAction:seq];
            [bar3 runAction:seq];
            [bar4 runAction:seq];
            [bar5 runAction:seq];
            [self SpawnFood];
            if (scoreValue == 31 & storyModeOn == YES) {
                victory = YES;
                level++;
                [character removeFromParent];
                [self gameOverActions];
            }
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar1.frame)) & [bar1.name isEqualToString:@"incorrectBar"]) {
        if (activatedtut == YES) {
            correctBar = NO;
            [self activateTutorial];
            NSLog(@"incorrectBar 1");
        } else {
            [character removeFromParent];
            [self gameOverActions];
            if (soundOn == YES) {
                [self runAction:incorrectSound];
            }
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar2.frame)) & [bar2.name isEqualToString:@"correctBar"]){
        if (activatedtut == YES) {
            correctBar = YES;
            [self activateTutorial];
            NSLog(@"correctBar 2");
        } else {
            [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
            [character removeFromParent];
            if (soundOn == YES) {
                [self runAction:correctSound];
            }
            SKAction *seq = [SKAction sequence:@[[SKAction moveToY:self.frame.size.height/1.4 *2 duration:spawntime],[SKAction removeFromParent]]];
            [bar1 runAction:seq];
            [bar2 runAction:seq];
            [bar3 runAction:seq];
            [bar4 runAction:seq];
            [bar5 runAction:seq];
            [self SpawnFood];
            if (scoreValue == 31 & storyModeOn == YES) {
                victory = YES;
                level++;
                [character removeFromParent];
                [self gameOverActions];
            }
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar2.frame)) & [bar2.name isEqualToString:@"incorrectBar"]) {
        if (activatedtut == YES) {
            correctBar = NO;
            [self activateTutorial];
            NSLog(@"incorrectBar 2");
        } else {
            [character removeFromParent];
            [self gameOverActions];
            if (soundOn == YES) {
                [self runAction:incorrectSound];
            }
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar3.frame)) & [bar3.name isEqualToString:@"correctBar"]){
        [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
        [character removeFromParent];
        if (soundOn == YES) {
            [self runAction:correctSound];
        }
        SKAction *seq = [SKAction sequence:@[[SKAction moveToY:self.frame.size.height/1.4 *2 duration:spawntime],[SKAction removeFromParent]]];
        [bar1 runAction:seq];
        [bar2 runAction:seq];
        [bar3 runAction:seq];
        [bar4 runAction:seq];
        [bar5 runAction:seq];
        [self SpawnFood];
        if (scoreValue == 31 & storyModeOn == YES) {
            victory = YES;
            level++;
            [character removeFromParent];
            [self gameOverActions];
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar3.frame)) & [bar3.name isEqualToString:@"incorrectBar"]) {
        [character removeFromParent];
        [self gameOverActions];
        if (soundOn == YES) {
            [self runAction:incorrectSound];
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar4.frame)) & [bar4.name isEqualToString:@"correctBar"]){
        [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
        [character removeFromParent];
        if (soundOn == YES) {
            [self runAction:correctSound];
        }
        SKAction *seq = [SKAction sequence:@[[SKAction moveToY:self.frame.size.height/1.4 *2 duration:spawntime],[SKAction removeFromParent]]];
        [bar1 runAction:seq];
        [bar2 runAction:seq];
        [bar3 runAction:seq];
        [bar4 runAction:seq];
        [bar5 runAction:seq];
        [self SpawnFood];
        if (scoreValue == 31 & storyModeOn == YES) {
            victory = YES;
            level++;
            [character removeFromParent];
            [self gameOverActions];
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar4.frame)) & [bar4.name isEqualToString:@"incorrectBar"]) {
        [character removeFromParent];
        [self gameOverActions];
        if (soundOn == YES) {
            [self runAction:incorrectSound];
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar5.frame)) & [bar5.name isEqualToString:@"correctBar"]){
        [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
        [character removeFromParent];
        if (soundOn == YES) {
            [self runAction:correctSound];
        }
        SKAction *seq = [SKAction sequence:@[[SKAction moveToY:self.frame.size.height/1.4 *2 duration:spawntime],[SKAction removeFromParent]]];
        [bar1 runAction:seq];
        [bar2 runAction:seq];
        [bar3 runAction:seq];
        [bar4 runAction:seq];
        [bar5 runAction:seq];
        [self SpawnFood];
        if (scoreValue == 31 & storyModeOn == YES) {
            victory = YES;
            level++;
            [character removeFromParent];
            [self gameOverActions];
        }
    }
    if ((CGRectIntersectsRect(character.frame, bar5.frame)) & [bar5.name isEqualToString:@"incorrectBar"]) {
        [character removeFromParent];
        [self gameOverActions];
        if (soundOn == YES) {
            [self runAction:incorrectSound];
        }
    }
    if ((character.position.y < -self.frame.size.height/2 - character.frame.size.height)&(activatedtut == NO)) {
        
        [character removeFromParent];
        character.position = CGPointZero;
        if (soundOn == YES) {
            [self runAction:incorrectSound];
        }
        [self gameOverActions];
    } else if ((character.position.y < -self.frame.size.height/2)&(activatedtut == YES))
    {
        correctBar = NO;
        [self activateTutorial];
        NSLog(@"offscreen bottom");
    }
    if ((character.position.x < -self.frame.size.width/2)&(activatedtut == NO)) {
        
        [character removeFromParent];
        character.position = CGPointZero;
        if (soundOn == YES) {
            [self runAction:incorrectSound];
        }
        [self gameOverActions];
    } else if ((character.position.x < -self.frame.size.width/2)&(activatedtut == YES))
    {
        correctBar = NO;
        [self activateTutorial];
        NSLog(@"offscreen left");
    }
    if ((character.position.x > self.frame.size.width/2)&(activatedtut == NO)) {
        
        [character removeFromParent];
        character.position = CGPointZero;
        if (soundOn == YES) {
            [self runAction:incorrectSound];
        }
        [self gameOverActions];
    } else if ((character.position.x > self.frame.size.width/2)&(activatedtut == YES))
    {
        correctBar = NO;
        [self activateTutorial];
        NSLog(@"offscreen right");
    }
}
-(void)handleNodesAtLocation:(CGPoint)location {
    NSArray* nodes = [[self gameLayer] nodesAtPoint:location];
    for(SKNode * node in nodes)
    {
        if ([[node name] isEqualToString:@"PlayButton"])
        {
            storyModeOn = YES;
            quickPlayOn = NO;
            
            [score removeFromParent];
            scoreValue = 0;
            extraLifeInt = 0;
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
            [score runAction:[SKAction moveTo:CGPointMake(0, self.frame.size.height/2.5) duration:0]];
            [[self.gameLayer childNodeWithName:@"ScoreBoard"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"highScoreLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"MainMenu"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"RemoveAdsButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"QuickPlayButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"TutorialButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"SoundButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
            [node removeFromParent];
            [rewardedTimer invalidate];
            if (activatedtut==YES&clicked==YES) {
                [self activateTutorial];
                self.physicsWorld.gravity = CGVectorMake(0, -3);
            } else {
                [self addChild:score];
                self.physicsWorld.gravity = CGVectorMake(0, -6);
                [self characters];
                [self SpawnFood];
            }
        }
        if ([[node name] isEqualToString:@"ContinueButton"])
        {
            
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            victory = NO;
            scoreValue = 0;
            extraLifeInt = 0;
            [score removeFromParent];
            [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
            [score runAction:[SKAction moveTo:CGPointMake(0, self.frame.size.height/2.5) duration:0]];
            [[self.gameLayer childNodeWithName:@"ScoreBoard"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"highScoreLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"MainMenu"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"RemoveAdsButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"QuickPlayButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"TutorialButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"SoundButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
            [node removeFromParent];
            
            if (level == 11) {
                activatedtut = YES;
                clicked = YES;
                [self activateTutorial];
                self.physicsWorld.gravity = CGVectorMake(0, -3);
            } else if (level == 21) {
                activatedtut = YES;
                clicked = YES;
                [self activateTutorial];
                self.physicsWorld.gravity = CGVectorMake(0, -3);
            } else {
                [self addChild:score];
                self.physicsWorld.gravity = CGVectorMake(0, -6);
                [self characters];
                [self SpawnFood];
            }
        }
        if ([[node name] isEqualToString:@"QuickPlayButton"])
        {
            
            quickPlayOn = YES;
            storyModeOn = NO;
            
            [score removeFromParent];
            scoreValue = 0;
            extraLifeInt = 0;
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
            [score runAction:[SKAction moveTo:CGPointMake(0, self.frame.size.height/2.5) duration:0]];
            [[self.gameLayer childNodeWithName:@"ScoreBoard"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"highScoreLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"MainMenu"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"RemoveAdsButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"PlayButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"TutorialButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"SoundButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
            [node removeFromParent];
            [rewardedTimer invalidate];
            if (activatedtut==YES) {
                [self activateTutorial];
                self.physicsWorld.gravity = CGVectorMake(0, -3);
            } else {
                [self addChild:score];
                self.physicsWorld.gravity = CGVectorMake(0, -7);
                [self characters];
                [self SpawnFood];
                
            }
        }
        if ([[node name] isEqualToString:@"RetryButton"])
        {
            
            [score removeFromParent];
            scoreValue = 0;
            extraLifeInt = 0;
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            
            [score setText:[NSString stringWithFormat:@"%i", scoreValue++]];
            [score runAction:[SKAction moveTo:CGPointMake(0, self.frame.size.height/2.5) duration:0]];
            [[self.gameLayer childNodeWithName:@"ScoreBoard"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"highScoreLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"MainMenu"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"RemoveAdsButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"PlayButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"TutorialButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"SoundButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Check2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
            [node removeFromParent];
            [rewardedTimer invalidate];
            [self addChild:score];
            self.physicsWorld.gravity = CGVectorMake(0, -6);
            [self characters];
            [self SpawnFood];
            
            
        }
        if ([[node name] isEqualToString:@"background"])
        {
            if (activatedtut == YES & clicked == NO) {
                if (endTutorial == NO) {
                    m++;
                }
                [self activateTutorial];
                clicked = YES;
            }
        }
        if ([[node name] isEqualToString:@"SoundButton"])
        {
            SKSpriteNode *check = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Check"]];
            check.position = CGPointMake(self.frame.size.width/2.3, self.frame.size.height/2.2);
            check.zPosition = 10;
            check.name = @"Check2";
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            BOOL justclicked = NO;
            if (soundOn == YES) {
                [[self.gameLayer childNodeWithName:@"Check2"] removeFromParent];
                soundOn = NO;
                justclicked = YES;
                [audioPlayer1 stop];
            }
            if (soundOn == NO & justclicked == NO) {
                [self.gameLayer addChild:check];
                soundOn = YES;
                justclicked = NO;
                [audioPlayer1 play];
            }
            NSUserDefaults* soundDefaults = [NSUserDefaults standardUserDefaults];
            [soundDefaults setBool:soundOn forKey:@"soundOn"];
            [soundDefaults synchronize];
        }
        if ([[node name] isEqualToString:@"TutorialButton"])
        {
            SKSpriteNode *check = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Check"]];
            check.position = CGPointMake(-self.frame.size.width/2.7, self.frame.size.height/2.2);
            check.zPosition = 10;
            check.name = @"Check1";
            
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            clicked = NO;
            if (activatedtut == YES) {
                [[self.gameLayer childNodeWithName:@"Check1"] removeFromParent];
                activatedtut = NO;
                clicked = YES;
            }
            if (activatedtut == NO & clicked == NO) {
                [self.gameLayer addChild:check];
                activatedtut = YES;
                clicked = YES;
            }
            NSUserDefaults* tutorialDefaults = [NSUserDefaults standardUserDefaults];
            [tutorialDefaults setBool:activatedtut forKey:@"activatedtut"];
            [tutorialDefaults synchronize];
        }
        if ([[node name] isEqualToString:@"HomeButton"])
        {
            [score removeFromParent];
            scoreValue = 0;
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            [score removeFromParent];
            [[self.gameLayer childNodeWithName:@"ScoreBoard"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"highScoreLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"MainMenu"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"RemoveAdsButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"QuickPlayButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"TutorialButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"SoundButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"RetryButton"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
            [node removeFromParent];
            [rewardedTimer invalidate];
            [self homeSprites];
        }
        if ([[node name] isEqualToString:@"BlackScreen"])
        {
            if (clicked == NO) {
                //scoreValue = 0;
                if (soundOn == YES) {
                    [self runAction:clickSound];
                }
                [[self childNodeWithName:@"stayTunedLabel"] removeFromParent];
                [[self childNodeWithName:@"continueLabel"] removeFromParent];
                [node removeFromParent];
                level = 50;
                [self gameOverActions];
            }
        }
        if ([[node name] isEqualToString:@"Arrow1"])
        {
            arrowClicked = YES;
            [node removeFromParent];
            [scoreBoard removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow2"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
            level--;
            [self gameOverActions];
        }
        if ([[node name] isEqualToString:@"Arrow2"])
        {
            arrowClicked = YES;
            [node removeFromParent];
            [scoreBoard removeFromParent];
            [[self.gameLayer childNodeWithName:@"Arrow1"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"levelLabel"] removeFromParent];
            [[self.gameLayer childNodeWithName:@"VideoButton"] removeFromParent];
            level++;
            [self gameOverActions];
        }
        if ([[node name] isEqualToString:@"VideoButton"])
        {
            extraLifeInt++;
            showRewarded = YES;
            [node removeFromParent];
            
            rewardedTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(resumeGame) userInfo:nil repeats:TRUE];
            [rewardedTimer fire];
            //[self resumeGame];
        }
        if ([[node name] isEqualToString:@"RemoveAdsButton"])
        {
            if (soundOn == YES) {
                [self runAction:clickSound];
            }
            [self buySupportCreator];
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches)
    {
        CGPoint location = [touch locationInNode:[self gameLayer]];
        
        [self handleNodesAtLocation:location];
        
    }
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Payments

-(void)buySupportCreator {
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kAddSupportCreatorProductIdentifier]];
        checkingPurchase = YES;
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments, enable in app purchases in settings");
        
    }
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if (count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}
- (void)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                if (checkingPurchase == YES) {
                    adsEnabled = NO;
                    checkingPurchase = NO;
                    NSUserDefaults *adsDefault = [NSUserDefaults standardUserDefaults];
                    adsEnabled = [adsDefault boolForKey:@"adsEnabled"];
                    [interstitalTimer invalidate];
                    
                    //[self performSelector:@selector(increment9000) withObject:self afterDelay:0.5];
                }
                //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //adsEnabled = YES;
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    checkingPurchase = NO;
                    adsEnabled = YES;
                    NSLog(@"%@", transaction.error);
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            default:
                break;
        }
    }
}
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product
{
    
    return YES;
}

@end
