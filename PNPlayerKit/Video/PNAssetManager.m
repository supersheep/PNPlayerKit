//
//  PNAssetManager.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "PNAssetManager.h"

@interface PNAssetManager()
@property (nonatomic, strong) NSMutableDictionary *mapping;
@end

@implementation PNAssetManager
+ (instancetype)shared{
    static PNAssetManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _mapping = [NSMutableDictionary new];
    }
    return self;
}

- (AVURLAsset *)assetWithURL:(NSURL *)url{
    if (url == nil) {
        return nil;
    }
    NSString *key = url.absoluteString;
    if (![_mapping objectForKey:key]) {
        [_mapping setObject:[AVURLAsset assetWithURL:url] forKey:key];
    }
    return [_mapping objectForKey:key];
}
@end
