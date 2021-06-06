//
//  View.swift
//  BlogsList
//
//  Created by Ali Jawad on 30/05/2021.
//

import Foundation

protocol ErrorView {
    func showError(title: String, message: String)
}

protocol LoadingIndicatorView {
    func loadingActivity(loading: Bool)
}

protocol View: class, ErrorView, LoadingIndicatorView { }
