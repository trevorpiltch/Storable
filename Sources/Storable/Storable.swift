import Foundation
import CoreData

public protocol Storable {
	associatedtype Object
	
	/// The current context of the CoreData stack
	static var context: NSManagedObjectContext { get }
	/// The name of the entity managed by CoreData
	static var entityName: String { get }
	/// Stores the objects directly after being loaded by CoreData
	static var NSObjects: [NSManagedObject] { get set }
	/// The **unique** identifier of the object
	var id: Int { get }
	
	/// Initialize all the properties of the object you want to store in CoreData
	init(_ properties: [String: Any])
}

public extension Storable	 {
	//MARK: Class methods
	/// Converts the given NSObject into the Swift Object using mirrors
	static func convertNSObject(_ object: NSManagedObject) -> Self {
		var objectProps: [String: Any] = [:]
		
		for child in Mirror(reflecting: Self([:])).children where child.label! != "context" && child.label != "entityName" {
			let key = child.label!
			let value = object.value(forKey: key) as Any
			
			objectProps[key] = value
		}
		
		return Self(objectProps)
	}
	
	/// Loads all the objects from the given context store and converts it into the Swift object
	@discardableResult
	static func load() throws -> [Self] {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let data = try context.fetch(request) as! [NSManagedObject]
		NSObjects = data
		
		var objects: [Self] = []
		
		for datum in data {
			objects.append(convertNSObject(datum))
		}
		
		return objects
	}
	
	/// Deletes all the objects
	static func deleteAll() throws {
		try load()
		
		for object in NSObjects {
			context.delete(object)
		}
	}
	
	// MARK: Instance methods
	/// Saves the current object into the given context using mirrors
	func save() throws {
		let entity = NSEntityDescription.insertNewObject(forEntityName: Self.entityName, into: Self.context)
		
		let mirror = Mirror(reflecting: self)
		
		for child in mirror.children where child.label! != "context" && child.label != "entityName"  {
			let key = child.label!
			let value = child.value
			
			entity.setValue(value, forKey: key)
		}
		
		try Self.context.save()
	}
	
	/// Deletes the current object from the context
	func delete() throws {
		self.selectObject { object in
			Self.context.delete(object)
		}
		
		try Self.load()
	}
	
	/// Updates the current object using key value pairs
	func update(key: String, value: Any) throws {
		self.selectObject { object in
			object.setValue(value, forKey: key)
		}
		
		try Self.context.save()
		try Self.load()
	}
	
	// MARK: Helper functions
	/// Passes the `NSObject` that matches the current `Object` to the closure
	private func selectObject(_ closure: @escaping (NSManagedObject) -> ()) {
		for object in Self.NSObjects where Self.convertNSObject(object).id == self.id {
			closure(object)
		}
	}
}
