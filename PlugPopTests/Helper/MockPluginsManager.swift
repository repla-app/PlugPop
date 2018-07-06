//
//  MockPluginsManager.swift
//  PlugPopTests
//
//  Created by Roben Kleene on 9/20/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

import Foundation
import PlainBagel
@testable import PlugPop

class MockPluginsManager: PluginsManager {
    var mockPluginsController: MockPluginsController {
        return pluginsController as! MockPluginsController
    }

    override class func makeConfiguration(pluginsPaths: [String],
                                          copyTempDirectoryURL: URL,
                                          defaults: DefaultsType,
                                          userPluginsPath: String,
                                          builtInPluginsPath: String?) -> PluginsManagerConfiguration {
        let types = PluginsManagerConfigurationTypes(defaultNewPluginManagerType: POPDefaultNewPluginManager.self,
                                                     pluginsDataControllerType: PluginsDataController.self,
                                                     pluginsControllerType: MockPluginsController.self)
        return PluginsManagerConfiguration(types: types,
                                           pluginsPaths: pluginsPaths,
                                           copyTempDirectoryURL: copyTempDirectoryURL,
                                           defaults: defaults,
                                           userPluginsPath: userPluginsPath,
                                           builtInPluginsPath: builtInPluginsPath)
    }
}
