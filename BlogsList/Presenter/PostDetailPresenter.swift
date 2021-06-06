//
//  PostDetailPresenter.swift
//  BlogsList
//
//  Created by Ali Jawad on 02/06/2021.
//

import Foundation

struct PostDetailPresenter  {
    let title: String
    let date: String
    let imageUrl: URL?
    let description: String
    
    init(title: String,
         date: String,
         imageUrl: String,
         description: String) {
        self.title = title
        self.date = date.formatDate() ?? ""
        self.imageUrl = URL(string: imageUrl)
        self.description = description
    }
}
