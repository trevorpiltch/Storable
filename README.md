# Storable
**v1.0**
## About
Storable is a Swift package created to bring CoreData usage closer to SwiftData. Although SwiftData is the future and should be used in new production ready applications, CoreData is still used in many places. So, I created Storable. It brings compile time verification for saving, reading, and deleleting objects from CoreData. No more pesky crashes where you forget to initialize or type cast a value!

## Usage
Conform the object you want to save to the `Storable` protocol. All you need to provide is your EntityName (created in CoreData), the current context, and a initializer helper.  
