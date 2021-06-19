//
//  BlogListApp.swift
//  BlogsList
//
//  Created by Ali Jawad on 28/05/2021.
//

import Foundation

public final class BlogListApp {
    
    public static func start(flow:  FlowBlogsList) -> BlogListApp {
        flow.start()
        return BlogListApp()
    }
    
}







