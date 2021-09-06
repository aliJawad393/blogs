//
//  BlogsListTests.swift
//  BlogsListTests
//
//  Created by Ali Jawad on 28/05/2021.
//

import XCTest
@testable import BlogsList
import CoreData
import DataModel

class PostCoreDataServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        //Delete all saved posts before running another test
        flushData()
    }

    func test_savePost_addsEntryInTable() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)

        XCTAssert(assertPostsCount(expectedCount: 0))
        sut.savePost(createPost(withId: 0))
        XCTAssert(assertPostsCount(expectedCount: 1))
    }

    func test_savePosts_addsMultipleEntriesInTable() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        XCTAssert(assertPostsCount(expectedCount: 0))
        sut.savePosts(createPosts(noOfPosts: 3))
        XCTAssert(assertPostsCount(expectedCount: 3))

    }

    func test_getPosts_returnsCorrectPosts() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        XCTAssertTrue(assertPostsCount(expectedCount: 0))
        sut.savePost(createPost(withId: 1))
        let expect = expectation(description: "core data returns one post")

        _ = sut.getPosts(offset: 0, perPage: 5) {response in
            switch response {
            case .success(let posts):
                XCTAssertTrue(posts.posts.count == 1)
                XCTAssertTrue(posts.posts[0].id == 1)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }
    
    func test_getPosts_returnsAsPerSizePageWhenTotalMoreThanPageSize() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts(createPosts(noOfPosts: 10))
        let expect = expectation(description: "returns as per pageSize when total more than pageSize")

        _ = sut.getPosts(offset: 0, perPage: 5) {response in
            switch response {
            case .success(let posts):
                XCTAssertTrue(posts.posts.count == 5)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }
    
    func test_getPosts_returnsAllWhenTotalLessThanPageSize() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts(createPosts(noOfPosts: 5))
        let expect = expectation(description: "returns all when total less than pageSize")

        _ = sut.getPosts(offset: 0, perPage: 10) {response in
            switch response {
            case .success(let posts):
                XCTAssertTrue(posts.posts.count == 5)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }
    
    func test_getPosts_returnsFirstPostToPageSizeWhenOffsetZero() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts(createPosts(noOfPosts: 5))
        let expect = expectation(description: "returns first post when offset Zero")
        _ = sut.getPosts(offset: 0, perPage: 5) {response in
            switch response {
            case .success(let posts):
                XCTAssertTrue(posts.posts[0].id == 0)
                XCTAssertTrue(posts.posts.last?.id == 4)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }
    
    func test_getPosts_returnsPostsAfterOffset() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts(createPosts(noOfPosts: 10))
        let expect = expectation(description: "returns posts after offset")
        _ = sut.getPosts(offset: 5, perPage: 5) {response in
            switch response {
            case .success(let posts):
                XCTAssertTrue(posts.posts.first?.id == 5)
                XCTAssertTrue(posts.posts.last?.id == 9)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }
    
    func test_getPosts_returnsEmptyWhenOffSetEqualTotalPosts() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts(createPosts(noOfPosts: 5))
        let expect = expectation(description: "returns empty when offSet equal to total posts")
        _ = sut.getPosts(offset: 5, perPage: 5) {response in
            switch response {
            case .success(let posts):
                XCTAssertTrue(posts.posts.isEmpty)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }
    
    func test_getPosts_returnsEmptyWhenOffSetGreaterThanTotalPosts() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts(createPosts(noOfPosts: 5))
        let expect = expectation(description: "returns empty when offSet greater than total posts")
        _ = sut.getPosts(offset: 6, perPage: 5) {response in
            switch response {
            case .success(let posts):
                XCTAssertTrue(posts.posts.isEmpty)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }

    func test_searchPosts_returnsEmptyOnEmptyTable() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        let expect = expectation(description: "search core data")

        _ = sut.searchPosts(query: "test", offset: 0, perPage: 10) {response in
            switch response {
            case .success(let posts):
                XCTAssert(posts.posts.count == 0)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }

    func test_searchPosts_returnsEmptyWhenNotMatching() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts([createPost(withId: 0, title: "title 1"), createPost(withId: 1), createPost(withId: 2, title: "title 2")])
        let expect = expectation(description: "search core data")

        _ = sut.searchPosts(query: "title 3", offset: 0, perPage: 10) {response in
            switch response {
            case .success(let posts):
                XCTAssert(posts.posts.count == 0)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }

    func test_searchPosts_returnsOneRecordWhenMatchingOneItem() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts([createPost(withId: 0, title: "title 1"), createPost(withId: 1), createPost(withId: 2, title: "title 2")])
        let expect = expectation(description: "search core data")

        _ = sut.searchPosts(query: "title 2", offset: 0, perPage: 10) {response in
            switch response {
            case .success(let posts):
                XCTAssert(posts.posts.count == 1)
                XCTAssert(posts.posts[0].id == 2)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }

    func test_searchPosts_returnsMultipleRecordsWhenMatching() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts([createPost(withId: 0, title: "title 1"), createPost(withId: 1), createPost(withId: 2, title: "title 2"), createPost(withId: 2, title: "title 3")])
        let expect = expectation(description: "search core data")

        _ = sut.searchPosts(query: "title", offset: 0, perPage: 10) {response in
            switch response {
            case .success(let posts):
                XCTAssert(posts.posts.count == 3)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }
    
    func test_searchPosts_returnsAllWhenItemsWhenQueryEmpty() {
        let sut = PostCoreDataService(managedObjectContext: persistentContainer.viewContext)
        sut.savePosts([createPost(withId: 0, title: "title 1"), createPost(withId: 1, title: "title 2"), createPost(withId: 2, title: "title 3")])
        let expect = expectation(description: "search core data")

        _ = sut.searchPosts(query: "", offset: 0, perPage: 10) {response in
            switch response {
            case .success(let posts):
                XCTAssert(posts.posts.count == 3)
            case .failure(_):
                XCTFail()
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 2)
    }
    
    
    //Persistant container saves data in-memory rather than in storage
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: Private Helpers
    private func assertPostsCount(expectedCount count: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        return (try? persistentContainer.viewContext.count(for: fetchRequest)) == count
    }
    
    private func createPost(withId id: Int, title: String = "tem") -> Post {
        Post(id: id, date: "12/11", title: title, featured: true, imageUrl: "http:temm", content: "Tem content")
    }
    
    private func createPosts(noOfPosts: Int) -> [Post] {
        var posts = [Post]()
        for index in 0...(noOfPosts - 1) {
            posts.append(createPost(withId: index))
        }
        
        return posts
    }
    
    private func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        let objs = try! persistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            persistentContainer.viewContext.delete(obj)
        }
        
        try! persistentContainer.viewContext.save()
        
    }
}
