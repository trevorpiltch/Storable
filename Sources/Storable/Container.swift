//
//  File.swift
//  
//
//  Created by Trevor Piltch on 8/9/23.
//

import Foundation
import CoreData

internal final class CoreDataContainer {
	private let persistentContainer: NSPersistentContainer
	internal var viewContext: NSManagedObjectContext
	
	public init(name: String, bundle: Bundle = .main) {
		guard let url = Bundle.module.url(forResource: name, withExtension: "momd") else { fatalError("Could not get URL for model: \(name)") }

		guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError("Could not get model for: \(url)") }
		
		let description = NSPersistentStoreDescription()
		description.url = URL(fileURLWithPath: "/dev/null")

		persistentContainer = .init(name: name, managedObjectModel: model)
		
		self.persistentContainer.persistentStoreDescriptions = [description]
		
		persistentContainer.loadPersistentStores { (_, error) in
			if let error {
				fatalError(error.localizedDescription)
			}
		}
		
		self.viewContext = self.persistentContainer.viewContext
	}
}

enum StorageType {
	case persistant, inMemory
}
