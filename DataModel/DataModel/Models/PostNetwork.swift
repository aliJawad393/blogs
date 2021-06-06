//
//  Post.swift
//  DataModel
//
//  Created by Ali Jawad on 30/05/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
public struct Post {
    public let id: Int
    public let date : String
    public let title: String
    public let featured: Bool
    public let imageUrl: String
    public let content: String
    
    public init(id: Int, date: String, title: String, featured: Bool, imageUrl: String, content: String) {
        self.id = id
        self.date = date
        self.title = title
        self.featured = featured
        self.imageUrl = imageUrl
        self.content = content
    }
}

public struct PostResponse {
    public let totalPosts: Int
    public let posts: [Post]
    
    public init(totalPosts: Int, posts: [Post]) {
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
