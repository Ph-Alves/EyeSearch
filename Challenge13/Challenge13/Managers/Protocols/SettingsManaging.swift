//
//  SettingsManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

protocol SettingsManaging {
    func load() -> UserSettings
    func save(_ settings: UserSettings) -> Void
}
