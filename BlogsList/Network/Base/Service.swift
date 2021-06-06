//
//  ervice.swift
//  DataModel
//
//  Created by Ali Jawad on 01/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel

class Service {
    private let session: URLSession
    private let baseURL: URL
    let parser: ParserProtocol
    private let networkNotifier: NetworkNotifier
    
    //MARK: Init
    public init(session: URLSession, baseURL: URL, parser: ParserProtocol, networkNotifier: NetworkNotifier) {
        self.baseURL = baseURL
        self.session = session
        self.parser = parser
        self.networkNotifier = networkNotifier
    }
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func performRequest(request: URLRequestConvertable, completion: @escaping (Result<(Data, HTTPURLResponse?), Error>) -> Void) -> Cancellable? {
        guard let urlRequest = request.toURLRequest(baseURL: baseURL) else {
            completion(.failure(NetworkError.urlCreationFailed))
            return nil 
        }
        
        guard networkNotifier.isReachable else {
            completion(.failure(NetworkError.networkUnreachable))
            return nil
        }
        
        let task: URLSessionDataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data, let response = response {
                let returnValue = (data, response as? HTTPURLResponse)
                completion(.success(returnValue))
                return
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
        }
        task.resume()
        return CancellableDataTask(task: task)
        
    }
}
