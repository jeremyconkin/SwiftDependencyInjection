/*:
 # Dependency Injection
___
 */




















/*:
 *“Dependency Injection” is a 25-dollar term for a 5-cent concept.*
   -James Shore
 */










/*:
Give an object its instance variables instead of creating them in the object.
*/
/*:
 Pass in an object rather than creating it inside a method.
 */












/*:
Although the dependency injection in Swift is no different from the dependency injection in other languages, it is often underrated in iOS and OS X development community.
*/












/*:
 But first, Inversion of Control!
 */





/*:
 (and Analytics)
 */












/*:
 # Types of DI
 */

class ObjectWithDependencies {

    init() { }

    init(_ dependency:IDependency) {
        self.dependency = dependency
    }

    var dependency: IDependency?
    
    
    func doStuffWithDependency(_ inputDependency: IDependency) {
        inputDependency.Foo()
    }
}

protocol IDependency {
    func Foo()
}

class DependencyClass : IDependency {
    func Foo() {}
}







/*:
 ## Initializer Injection
 - Pass in an instance
 - Pass in a closure that creates the instance (for lazy instantiation, or custom container logic)
 */
let object1 = ObjectWithDependencies(DependencyClass())















/*:
 ## Property Injection
 - Public setters
 - IBOutlets
 */
var object2 = ObjectWithDependencies()
object2.dependency = DependencyClass()













/*:
 ## Method Injection
 */
var object3 = ObjectWithDependencies()
object3.doStuffWithDependency(DependencyClass())










/*:
 ## DI Containers
 Utilities that provide dependencies.
 */

/*:
 Factory pattern for dependencies.
 */







import SwiftDependencyInjection
import Swinject

// Dependency
protocol Animal {
    var name: String? { get }
}

// Concrete dependency
class Cat: Animal {
    let name: String?

    init(name: String?) {
        self.name = name
    }
}

// Dependency
protocol Person {
    func play()
}

// Concrete dependency
class PetOwner: Person {
    let pet: Animal

    init(pet: Animal) {
        self.pet = pet
    }

    func play() {
        let name = pet.name ?? "someone"
        print("I'm playing with \(name).")
    }
}

// Containers inject dependencies (globally here)
let container = Container()
container.register(Animal.self) { _ in Cat(name: "Mimi") }
container.register(Person.self) { r in
    PetOwner(pet: r.resolve(Animal.self)!)
}

// Dependency container provides concrete dependencies
let person = container.resolve(Person.self)
person?.play()



/*:
 ## Alternative implementations
 - Generics
 - Reflection
 */















/*:
 ## Why does this matter
 - Decoupling
 - Separation of Concerns
 - Testability
 - Fewer Singletons
 - Consistency
 */







/*:
 ## Back to Analytics
 */














/*:
 ## How about testing
 */
class TestOwner: Person {
    let pet: Animal
    
    init(pet: Animal) {
        self.pet = pet
    }
    
    func play() {
        let name = pet.name ?? "someone"
        print("Test passed with \(name).")
    }
}

class TestAnimal: Animal {
    let name: String?
    
    init() {
        self.name = "Test Animal"
    }
}

container.register(Person.self) { r in
    TestOwner(pet: TestAnimal())
}


let testPerson = container.resolve(Person.self)
testPerson?.play()

