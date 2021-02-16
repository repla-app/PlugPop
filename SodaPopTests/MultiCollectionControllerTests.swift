//
//  PluginsControllerTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/14/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
@testable import SodaPop
import SodaPopTestHarness
import XCTest

protocol EasyDuplicateType {
    func urlByDuplicatingItem(at fileURL: URL, withFilenameForDuplicate filename: String) -> URL
}

extension EasyDuplicateType {
    func urlByDuplicatingItem(at fileURL: URL, withFilenameForDuplicate filename: String) -> URL {
        let destinationFileURL = fileURL.deletingLastPathComponent().appendingPathComponent(filename)
        do {
            try FileManager.default.copyItem(at: fileURL, to: destinationFileURL)
        } catch {
            XCTAssertTrue(false, "The copy should succeed")
        }
        return destinationFileURL
    }
}

class MultiCollectionControllerInitTests: TemporaryTwoPluginsTestCase, EasyDuplicateType {
    func testInitPlugins() {
        for tempPluginURL in tempPluginURLs {
            // `tempXMLPluginURL` actually has JSON and XML files, so force XML
            Plugin.forceXML = true
            let plugin = Plugin.makePlugin(url: tempPluginURL)!
            if tempPluginURL == tempXMLPluginURL {
                XCTAssertTrue(XMLPlugin.self == type(of: plugin))
            } else {
                XCTAssertTrue(JSONPlugin.self == type(of: plugin))
            }
            plugin.editable = true

            let newPluginFilename = testDirectoryName
            let newPluginURL = urlByDuplicatingItem(at: tempPluginURL, withFilenameForDuplicate: newPluginFilename)
            let newPlugin = Plugin.makePlugin(url: newPluginURL)!

            let newPluginTwoFilename = testDirectoryNameTwo
            let newPluginTwoURL = urlByDuplicatingItem(at: tempPluginURL,
                                                       withFilenameForDuplicate: newPluginTwoFilename)
            let newPluginTwo = Plugin.makePlugin(url: newPluginURL)!

            let newPluginChangedNameFilename = testDirectoryNameThree
            let newPluginChangedNameURL = urlByDuplicatingItem(at: tempPluginURL,
                                                               withFilenameForDuplicate: newPluginChangedNameFilename)
            let newPluginChangedName = Plugin.makePlugin(url: newPluginURL)!
            let changedName = testDirectoryName
            newPluginChangedName.name = changedName

            let newPluginChangedNameTwoFilename = testDirectoryNameFour
            let newPluginChangedNameTwoURL = urlByDuplicatingItem(at: tempPluginURL,
                                                                  withFilenameForDuplicate:
                                                                  newPluginChangedNameTwoFilename)
            let newPluginChangedNameTwo = Plugin.makePlugin(url: newPluginURL)!
            newPluginChangedNameTwo.name = changedName

            let plugins = [plugin, newPlugin, newPluginTwo, newPluginChangedName, newPluginChangedNameTwo]
            let newPluginURLs = [newPluginURL, newPluginTwoURL, newPluginChangedNameURL, newPluginChangedNameTwoURL]

            let multiCollectionController = MultiCollectionController(objects: plugins, key: pluginNameKey)

            XCTAssertEqual(multiCollectionController.objects().count, 2, "The plugins count should be one")

            // Test New Plugins
            XCTAssertEqual(multiCollectionController.object(forKey: newPluginTwo.name)! as? Plugin, newPluginTwo)
            XCTAssertTrue(multiCollectionController.objects().contains(newPluginTwo))
            XCTAssertFalse(multiCollectionController.objects().contains(newPlugin))
            XCTAssertFalse(multiCollectionController.objects().contains(plugin))

            // Test New Plugins Changed Name
            XCTAssertEqual(multiCollectionController.object(forKey: newPluginChangedNameTwo.name)! as? Plugin,
                           newPluginChangedNameTwo)
            XCTAssertTrue(multiCollectionController.objects().contains(newPluginChangedNameTwo))
            XCTAssertFalse(multiCollectionController.objects().contains(newPluginChangedName))

            // Clean up
            for pluginURL: URL in newPluginURLs {
                do {
                    try FileManager.default.removeItem(at: pluginURL)
                } catch {
                    XCTAssertTrue(false, "The remove should succeed")
                }
            }
            Plugin.forceXML = defaultForceXML
        }
    }
}

