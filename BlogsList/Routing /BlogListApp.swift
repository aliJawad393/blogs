//
//  BlogListApp.swift
//  BlogsList
//
//  Created by Ali Jawad on 28/05/2021.
//

import Foundation

public final class BlogListApp {
    private let flow: Any
    
    private init(flow: Any) {
        self.flow = flow
    }
    
    public static func start(delegate: BlogPostsListDelegate) -> BlogListApp {
        let flow = Flow(delegate: delegate)
        flow.start()
        return BlogListApp(flow: flow)
    }
    
}


class Flow {
    private let delegate: BlogPostsListDelegate

    init(delegate: BlogPostsListDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        delegate.loadListsViewController(selectionCallBack: {[unowned self] selectedId in
            self.delegate.loadListDetailViewController(postId: selectedId)
        })
    }
}
