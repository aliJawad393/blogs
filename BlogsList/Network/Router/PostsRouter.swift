//
//  PostRouter.swift
//  DataModel
//
//  Created by Ali Jawad on 01/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation

enum PostsRouter {
    case get(offset: Int, pageSize: Int)
    case search(query: String, offset: Int, pageSize: Int)
    case details(postId: Int)
}

extension PostsRouter: Router {
    var method: String {
        "GET"
    }
    var path: String {
        switch self {
        case .get:
            return "/posts"
        case .search:
            return "/posts"
        case .details(let postId):
            return "/posts/\(postId)"
        }
    }
    private var parameters: [URLQueryItem]? {
        switch self {
        case .get(let offSet, let pageSize):
            return [URLQueryItem(name: "offset", value: String(offSet)), URLQueryItem(name: "per_page", value: String(pageSize))]
        case .search(let query, let offSet, let pageSize):
            return [URLQueryItem(name: "search", value: query), URLQueryItem(name: "offset", value: String(offSet)), URLQueryItem(name: "per_page", value: String(pageSize))]
        default:
            return nil
        }
    }
}

extension PostsRouter: URLRequestConvertable {
    func toURLRequest(baseURL: URL) -> URLRequest? {
        var url = baseURL.appendingPathComponent(path)
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = parameters
            url = components.url ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}
