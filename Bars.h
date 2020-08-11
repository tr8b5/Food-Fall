//
//  Bars.h
//  Food Fall
//
//  Created by Willie on 2/24/17.
//  Copyright © 2017 Fluxfire. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

SKSpriteNode *bar1;
SKSpriteNode *bar2;
SKSpriteNode *bar3;
SKSpriteNode *bar4;
SKSpriteNode *bar5;
SKSpriteNode *bar6;
SKSpriteNode *bar7;
NSString *barName;
NSString *barString;
float barScale;
int arrayNum;
@interface Bars : SKSpriteNode
{
    
    
}


+(id)initBarType:(SKTexture *)barType;
-(NSString *)barType;
-(CGPoint)barSpawnPositions;
-(float)barScale;

@property (nonatomic) BOOL longestBar;
@property (nonatomic) BOOL longBar;
@property (nonatomic) BOOL shortBar;
@property (nonatomic) BOOL shortestBar;
@property (nonatomic) BOOL correctBar;

@end
