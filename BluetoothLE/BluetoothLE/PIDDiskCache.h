//
//  PIDDiskCache.h
//  HuLu
//
//  Created by xyp on 2017/10/10.
//  Copyright © 2017年 MeiTuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIDDiskCache : NSObject

+ (PIDDiskCache *)shared;

/**
 * Store an item into disk cache at the given key.
 */
- (void)storeItem:(id)item forKey:(NSString *)key;

/**
 Get an item from disk with key and class

 @param key <#key description#>
 @return <#return value description#>
 */
- (id)itemForKey:(NSString *)key;

/**
 *  Check if item exists in disk cache already
 */
- (BOOL)itemExistsWithKey:(NSString *)key;

/**
 * Remove the item from disk cache synchronously
 *
 * @param key The unique item cache key
 */
- (void)removeItemForKey:(NSString *)key;

/**
 * Clear all disk cached items
 * @see clearDiskOnCompletion:
 */
- (void)clearDisk;

/**
 * Get the size used by the disk cache
 */
- (NSUInteger)getSize;

@end
