//
//  POPPluginsController+UniquePluginName.h
//  PlugPop
//
//  Created by Roben Kleene on 5/6/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

#import "POPPluginsController.h"

#define kDuplicatePluginsWithCounterMax 99

@class Plugin;

NS_ASSUME_NONNULL_BEGIN
@interface POPPluginsController (UniquePluginName)
- (NSString *)uniquePluginNameFromName:(NSString *)name;
- (NSString *)uniquePluginNameFromName:(NSString *)name forPlugin:(nullable Plugin *)plugin;
- (BOOL)isUniqueName:(NSString *)name forPlugin:(Plugin *)plugin;
@end
NS_ASSUME_NONNULL_END