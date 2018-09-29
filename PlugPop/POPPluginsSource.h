//
//  POPPluginsSource.h
//  PlugPop
//
//  Created by Roben Kleene on 12/21/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Plugin;

NS_ASSUME_NONNULL_BEGIN
@protocol POPPluginsSource <NSObject>
- (void)addPlugin:(Plugin *)plugin;
- (void)removePlugin:(Plugin *)plugin;
- (nullable Plugin *)pluginWithName:(NSString *)name;
- (nullable Plugin *)pluginWithIdentifier:(NSString *)identifier;
#pragma mark Required Key-Value Coding To-Many Relationship Compliance
- (NSArray<Plugin *> *)plugins;
- (void)insertObject:(Plugin *)plugin inPluginsAtIndex:(NSUInteger)index;
- (void)insertPlugins:(NSArray *)pluginsArray atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectFromPluginsAtIndex:(NSUInteger)index;
- (void)removePluginsAtIndexes:(NSIndexSet *)indexes;
@end
NS_ASSUME_NONNULL_END
