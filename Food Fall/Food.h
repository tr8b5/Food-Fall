//
//  Food.h
//  Food Fall
//
//  Created by Willie on 2/2/17.
//  Copyright © 2017 Fluxfire. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface Food : SKSpriteNode {
    
}
+(id)initFoodType:(SKTexture *)foodType;
-(CGPoint)foodSpawnPosition;
@property (nonatomic) BOOL canBreakObjects;
@end
