//
//  PluginManagerTestCase_new.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/18/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import SodaPop
import XCTest

open class PluginsManagerTestCase: PluginsManagerDependenciesTestCase, PluginsManagerOwnerType {
    private var privatePluginsManager: PluginsManager!
    public var pluginsManager: PluginsManager {
        return privatePluginsManager
    }

    override open func setUp() {
        super.setUp()
        privatePluginsManager = makePluginsManager()
    }

    override open func tearDown() {
        privatePluginsManager = nil
        // Making a `pluginsManager` will implicitly create the
        // `userPluginsURL`. So that needs to be cleaned up here.
        do {
            try removeTemporaryItem(at: temporaryApplicationSupportDirectoryURL)
        } catch {
            XCTFail()
        }
        super.tearDown()
    }
}
