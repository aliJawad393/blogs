//
//  FlowBlogsList.swift
//  BlogsList
//
//  Created by Ali Jawad on 06/06/2021.
//

import Foundation
final class FlowBlogsList: Flow {
    var nextFlow: Flow?
    private let delegate: BlogPostsListDelegate

    init(delegate: BlogPostsListDelegate) {
        self.delegate = delegate
        self.nextFlow = nil
    }
    
    func start() {
        delegate.loadListsViewController(selectionCallBack: {[unowned self] selectedId in
            self.delegate.loadListDetailViewController(postId: selectedId)
        })
    }
}
