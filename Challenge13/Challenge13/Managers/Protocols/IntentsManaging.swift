//
//  IntentsManaging.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 20/04/26.
//

import Foundation
import SwiftUI

// MARK: - Protocol para IntentsManager
protocol IntentsManaging: AnyObject {
    var coordinator: Coordinator? { get set }

    @MainActor
    func openSearchObject()
}
