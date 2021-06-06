//
//  BlogListApp.swift
//  BlogsList
//
//  Created by Ali Jawad on 28/05/2021.
//

import Foundation

public final class BlogListApp {
    private let flow: Flow
    
    private init(flow: Flow) {
        self.flow = flow
    }
    
    public static func start(flow: Flow) -> BlogListApp {
        flow.start()
        return BlogListApp(flow: flow)
    }
    
}







