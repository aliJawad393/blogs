//
//  Post.swift
//  DataModel
//
//  Created by Ali Jawad on 30/05/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
public struct PostNetwork {
    public let id: Int
    public let date : String
    public let title: Title
    public let featured: Bool
    public let imageUrl: String
    public let content: Content
}

extension PostNetwork: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case date = "date_gmt"
        case imageUrl = "jetpack_featured_media_url"
        case featured = "featured"
        case title = "title"
        case content = "content"
    }
}

public struct Title : Decodable {
    public let rendered : String
}

public struct PostResponse {
    public let totalPosts: Int
    public let posts: [PostNetwork]
    
    public init(totalPosts: Int, posts: [PostNetwork]) {
        self.totalPosts = totalPosts
        self.posts = posts
    }
}

public struct Content : Decodable {
    public let rendered : String?

    enum CodingKeys: String, CodingKey {
        case rendered = "rendered"
    }
}
