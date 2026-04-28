//
//  L10n.swift
//  EyeSearch
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import Foundation

enum L10n {}

extension String {
    static func localized(_ key: String, table: String? = nil) -> String {
        NSLocalizedString(key, tableName: table, comment: "")
    }

    static func localized(_ key: String, table: String? = nil, _ args: CVarArg...) -> String {
        String(format: NSLocalizedString(key, tableName: table, comment: ""), arguments: args)
    }
}
