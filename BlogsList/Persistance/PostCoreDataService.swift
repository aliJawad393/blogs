//
//  PostCoreData.swift
//  BlogsList
//
//  Created by Ali Jawad on 03/06/2021.
//

import Foundation
import CoreData
import DataModel
 
final class PostCoreDataService: PostRepository, PostPersistance {

    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    private init() {
        fatalError("Can't be Initialized without Required parameters")
    }
    
    func savePost(_ post: Post) {
        savePostInCoreData(post)
        managedObjectContext.saveContext()
    }
    
    func savePosts(_ posts: [Post]) {
        for post in posts {
            savePostInCoreData(post)
            managedObjectContext.saveContext()
        }
    }
    
    func deleteAllPosts() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try managedObjectContext.execute(batchDeleteRequest)
        managedObjectContext.saveContext()
    }
    
    func getPosts(offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        let totalCount = (try? managedObjectContext.count(for: fetchRequest)) ?? 0
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = perPage
        
        do {
            if let results   = try managedObjectContext.fetch(fetchRequest) as? [PostEntity] {
                let postsReturn = results.map {item in
                    Post(item)
                }
                response(.success(PostResponse(totalPosts: totalCount > 0 ? totalCount : postsReturn.count, posts: postsReturn)))
            } else {
                response(.failure(PersistanceError.notFound))
            }
        } catch let error as NSError {
            response(.failure(error))
        }

        return nil
    }
    
    func searchPosts(query: String, offset: Int, perPage: Int, response: @escaping ((Result<PostResponse, Error>) -> Void)) -> Cancellable? {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()

        guard query.count > 0 else {
             return getPosts(offset: offset, perPage: perPage, response: response)
        }
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)

        do {
            let totalCount = (try? managedObjectContext.count(for: request)) ?? 0
            request.fetchOffset = offset
            request.fetchLimit = perPage
            let results = try managedObjectContext.fetch(request)
            let postsReturn = results.map {item in
                Post(item)
            }
            response(.success(PostResponse(totalPosts: totalCount > 0 ? totalCount : results.count, posts: postsReturn)))

            
        } catch let error as NSError {
            response(.failure(error))
        }

        return nil
    }
    
    func getPostDetails(postId: Int, response: @escaping ((Result<Post, Error>) -> Void)) -> Cancellable? {
            do {
                let fetchRequest : NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "itemID == %d", postId)
                let fetchedResults = try managedObjectContext.fetch(fetchRequest)
                if let item = fetchedResults.first {
                    response(.success(Post(item)))
                }
            }
            catch let error as NSError{
                response(.failure(error))
            }
        return nil
    }
    
    //MARK: Private Helper
    private func savePostInCoreData(_ post: Post) {
        guard let entity =
            NSEntityDescription.entity(forEntityName: "PostEntity",
                                       in: managedObjectContext), let newPost = NSManagedObject(entity: entity,
                                                                                        insertInto: managedObjectContext) as? PostEntity   else {
            fatalError("Failed to save")
        }
        newPost.itemID = Int32(post.id)
        newPost.imageUrl = post.imageUrl
        newPost.title = post.title
        newPost.date = post.date
        newPost.featured = post.featured
        newPost.postDescription = post.content
    }
}

private extension Post {
    init(_ item: PostEntity) {
         self = Post(id: Int(item.itemID), date: item.date ?? "", title: item.title ?? "", featured: item.featured, imageUrl: item.imageUrl ?? "", content: item.postDescription ?? "")
    }
}
