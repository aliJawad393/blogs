//
//  Error.swift
//  DataModel
//
//  Created by Ali Jawad on 01/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation

enum NetworkError {
    case urlCreationFailed
    case parsingFailed
    case networkUnreachable
}

extension NetworkError: Error { }
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
            switch self {
            case .parsingFailed:
                return NSLocalizedString("Failed to parse response", comment: "Error")
            case .urlCreationFailed:
                return NSLocalizedString("Failed to create URL", comment: "Error")
            case .networkUnreachable:
                return NSLocalizedString("Network unreachable", comment: "Error")
            }
        }
}
