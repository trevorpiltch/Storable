//
//  File.swift
//  
//
//  Created by Trevor Piltch on 8/9/23.
//

import Foundation
import CoreData

struct Model: Storable {
	typealias Object = Self
	
	static var context: NSManagedObjectContext = CoreDataContainer(name: "Model").viewContext
	static var entityName: String = "ModelEntity"
	static var NSObjects: [NSManagedObject] = []
	
	var created: Date
	var id: Int
	var title: String

	init(_ properties: [String : Any]) {
		self.created = properties["created"] as? Date ?? Date()
		self.id = properties["id"] as? Int ?? 0
		self.title = properties["title"] as? String ?? ""
	}
	
	init(created: Date, id: Int, title: String) {
		self.created = created
		self.id = id
		self.title = title
	}
	
	static func setContext(_ context: NSManagedObjectContext) {
		Self.context = context
	}
	
	static let example = Model(created: Date(), id: 0, title: "Title")
}
