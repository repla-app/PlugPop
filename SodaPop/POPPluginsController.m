//
//  POPPluginsController.m
//  SodaPop
//
//  Created by Roben Kleene on 5/7/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

#import "POPPluginsController.h"
#import <SodaPop/SodaPop-Swift.h>

@interface POPPluginsController ()
@property (nonatomic, strong) MultiCollectionController *multiCollectionController;
@end

@implementation POPPluginsController

- (instancetype)initWithPlugins:(NSArray *)plugins {
    self = [super init];
    if (self) {
        _multiCollectionController = [[MultiCollectionController alloc] initWithObjects:plugins key:kPluginNameKey];
    }
    return self;
}

- (void)addPlugin:(BasePlugin *)plugin {
    [self insertObject:plugin inPluginsAtIndex:0];
}

- (void)removePlugin:(BasePlugin *)plugin {
    NSUInteger index = [self indexOfObject:plugin];
    if (index != NSNotFound) {
        [self removeObjectFromPluginsAtIndex:index];
    }
}

- (BasePlugin *)pluginWithName:(NSString *)name {
    id object = [self.multiCollectionController objectForKey:name];
    if ([object isKindOfClass:[BasePlugin class]]) {
        return object;
    }
    return nil;
}

- (BasePlugin *)pluginWithIdentifier:(NSString *)identifier {
    // TODO: This should obviously be optimized by creating a key value
    // collection to retrieve `Plugin` by key.
    NSArray *plugins = self.plugins;
    for (BasePlugin *plugin in plugins) {
        if ([plugin.identifier isEqualToString:identifier]) {
            return plugin;
        }
    }
    return nil;
}

- (NSUInteger)indexOfObject:(BasePlugin *)plugin {
    return [self.multiCollectionController indexOfObject:plugin];
}

#pragma mark Required Key-Value Coding To-Many Relationship Compliance

- (NSArray *)plugins {
    return [self.multiCollectionController objects];
}

- (void)insertObject:(BasePlugin *)plugin inPluginsAtIndex:(NSUInteger)index {
    [self.multiCollectionController insertObject:plugin inObjectsAtIndex:index];
}

- (void)insertPlugins:(NSArray *)pluginsArray atIndexes:(NSIndexSet *)indexes {
    [self.multiCollectionController insertObjects:pluginsArray atIndexes:indexes];
}

- (void)removeObjectFromPluginsAtIndex:(NSUInteger)index {
    [self.multiCollectionController removeObjectFromObjectsAtIndex:index];
}

- (void)removePluginsAtIndexes:(NSIndexSet *)indexes {
    [self.multiCollectionController removeObjectsAtIndexes:indexes];
}

@end
