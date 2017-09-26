//: Playground - noun: a place where people can play

import UIKit
import SwiftDependencyInjection
import Swinject






protocol Animal {
    var name: String? { get }
}

class Cat: Animal {
    let name: String?
    
    init(name: String?) {
        self.name = name
    }
}

protocol Person {
    func play()
}

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

let container = Container()
container.register(Animal.self) { _ in Cat(name: "Mimi") }
container.register(Person.self) { r in
    PetOwner(pet: r.resolve(Animal.self)!)
}

let person = container.resolve(Person.self)
person?.play()
