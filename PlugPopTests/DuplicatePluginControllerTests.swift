//
//  DuplicatePluginControllerTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 9/27/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa
@testable import PlugPop
import PlugPopTestHarness
import XCTest

class DuplicatePluginControllerTests: PluginsManagerTestCase {
    var duplicatePluginController: DuplicatePluginController!
    lazy var plugin: Plugin = {
        self.pluginsManager.defaultNewPlugin!
    }()

    override func setUp() {
        super.setUp()
        duplicatePluginController = pluginsManager.pluginsDataController.duplicatePluginController
        plugin.editable = false
    }

    override func tearDown() {
        duplicatePluginController = nil
        super.tearDown()
    }

    func testDuplicatePlugin() {
        // Test that the plugin starts not editable
        XCTAssertFalse(plugin.editable, "The plugin should not be editable")

        var pluginInfoDictionaryURL = Plugin.urlForInfoDictionary(for: plugin)
        var pluginInfoDictionaryContents: String!
        do {
            pluginInfoDictionaryContents = try String(contentsOf: pluginInfoDictionaryURL,
                                                      encoding: String.Encoding.utf8)
        } catch {
            XCTAssertTrue(false, "Getting the info dictionary contents should succeed")
        }

        var pluginInfoDictionaryContentsAsNSString: NSString = pluginInfoDictionaryContents as NSString
        var range = pluginInfoDictionaryContentsAsNSString.range(of: Plugin.InfoDictionaryKeys.editable)
        XCTAssertFalse(range.location == NSNotFound, "The string should have been found")

        // Duplicate the plugin
        var duplicatePlugin: Plugin!
        let duplicateExpectation = expectation(description: "Duplicate")
        duplicatePluginController.duplicate(plugin, to: temporaryUserPluginsDirectoryURL) { (plugin, error) -> Void in
            XCTAssertNil(error, "The error should be nil")
            XCTAssertNotNil(plugin, "The plugin should not be nil")
            duplicatePlugin = plugin
            duplicateExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Test the plugin's directory exists
        let duplicatePluginURL = duplicatePlugin.bundle.bundleURL
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: duplicatePluginURL.path,
                                                    isDirectory: &isDir)
        XCTAssertTrue(exists, "The item should exist")
        XCTAssertTrue(isDir.boolValue, "The item should be a directory")

        // Test that the new plugin is editable
        XCTAssertTrue(duplicatePlugin.editable, "The duplicated plugin should be editable")
        pluginInfoDictionaryURL = Plugin.urlForInfoDictionary(forPluginAt: duplicatePlugin.bundle.bundleURL)

        do {
            pluginInfoDictionaryContents = try String(contentsOf: pluginInfoDictionaryURL,
                                                      encoding: String.Encoding.utf8)
        } catch {
            XCTAssertTrue(false, "Getting the info dictionary contents should succeed")
        }

        pluginInfoDictionaryContentsAsNSString = pluginInfoDictionaryContents as NSString
        range = pluginInfoDictionaryContentsAsNSString.range(of: Plugin.InfoDictionaryKeys.editable)
        XCTAssertTrue(range.location == NSNotFound, "The string should not have been found")

        // Test the plugins properties are accurate
        XCTAssertNotEqual(plugin.bundle.bundleURL, duplicatePlugin.bundle.bundleURL, "The URLs should not be equal")
        XCTAssertNotEqual(plugin.identifier, duplicatePlugin.identifier, "The identifiers should not be equal")
        XCTAssertNotEqual(plugin.name, duplicatePlugin.name, "The names should not be equal")
        XCTAssertEqual(plugin.hidden, duplicatePlugin.hidden, "The hidden should equal the plugin's hidden")
        let longName: String = duplicatePlugin.name
        XCTAssertTrue(longName.hasPrefix(plugin.name))
        XCTAssertNotEqual(plugin.commandPath!, duplicatePlugin.commandPath!, "The command paths should not be equal")
        XCTAssertEqual(plugin.command!, duplicatePlugin.command!, "The commands should be equal")
        let duplicatePluginFolderName = duplicatePlugin.bundle.bundlePath.lastPathComponent
        XCTAssertEqual(DuplicatePluginController.pluginFilename(fromName: duplicatePlugin.name),
                       duplicatePluginFolderName,
                       "The folder name should equal the plugin's name")

        // Clean Up
        do {
            try removeTemporaryItem(at: duplicatePluginURL)
            try removeTemporaryItem(at: tempCopyTempDirectoryURL)
        } catch {
            XCTFail()
        }
    }

    func testDuplicatePluginWithFolderNameBlocked() {
        do {
            try FileManager.default.createDirectory(at: temporaryUserPluginsDirectoryURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            XCTFail()
        }

        // Function to create a blocking folder for a plugin with the provided name
        let makeBlockingFolderWithName: ((String, Plugin, PluginsManager, URL) -> Void) = {
            name, plugin, pluginsManager, destinationDirectoryURL in
            let uniqueName = pluginsManager.pluginsController.uniquePluginName(fromName: name,
                                                                               for: plugin)
            let destinationName = DuplicatePluginController.pluginFilename(fromName: uniqueName)

            // Create a folder at the destination URL
            let destinationFolderURL = destinationDirectoryURL.appendingPathComponent(destinationName)

            do {
                try FileManager.default.createDirectory(at: destinationFolderURL,
                                                        withIntermediateDirectories: false,
                                                        attributes: nil)
            } catch {
                XCTFail()
            }

            // Test that the folder exists
            var isDir: ObjCBool = false
            let exists = FileManager.default.fileExists(atPath: destinationFolderURL.path, isDirectory: &isDir)
            XCTAssertTrue(exists, "The file should exist")
            XCTAssertTrue(isDir.boolValue, "The file should be a directory")
        }

        // Block the original name, and all incremented names up to `duplicatePluginsWithCounterMax`
        // This will force a fallback to a name based on the plugin's identifier
        makeBlockingFolderWithName(plugin.name, plugin, pluginsManager, temporaryUserPluginsDirectoryURL)
        for index in 2 ..< duplicatePluginsWithCounterMax {
            makeBlockingFolderWithName("\(plugin.name) \(index)",
                                       plugin,
                                       pluginsManager,
                                       temporaryUserPluginsDirectoryURL)
        }

        // Perform the duplicate
        var duplicatePlugin: Plugin!
        let duplicateExpectation = expectation(description: "Duplicate")
        duplicatePluginController.duplicate(plugin, to: temporaryUserPluginsDirectoryURL) { (plugin, error) -> Void in
            XCTAssertNil(error, "The error should be nil")
            XCTAssertNotNil(plugin, "The plugin should not be nil")
            duplicatePlugin = plugin
            duplicateExpectation.fulfill()
        }
        waitForExpectations(timeout: defaultTimeout, handler: nil)

        // Assert the folder name equals the plugin's identifier
        let duplicatePluginFolderName = duplicatePlugin.bundle.bundlePath.lastPathComponent
        XCTAssertEqual(duplicatePluginFolderName,
                       DuplicatePluginController.pluginFilename(fromName: duplicatePlugin.identifier),
                       "The folder name should equal the identifier")

        // Clean Up
        do {
            try removeTemporaryItem(at: tempCopyTempDirectoryURL)
        } catch {
            XCTFail()
        }
    }
}
