//
//  Bars.m
//  Food Fall
//
//  Created by Willie on 2/24/17.
//  Copyright © 2017 Fluxfire. All rights reserved.
//

#import "Bars.h"
#import "GameScene.h"

@implementation Bars

+(id)initBarType:(SKTexture *)barType {
    
    Bars *bar = [Bars spriteNodeWithTexture:barType];
    bar.zPosition = 1;
    bar.position = bar.barSpawnPositions;
    bar.yScale = bar.barScale;
    
    return bar;
}

-(CGPoint)barSpawnPositions // Based on bar type and game lvl

{
    
    
    CGPoint p;
    
    
    int arrData[] = {8,9,10,11,20,27};
    
    arrayNum = i[arrData];
    
    //NSLog(@"[%d]",i[arrData]);
    
    i++;
    
    NSValue *value = [barsArray objectAtIndex:arrayNum];
    
    
    p = [value CGPointValue];
    
    
    
    return p;
    
}
-(SKAction*)barActions // Based on bar type abd game lvl
{
    SKAction *action;
    
    return action;
}
-(NSString *)barType // Bar Color Chooser
{
    
    return barString;
}
-(NSString *)barNames // Based on food type and game lvl
{
    
    return barName;
}
-(SKAction*)barSpawnActions // Animations for each new Bar set
{
    SKAction *spawnAction;
    
    return spawnAction;
}
-(float)barScale
{
    
    //barScale = 1;
    
    if (arrayNum <= 1) {
        barScale = 1.0;
    }
    if ((arrayNum >= 2) & (arrayNum <= 7)) {
        barScale = 0.75;
    }
    if ((arrayNum >= 8) & (arrayNum <= 13)) {
        barScale = 0.5;
    }
    if ((arrayNum >= 14) & (arrayNum <= 28)) {
        barScale = 0.25;
    }
    
    return barScale;
}

@end
