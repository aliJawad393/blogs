//
//  NetworkNotifier.swift
//  BlogsList
//
//  Created by Ali Jawad on 05/06/2021.
//

import Foundation

public protocol NetworkNotifier {
    var isReachable: Bool { get }
    var whenReachable: (() -> Void)? { get set }
    var whenUnreachable: (() -> Void)? { get set }
}

public func getNetworkNotifier() -> NetworkNotifier {
    ReachabilityNetworkNotifier()
}
