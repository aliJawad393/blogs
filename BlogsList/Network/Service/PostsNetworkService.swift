//
//  PostsService.swift
//  DataModel
//
//  Created by Ali Jawad on 01/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel

final class PostsNetworkService: Service, PostRepository  {
    public func getPostDetails(postId: Int, response: @escaping ((Result<Post, Error>) -> Void)) -> Cancellable? {
        return performRequest(request: PostsRouter.details(postId: postId)) {[weak self] result in
            switch result {
            case .failure(let error):
                response(.failure(error))
            case .success(let data):
                if let post = self?.parser.parseResponse(data: data.0, response: PostNetwork.self) {

                    response(.success(Post(id: post.id, date: post.date, title: post.title.rendered, featured: post.featured, imageUrl: post.imageUrl, content: post.content.rendered ?? "")
))
                } else {
                    response(.failure(NetworkError.parsingFailed))
                }
            }
        }
    }
    
    func getPosts(offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        return performRequest(request: PostsRouter.get(offset: offset, pageSize: perPage)) {[weak self] result in
            switch result {
            case .failure(let error):
                response(.failure(error))
            case .success(let data):
                if let posts = self?.parser.parseResponse(data: data.0, response: [PostNetwork].self) {
                    var totalPosts = 0
                    if let httpResponse = data.1 {
                        if let totalFields = httpResponse.allHeaderFields["x-wp-total"] as? String {
                            totalPosts = Int(totalFields) ?? 0
                         }
                    }
                    
                    let postsMapped = posts.map {item in
                        Post(id: item.id, date: item.date, title: item.title.rendered, featured: item.featured, imageUrl: item.imageUrl, content: item.content.rendered ?? "")
                    }
                    
                    let postResponse = PostResponse(totalPosts: totalPosts, posts: postsMapped)
                    response(.success(postResponse))
                } else {
                    response(.failure(NetworkError.parsingFailed))
                }
            }
        }
    }
    
    func searchPosts(query: String, offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        return performRequest(request: PostsRouter.search(query: query, offset: offset, pageSize: perPage)) {[weak self] result in
            switch result {
            case .failure(let error):
                response(.failure(error))
            case .success(let data):
                if let posts = self?.parser.parseResponse(data: data.0, response: [PostNetwork].self) {
                    var totalPosts = 0
                    if let httpResponse = data.1 {
                        if let totalFields = httpResponse.allHeaderFields["x-wp-total"] as? String {
                            totalPosts = Int(totalFields) ?? 0
                         }
                    }
                    
                    let postsMapped = posts.map {item in
                        Post(id: item.id, date: item.date, title: item.title.rendered, featured: item.featured, imageUrl: item.imageUrl, content: item.content.rendered ?? "")
                    }
                    
                    response(.success(PostResponse(totalPosts: totalPosts, posts: postsMapped)))
                } else {
                    response(.failure(NetworkError.parsingFailed))
                }
            }
        }
    }
    
}
