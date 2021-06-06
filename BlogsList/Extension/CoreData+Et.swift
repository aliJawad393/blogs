//
//  CoreData+Et.swift
//  BlogsList
//
//  Created by Ali Jawad on 03/06/2021.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveContext() {
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
