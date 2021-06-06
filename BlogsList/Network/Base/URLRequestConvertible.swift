//
//  URLRequestConvertible.swift
//  DataModel
//
//  Created by Ali Jawad on 01/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
protocol URLRequestConvertable {
    func toURLRequest(baseURL: URL) -> URLRequest?
}
