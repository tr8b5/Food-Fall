//
//  Food.m
//  Food Fall
//
//  Created by Willie on 2/2/17.
//  Copyright © 2017 Fluxfire. All rights reserved.
//

#import "Food.h"

@implementation Food

+(id)initFoodType:(SKTexture *)foodType {
    
    Food *food = [Food spriteNodeWithTexture:foodType];
    food.position = food.foodSpawnPosition;
    food.zPosition = 1;
    food.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:food.size];
    
    
    return food;
}

-(CGPoint)foodSpawnPosition
{
    return CGPointMake(0, 720);
}


@end
