//
//  NSString+AWTool.m
//  JALearnOC
//
//  Created by jason on 5/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSString+AWTool.h"

@implementation NSString (AWTool)

-(BOOL)isJudgeChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(NSInteger)getNumberMethod
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    int number;
    [scanner scanInt:&number];
    
    return number;
}
@end