class MultiCollectionControllerTests: TemporaryPluginsTestCase, EasyDuplicateType {
    var multiCollectionController: MultiCollectionController!
    var plugin: Plugin!

    override func setUp() {
        super.setUp()
        plugin = Plugin.makePlugin(url: tempPluginURL)!
        multiCollectionController = MultiCollectionController(objects: [plugin], key: pluginNameKey)
    }

    override func tearDown() {
        multiCollectionController = nil
        super.tearDown()
    }

    func testAddPlugin() {
        let destinationPluginURL = urlByDuplicatingItem(at: tempPluginURL, withFilenameForDuplicate: plugin.identifier)
        let newPlugin = Plugin.makePlugin(url: destinationPluginURL)!
        multiCollectionController.addObject(newPlugin)
        guard let plugins = multiCollectionController.objects() as? [Plugin] else {
            XCTFail()
            return
        }
        XCTAssertEqual(multiCollectionController.objects().count, 1, "The plugins count should be one")
        XCTAssertEqual(multiCollectionController.object(forKey: newPlugin.name)! as? Plugin, newPlugin)
        XCTAssertTrue(multiCollectionController.objects().contains(newPlugin))
        XCTAssertFalse(plugins.contains(plugin))

        // Clean up
        do {
            try FileManager.default.removeItem(at: destinationPluginURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
    }

    func testAddPlugins() {
        let newPluginFilename = testDirectoryName
        let newPluginURL = urlByDuplicatingItem(at: tempPluginURL, withFilenameForDuplicate: newPluginFilename)
        let newPlugin = Plugin.makePlugin(url: newPluginURL)!

        let newPluginTwoFilename = testDirectoryNameTwo
        let newPluginTwoURL = urlByDuplicatingItem(at: tempPluginURL, withFilenameForDuplicate: newPluginTwoFilename)
        let newPluginTwo = Plugin.makePlugin(url: newPluginURL)!

        let newPluginChangedNameFilename = testDirectoryNameThree
        let newPluginChangedNameURL = urlByDuplicatingItem(at: tempPluginURL,
                                                           withFilenameForDuplicate: newPluginChangedNameFilename)
        let newPluginChangedName = Plugin.makePlugin(url: newPluginURL)!
        newPluginChangedName.editable = true
        let changedName = testDirectoryName
        newPluginChangedName.name = changedName

        let newPluginChangedNameTwoFilename = testDirectoryNameFour
        let newPluginChangedNameTwoURL = urlByDuplicatingItem(at: tempPluginURL,
                                                              withFilenameForDuplicate: newPluginChangedNameTwoFilename)
        let newPluginChangedNameTwo = Plugin.makePlugin(url: newPluginURL)!
        newPluginChangedNameTwo.name = changedName

        let newPlugins = [newPlugin, newPluginTwo, newPluginChangedName, newPluginChangedNameTwo]
        let newPluginURLs = [newPluginURL, newPluginTwoURL, newPluginChangedNameURL, newPluginChangedNameTwoURL]

        multiCollectionController.addObjects(newPlugins)

        XCTAssertEqual(multiCollectionController.objects().count, 2, "The plugins count should be one")

        // Test New Plugins
        guard let plugins = multiCollectionController.objects() as? [Plugin] else {
            XCTFail()
            return
        }
        XCTAssertEqual(multiCollectionController.object(forKey: newPluginTwo.name)! as? Plugin, newPluginTwo)
        XCTAssertTrue(multiCollectionController.objects().contains(newPluginTwo))
        XCTAssertFalse(multiCollectionController.objects().contains(newPlugin))
        XCTAssertFalse(plugins.contains(plugin))

        // Test New Plugins Changed Name
        XCTAssertEqual(multiCollectionController.object(forKey: newPluginChangedNameTwo.name)! as? Plugin,
                       newPluginChangedNameTwo)
        XCTAssertTrue(multiCollectionController.objects().contains(newPluginChangedNameTwo))
        XCTAssertFalse(multiCollectionController.objects().contains(newPluginChangedName))

        for pluginURL: URL in newPluginURLs {
            // Clean up
            do {
                try FileManager.default.removeItem(at: pluginURL)
            } catch {
                XCTAssertTrue(false, "The remove should succeed")
            }
        }
    }
}
