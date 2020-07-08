//
//  PluginsManagerDependenciesTestCase.swift
//  SodaPopTests
//
//  Created by Roben Kleene on 9/24/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

import Foundation
import PlainBagel
import SodaPop
import XCTest

open class TemporaryPluginsManagerDependenciesTestCase: TemporaryPluginsTestCase, PluginsManagerFactoryType {
    public var pluginsManagerType = PluginsManager.self
    public var pluginsDirectoryPaths: [String] {
        return [userPluginsPath, builtInPluginsPath]
    }

    public var builtInPluginsPath: String {
        return tempPluginsDirectoryPath
    }

    public var userPluginsPath: String {
        return temporaryUserPluginsDirectoryPath
    }

    public lazy var defaultsSuiteName = {
        testMockUserDefaultsSuiteName
    }()

    public lazy var defaults: DefaultsType = {
        UserDefaults(suiteName: defaultsSuiteName)!
    }()

    override open func setUp() {
        super.setUp()
        guard let userDefaults = defaults as? UserDefaults else {
            XCTFail()
            return
        }
        userDefaults.removePersistentDomain(forName: defaultsSuiteName)
        XCTAssertNil(userDefaults.persistentDomain(forName: defaultsSuiteName))
    }

    override open func tearDown() {
        super.tearDown()
        guard let userDefaults = defaults as? UserDefaults else {
            XCTFail()
            return
        }
        userDefaults.removePersistentDomain(forName: defaultsSuiteName)
        XCTAssertNil(userDefaults.persistentDomain(forName: testMockUserDefaultsSuiteName))
    }
}
