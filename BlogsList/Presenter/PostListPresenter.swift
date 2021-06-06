//
//  PostListPresenter.swift
//  BlogsList
//
//  Created by Ali Jawad on 02/06/2021.
//

import Foundation
struct PostsListPresenter {
    let title: String
    let dataItems: [DataItem]
    
    struct DataItem: Hashable {
        let id: Int
        let date: String
        let imageUrl: String
        let title: String
        let isFeatured: Bool
        init(id: Int,
             date: String,
             imageUrl: String,
             title: String,
             isFeatured: Bool) {
            self.date = date.formatDate() ?? ""
            self.imageUrl = imageUrl
            self.isFeatured = isFeatured
            self.title = title
            self.id = id
        }
    }
}
