//
//  CoreDataStack.swift
//  MusicApp
//
//  Created by Vadim on 28/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private var persistentContainerName: String!
    
    init(persistentContainerName: String) {
        self.persistentContainerName = persistentContainerName
    }
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Load Persistent Stores failed: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private(set) lazy var context = persistentContainer.viewContext
    
}
