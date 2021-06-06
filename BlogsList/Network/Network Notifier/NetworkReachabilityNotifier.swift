//
//  NetworkReachabilityNotifier.swift
//  BlogsList
//
//  Created by Ali Jawad on 05/06/2021.
//


import Reachability
import Foundation

final class ReachabilityNetworkNotifier {
private var reachability: Reachability?
var whenUnreachable: (() -> Void)?
var whenReachable: (() -> Void)?
init() {
  do {
    reachability = try Reachability()
  } catch {
    print(error)
  }
  guard let reachability = reachability else { return }
  reachability.whenReachable = { [weak self] _ in
    guard let whenReachable = self?.whenReachable else { return }
    DispatchQueue.main.async(execute: whenReachable)
  }
  reachability.whenUnreachable = { [weak self] _ in
    guard let whenUnreachable = self?.whenUnreachable else { return }
    DispatchQueue.main.async(execute: whenUnreachable)
  }
  do {
    try reachability.startNotifier()
  } catch {
    print(error)
  }
}
}

extension ReachabilityNetworkNotifier: NetworkNotifier {
var isReachable: Bool {
  guard let reachability = reachability else { return false }
  return reachability.connection != .unavailable
}
}

