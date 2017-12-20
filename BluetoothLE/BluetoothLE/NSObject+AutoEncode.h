//
//  NSObject+AutoEncode.h
//  HLUIBaseKit
//
//  Created by xyp on 2017/11/7.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoEncode)<NSCoding>

-(instancetype)initWithCoder:(NSCoder *)aDecoder;

-(void)encodeWithCoder:(NSCoder *)aCoder;

@end

