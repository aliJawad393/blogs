//
//  PostRepository.swift
//  DataModel
//
//  Created by Ali Jawad on 31/05/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation

public protocol PostRepository {
    func getPosts(offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable?
    func searchPosts(query: String, offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable?
    func getPostDetails(postId: Int, response: @escaping ((Result<Post, Error>) -> Void)) -> Cancellable?
}

public protocol PostPersistance {
    func savePost(_ post: Post)
    func savePosts(_ posts: [Post])
    func deleteAllPosts() throws
}
