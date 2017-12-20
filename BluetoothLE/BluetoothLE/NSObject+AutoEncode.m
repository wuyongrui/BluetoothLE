//
//  NSObject+AutoEncode.m
//  HLUIBaseKit
//
//  Created by xyp on 2017/11/7.
//

#import "NSObject+AutoEncode.h"
#import <objc/runtime.h>

@implementation NSObject (AutoEncode)

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //根据自身属性和值进行序列化
    unsigned int ivarCount = 0;
    Ivar *vars = class_copyIvarList([self class], &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(vars[i])];
        id value = [self valueForKey:ivarName];
        [aCoder encodeObject:value forKey:ivarName];
    }
    free(vars);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    //根据自身属性和值进行反序列化
    self = [self init];
    if (self) {
        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &ivarCount);
        for (int i = 0; i < ivarCount; i++) {
            NSString *varName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
            id value= [aDecoder decodeObjectForKey:varName];
            if (value) {
                [self setValue:value forKey:varName];
            }
        }
        free(ivars);
    }
    return self;
}

@end

