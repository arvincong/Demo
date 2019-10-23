//
//  AWModelCoder.h
//  JALearnOC
//
//  Created by jason on 22/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWModelCoder : NSObject

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

@end

NS_ASSUME_NONNULL_END
