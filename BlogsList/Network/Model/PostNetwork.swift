//
//  PostNetwork.swift
//  BlogsList
//
//  Created by Ali Jawad on 05/06/2021.
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

public struct Content : Decodable {
    public let rendered : String?

    enum CodingKeys: String, CodingKey {
        case rendered = "rendered"
    }
}
