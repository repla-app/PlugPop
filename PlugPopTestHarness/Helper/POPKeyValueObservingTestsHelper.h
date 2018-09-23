//
//  POPKeyValueObservingTestsHelper.h
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 3/17/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface POPKeyValueObservingTestsHelper : NSObject
+ (void)observeObject:(id)object
           forKeyPath:(NSString *)keyPath
              options:(NSKeyValueObservingOptions)options
      completionBlock:(void (^)(NSDictionary *change))completionBlock;
@end
NS_ASSUME_NONNULL_END
