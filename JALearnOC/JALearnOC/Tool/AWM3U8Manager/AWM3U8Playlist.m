//
//  AWM3U8Playlist.m
//  JALearnOC
//
//  Created by jason on 25/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWM3U8Playlist.h"

@implementation AWM3U8Playlist

- (void)initWithSegmentArray:(NSArray *)array {
    self.segmentArray = array;
    self.length = array.count;
}

@end
