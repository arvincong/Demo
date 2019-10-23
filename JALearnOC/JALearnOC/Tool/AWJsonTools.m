//
//  AWJsonTools.m
//  NewEasyLoan
//
//  Created by arvin wang on 2018/11/23.
//  Copyright © 2018 arvin wang. All rights reserved.
//

#import "AWJsonTools.h"
#import <objc/runtime.h>

@implementation AWJsonTools

+ (NSString *)convertToString:(id)objc
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objc options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (NSDictionary *)stringConverToDict:(id)string
{
    if ([string isKindOfClass:[NSDictionary class]]) {
        return string;
    }
    NSError *parseError = nil;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
    return dict;
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    
    for(int i = 0;i < propsCount; i++)
        
    {
        
        objc_property_t prop = props[i];
        
        
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        
        id value = [obj valueForKey:propName];//kvc读值
        
        if(value == nil)
            
        {
            
            value = [NSNull null];
            
        }
        
        else
            
        {
            
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
            
        }
        
        [dic setObject:value forKey:propName];
        
    }
    
    return dic;
}


+ (id)getObjectInternal:(id)obj

{
    
    if([obj isKindOfClass:[NSString class]]
       
       || [obj isKindOfClass:[NSNumber class]]
       
       || [obj isKindOfClass:[NSNull class]])
        
    {
        
        return obj;
        
    }
    
    
    
    if([obj isKindOfClass:[NSArray class]])
        
    {
        
        NSArray *objarr = obj;
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0;i < objarr.count; i++)
            
        {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
            
        }
        
        return arr;
        
    }
    
    
    
    if([obj isKindOfClass:[NSDictionary class]])
        
    {
        
        NSDictionary *objdic = obj;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys)
            
        {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
            
        }
        
        return dic;
        
    }
    
    return [self getObjectData:obj];
    
}

@end
