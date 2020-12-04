//
//  PluginType.swift
//  SodaPop
//
//  Created by Roben Kleene on 11/19/20.
//  Copyright © 2020 Roben Kleene. All rights reserved.
//

import Foundation

public protocol Plugin {
    var hidden: Bool { get }
    var promptInterrupt: Bool { get }
    var usesEnvironment: Bool { get }
    // `debugModeEnabled` is three state, `nil` means use the user prefrence
    var debugModeEnabled: Bool? { get }
    // `autoShowLog` is three state, `nil` means use the user prefrence
    var autoShowLog: Bool? { get }
    var transparentBackground: Bool { get }
    var pluginKind: PluginKind { get }
    var path: String { get }
    var url: URL { get }
    var directoryURL: URL { get }
    var directoryPath: String { get }
    var name: String { get set }
    var identifier: String { get set }
    var command: String? { get set }
    var commandPath: String? { get set }
    var suffixes: [String] { get set }
    var editable: Bool { get set }

    static func == (lhs: Plugin, rhs: Plugin) -> Bool
    static func != (lhs: Plugin, rhs: Plugin) -> Bool
}
