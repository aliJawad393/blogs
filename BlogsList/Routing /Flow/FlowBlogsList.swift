//
//  FlowBlogsList.swift
//  BlogsList
//
//  Created by Ali Jawad on 06/06/2021.
//

import Foundation
final public  class FlowBlogsList {
    private let delegate: BlogPostsListDelegate

    public init(delegate: BlogPostsListDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        delegate.loadListsViewController(selectionCallBack: {[unowned self] selectedId in
            self.delegate.loadListDetailViewController(postId: selectedId)
        })
    }
}
