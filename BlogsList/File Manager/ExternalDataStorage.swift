//
//  ExternalStorage.swift
//  BlogsList
//
//  Created by Ali Jawad on 05/06/2021.
//

import Foundation

protocol ExternalDataStorage {
    func writeData(data: Data) throws -> URL?
    func getData(path: String) -> Data?
}

final class DataStorageFile: ExternalDataStorage {
    private let fileManager: FileManager
    
    //MARK: Init
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func writeData(data: Data) throws -> URL? {
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(UUID().uuidString).png")
        let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
        
        for file in files {
            if "\(documentPath)/\(file)" == filePath.path {
                try fileManager.removeItem(atPath: filePath.path)
            }
        }
        try data.write(to: filePath, options: .atomic)
        return filePath
    }
    
    func getData(path: String) -> Data? {
        if let url = URL(string: path), fileManager.fileExists(atPath: url.path) {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}
