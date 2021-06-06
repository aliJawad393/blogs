//
//  PersistanceError.swift
//  BlogsList
//
//  Created by Ali Jawad on 05/06/2021.
//

import Foundation

enum PersistanceError {
    case notFound
}

extension PersistanceError: Error { }
extension PersistanceError: LocalizedError {
    var errorDescription: String? {
            switch self {
            case .notFound:
                return NSLocalizedString("Query data not found", comment: "Error")
            }
        }
}
