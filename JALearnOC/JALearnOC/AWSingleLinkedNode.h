//
//  AWSingleLinkedNode.h
//  JALearnOC
//
//  Created by jason on 7/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWSingleLinkedNode : NSObject

@property(nonatomic,strong) NSString *key;
@property(nonatomic,strong) NSString *value;
@property(nonatomic,strong) AWSingleLinkedNode *next;

- (instancetype)initWithKey:(NSString *)key
                      value:(NSString *)value;

+ (instancetype)nodeWithKey:(NSString *)key
                      value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
