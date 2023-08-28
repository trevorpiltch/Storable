//
//  File.swift
//  
//
//  Created by Trevor Piltch on 8/25/23.
//

import Foundation

/// Helpful methods for a collection of elements who conform to storable
extension Collection where Element: Storable {
	/// Saves a group of elements in a collection
	func save() throws {
		for element in self {
			try element.save()
		}
	}
	
	/// Deletes all the elements in the current collection
	func delete() throws {
		for element in self {
			try element.delete()
		}
	}
}
