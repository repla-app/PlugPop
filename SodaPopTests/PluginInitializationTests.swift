//
//  PluginInitializationTests.swift
//  Web Console
//
//  Created by Roben Kleene on 10/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

@testable import SodaPop
import SodaPopTestHarness
import XCTest

class PluginManagerInitializationTests: PluginsManagerTestCase {
    func testHelloWorldPlugin() {
        guard let helloWorldPlugin = pluginsManager.plugin(withName: testPluginNameHelloWorld) else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(helloWorldPlugin.kind, PluginKind.builtIn)
        XCTAssertEqual(helloWorldPlugin.identifier, "9DF1F4D6-16BA-4D18-88D2-155CF262035F")
        XCTAssertEqual(helloWorldPlugin.name, "HelloWorld")
        XCTAssertEqual(helloWorldPlugin.command, "hello_world.rb")
        XCTAssertEqual(helloWorldPlugin.hidden, false)
        XCTAssertEqual(helloWorldPlugin.editable, false)
        XCTAssertEqual(helloWorldPlugin.promptInterrupt, false)
        XCTAssertEqual(helloWorldPlugin.usesEnvironment, true)
    }

    func testLogPlugin() {
        guard let logPlugin = pluginsManager.plugin(withName: testPluginNameLog) else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(logPlugin.kind, PluginKind.builtIn)
        XCTAssertEqual(logPlugin.identifier, "7A95638E-798D-437C-9404-08E7DC68655B")
        XCTAssertEqual(logPlugin.name, "TestLog")
        XCTAssertEqual(logPlugin.command, "run.sh")
        XCTAssertEqual(logPlugin.hidden, false)
        XCTAssertEqual(logPlugin.editable, false)
        XCTAssertEqual(logPlugin.promptInterrupt, false)
        XCTAssertEqual(logPlugin.usesEnvironment, false)
    }

    func testPromptInterruptPlugin() {
        guard let plugin = pluginsManager.plugin(withName: testPluginNamePromptInterrupt) else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(plugin.promptInterrupt, true)
    }

    func testOptionsPlugins() {
        guard let optionsDisabledPlugin = pluginsManager.plugin(withName: testPluginOptionsDisabledName) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(optionsDisabledPlugin.debugModeEnabled, false)
        XCTAssertEqual(optionsDisabledPlugin.autoShowLog, false)
        XCTAssertEqual(optionsDisabledPlugin.transparentBackground, false)

        guard let optionsNilPlugin = pluginsManager.plugin(withName: testPluginOptionsNilName) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertNil(optionsNilPlugin.debugModeEnabled)
        XCTAssertNil(optionsNilPlugin.autoShowLog)
        XCTAssertFalse(optionsNilPlugin.transparentBackground)

        guard let optionsEnabledPlugin = pluginsManager.plugin(withName: testPluginOptionsEnabledName) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(optionsEnabledPlugin.debugModeEnabled, true)
        XCTAssertEqual(optionsEnabledPlugin.autoShowLog, true)
        XCTAssertEqual(optionsEnabledPlugin.transparentBackground, true)
    }
}

class PluginInitializationTests: XCTestCase {
    func testLoadPluginInfo() {
        var pluginInfo: PluginInfo!
        do {
            pluginInfo = try PluginInfo.load(from: testPluginJSONURLJSON)
        } catch {
            XCTFail()
        }
        XCTAssertNotNil(pluginInfo)
    }
}
