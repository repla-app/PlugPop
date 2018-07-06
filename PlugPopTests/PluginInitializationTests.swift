//
//  PluginInitializationTests.swift
//  Web Console
//
//  Created by Roben Kleene on 10/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

@testable import PlugPop
import PlugPopTestHarness
import XCTest

class PluginInitializationTests: PluginsManagerTestCase {
    func testHelloWorldPlugin() {
        guard let helloWorldPlugin = pluginsManager.plugin(withName: testPluginNameHelloWorld) else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(helloWorldPlugin.pluginType, PluginType.other)
        XCTAssertEqual(helloWorldPlugin.identifier, "9DF1F4D6-16BA-4D18-88D2-155CF262035F")
        XCTAssertEqual(helloWorldPlugin.name, "HelloWorld")
        XCTAssertEqual(helloWorldPlugin.command, "hello_world.rb")
        XCTAssertEqual(helloWorldPlugin.hidden, false)
        XCTAssertEqual(helloWorldPlugin.editable, false)
        XCTAssertNil(helloWorldPlugin.debugModeEnabled)
    }

    func testLogPlugin() {
        guard let logPlugin = pluginsManager.plugin(withName: testPluginNameLog) else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(logPlugin.pluginType, PluginType.other)
        XCTAssertEqual(logPlugin.identifier, "7A95638E-798D-437C-9404-08E7DC68655B")
        XCTAssertEqual(logPlugin.name, "TestLog")
        XCTAssertEqual(logPlugin.command, "test_log.rb")
        XCTAssertEqual(logPlugin.hidden, false)
        XCTAssertEqual(logPlugin.editable, false)
        XCTAssertEqual(logPlugin.debugModeEnabled, true)
    }

    func testPrintPlugin() {
        guard let logPlugin = pluginsManager.plugin(withName: testPluginNamePrint) else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(logPlugin.debugModeEnabled, false)
    }
}
