import XCTest
@testable import Storable	

final class StorableTests: XCTestCase {
	private let modelName = "Model"
	private var container: CoreDataContainer!
	private let model = Model.example
	
	override func setUpWithError() throws {
		container = CoreDataContainer(name: modelName, bundle: Bundle.module)
	}
	
	// MARK: CRUD Tests
    func testCreate() throws {
		try addExample()
		
		let read = try Model.load()
		
		XCTAssertEqual(read.count, 1)
    }
	
	func testUpdate() throws {
		let model = Model.example
		
		try model.save()
		
		try model.update(key: "title", value: "Updated Title")
		
		let objects = try Model.load()
		
		for object in objects where object.id == model.id {
			XCTAssertEqual(object.title, model.title)
		}
	}
	
	func testDeleteAll() throws {
		for _ in 0...4 {
			try addExample()
		}
		
		try Model.deleteAll()
		
		let objects = try Model.load()
		
		XCTAssert(objects.isEmpty)
	}
	
	func testBatchSave() throws {
		var models: [Model] = []
		
		for _ in 0...4 {
			models.append(.example)
		}
		
		try models.save()
		
		let objects = try Model.load()
		
		XCTAssertEqual(objects.count, 5)
	}
	
	func testBatchDelete() throws {
		let models: [Model] = [.example, .example]
		
		try models.delete()
		
		let objects = try Model.load()
		
		XCTAssertEqual(objects.count, 0)
	}
	
	private func addExample() throws {
		let model = Model.example
		Model.setContext(container.viewContext)

		try model.save()
	}
}
