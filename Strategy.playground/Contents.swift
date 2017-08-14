import UIKit

/*:
 ## The Strategy Pattern
 - I'm using the HeadFirst "SimUDuck" app example to illustrate the Strategy Pattern.
 - SimUDuck models a bunch of different sub-types of ducks that swim and quack in ways unique to their sub-type.
 
 ![](sim.png)
 
 ## SimUDuck the Class Inheritance Way
 
 - We will start by using class inheritance to model this so we can understand some of the problems with class inheritance that strategy addresses.
 - We will start with just the `quack()`, and `swim()` behaviours, and add `fly()` later.
 - The `Duck` super class will give us default implementations of `quack()` and `swim()`.
 - Why is inheriting the Duck super class's implementation a good thing?
 */

class Duck: CustomStringConvertible {
  
  // abstract: no implementation
  var description: String {
    fatalError()
  }
  
  func quack() {
    print(#line, "quackin!")
  }
  
  func swim() {
    print(#line, "swimin!")
  }
  
  //   func fly() {
  //   print(#line, "flyin!")
  //   }
  
}

class MallardDuck: Duck {
  override var description: String {
    return "mallard duck"
  }
  func mallardSpecific() {
    print(#line, #function)
  }
}

class RubberDuck: Duck {
  override var description: String {
    return "rubbery duck"
  }
  
  override func quack() {
    print(#line, "squeak")
  }
  
  override func swim() {
    print(#line, "kinda floats")
  }
  
  func rubberSpecific() {
    print(#line, #function)
  }
  
  //    override func fly() {
  //
  //    }
}

class DecoyDuck: Duck {
  override var description: String {
    return "decoy duck"
  }
  
  override func quack() {
    // overrides and does nothing. violates Interface Segregation Principle (ISP). More on this below.
  }
  
  override func swim() {
    // same as rubber duck
    print(#line, "kinda floats")
  }
  
  func decoySpecific() {
    print(#line, #function)
  }
  
  //    override func fly() {
  //      // does nothing same as rubber duck
  //    }
}

let duck: Duck = DecoyDuck()
duck.description
duck.quack() // doesn't do anything


/*:
 - The first problem is only Mallard in our example uses the default implementation of `quack()` and `swim()`.
 - When we start overriding most of the methods most of the time we're getting very little benefit from inheritance, especially if our override does nothing (see Decoy's Quack, and Rubber's fly method)
 > _Interface Segregation Principle_: For a class to depend on methods it doesn't use, violates the [Interface Segregation Principle](https://en.wikipedia.org/wiki/Interface_segregation_principle)). If our class depends on a method it doesn't even use then this means changes to the super class's method signature could be breaking for our subclass even though it doesn't actually use the behavior! We want to avoid being dependent on a method we don't even use.
 - Instead of using inheritance we could use composition and only add the behavior(s) our concrete class needs. (We will see this in the next refactoring)
 
 > ### Prefer Composition Over Inheritance
 > "Composition over inheritance (or composite reuse principle) in object-oriented programming is the principle that classes should achieve polymorphic behavior and code reuse by their composition (by containing instances of other classes that implement the desired functionality) rather than inheritance from a base or parent class." [wikipedia](https://en.wikipedia.org/wiki/Composition_over_inheritance)
 - Another problem is that the more we override methods in subclasses the less we are able to gain knowledge of all ducks by looking at the super class.
 - Also, we can't really change behaviour at run time. Our design is static.
 - If we add another behaviour `fly()` we have to open and edit every subclass that overrides the default behaviour.
 - In a complex app this might be daunting and introduce new bugs.
 - Having to open all of these subclasses to add extend their functionality violates a principle called the `Open/Closed Principle`.
 
 > ### Open/Closed Principle Again:
 > "software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification" [wikipedia](https://en.wikipedia.org/wiki/Open/closed_principle)
 
 - So, we would like our Ducks to be able to add new functionality without having to modify them.
 */

/*:
 ### Attempting to Solve These Problems the Interface/Protocol Way
 
 ![](separate.png)
 
 - Just like Factory, we want to "Encapsulate What Varies".
 
 > "Take the parts that vary and encapsulate them, so that later you can alter or extend the parts that vary without affecting those that don’t."
 
 - *"Encapsulating What Varies"* is a basic principle that lies at the root of most design patterns.
 - We want "some part of the system to be able to vary/change independently of other parts".
 - The simplest attempt at doing this is to move the behaviour that changes out and into a protocol or interface.
 - This way each class can conform to the protocol and implement its own fly, swim or quack behaviour.
 - If a particular Duck sub-type lacks a behaviour, say it can't fly, then it simply won't conform to the Flyable protocol.
 - Alternatively we could make a particular protocol method optional. (Prefer not to make protocol methods optional).
 
 ![](protocol.png)
 
 */

/*:
 ### The Attempted Solution Using Interfaces
 */

protocol Flyable {
  func fly()
}

protocol Swimable {
  func swim()
}

protocol Quackable {
  func quack()
}

// All Concrete Ducks implement description so we add it to a superclass, we could also just make each Ducks subtype conform.

class Duck2: CustomStringConvertible {
  
  // abstract: no implementation
  var description: String {
    fatalError()
  }
}


class MallardDuck2: Duck2, Flyable, Swimable, Quackable {
  
  override var description: String {
    return "mallard duck"
  }
  
  func mallardSpecific() {
    print(#line, #function)
  }
  
  func fly() {
    print(#line, "flyin")
  }
  
  func swim() {
    print(#line, "swimin")
  }
  
  func quack() {
    print(#line, "quackin")
  }
}

// The CanadianGooseDuck2 class is almost identifical to Mallard! This points to a serious problem with the pure interface solution. What is the problem?

class CanadianGooseDuck2: Duck2, Flyable, Swimable, Quackable {
  
  override var description: String {
    return "mallard duck"
  }
  
  func canadianSpecific() {
    print(#line, #function)
  }
  
  func fly() {
    print(#line, "flyin")
  }
  
  func swim() {
    print(#line, "swimin")
  }
  
  func quack() {
    print(#line, "quackin")
  }
}

// RubberDuck2 doesn't Fly; so no Flyable conformance. Benefit.
class RubberDuck2: Duck2, Swimable, Quackable {
  
  override var description: String {
    return "rubbery duck"
  }
  
  func rubberSpecific() {
    print(#line, #function)
  }
  
  func quack() {
    print(#line, "squeak")
  }
  
  func swim() {
    print(#line, "kinda floats")
  }
}

// DecoyDuck2 neither Flys nor Quacks
class DecoyDuck2: Duck2, Swimable  {
  
  func decoySpecific() {
    print(#line, #function)
  }
  
  override var description: String {
    return "decoy duck"
  }
  
  func swim() {
    // same as rubber duck
    print(#line, "kinda floats?")
  }
}

/*:
 - This solution solves our problem by making our subclasses composed of behaviors.
 - We are composing our objects from protocols rather than inheriting behavior.
 - If a particular Duck sub-type doesn't have a behavior, it doesn't conform to the protocol!
 - But this solution comes with a serious problem. It violates *DRY* (Do Not Repeat Yourself).
 - This would be a maintenance nightmare.
 - Recall that one of the main points of class inheritance is to save us from code repetition. But strategy points out a serious problem, namely that sometimes we don't want the behavior.
 - Also, inheriting behavior locks us in at compile time. What if we want to write a game in which when we have enough points our decoy duck can fly! Class inheritance doesn't give us runtime dynamism.
 - In Swift 3 we do have "protocol extensions" that could help make code repetition less of a problem for some cases.
 */


// Example of Protocol Extension
protocol Powers {
  var rocketCount: Int { get }
  var shield: Bool { get }
}

// Default implementation!
extension Powers {
  var rocketCount: Int {
    return 10
  }
  var shield: Bool {
    return false
  }
}

// Character instances get the default implementation of `rocketCount`, and `shield`
class Character: Powers {}

// PowerfulCharacter instances override the default implementation
class PowerfulCharacter: Powers {
  var rocketCount: Int {
    return 100
  }
  var shield: Bool {
    return true
  }
}

let c1 = Character()
let c2 = PowerfulCharacter()
c1.rocketCount
c1.shield
c2.rocketCount
c2.shield

/*:
 ### Strategy Pattern Way
 - For most simple cases using protocols and extensions would probably be a reasonable solution. But we're learning the strategy pattern!
 - The Strategy Pattern is similar to the protocol way except that we create classes/strucks that provide various implementations of the behaviours rather than locking the implementation of the protocols inside the Duck subclasses or using protocol extensions, which is too limited for more complex cases.
 - We can now compose the Duck subclasses of specific concrete implementations of the protocols.
 */

// Reminder of the protocols defined above

// protocol Flyable {
// func fly()
// }
//
// protocol Swimable {
// func swim()
// }
//
// protocol Quackable {
// func quack()
// }

class FlyinHigh: Flyable {
  func fly() {
    print(#line, "flyin high")
  }
}

class CantFly: Flyable {
  func fly() {
    print(#line, "can't fly")
  }
}

class Swimmer: Swimable {
  func swim() {
    print(#line, "swimin")
  }
}

class Floater: Swimable {
  func swim() {
    print(#line, "floatin")
  }
}


class Quacker: Quackable {
  func quack() {
    print(#line, "quack quack")
  }
}

class Squeaker: Quackable {
  func quack() {
    print(#line, "squeak squeak")
  }
}

class Duck3: CustomStringConvertible {
  var soundBehavior: Quackable?
  var waterBehavior: Swimable?
  var airBehavior: Flyable?
  
  // It doesn't make sense to make the description method a strategy unless some duck sub-types implement the same description. Here is is an abstract computed property.
  var description: String {
    fatalError()
  }
}

// Notice how the subclasses just do stuff specific to their subclass
class MallardDuck3: Duck3 {
  override var description: String {
    return "mallard duck"
  }
  func mallardSpecific() {
    print(#line, #function)
  }
}


class RubberDuck3: Duck3 {
  override var description: String {
    return "rubbery duck"
  }
  
  func rubberSpecific() {
    print(#line, #function)
  }
}

class DecoyDuck3: Duck3  {
  override var description: String {
    return "decoy duck"
  }
  
  func decoySpecific() {
    print(#line, #function)
  }
}

let mallard: Duck3 = MallardDuck3()
mallard.airBehavior = FlyinHigh() // flyable
mallard.waterBehavior = Swimmer() // swimable
mallard.soundBehavior = Quacker() // quackable

mallard.soundBehavior?.quack()
mallard.airBehavior?.fly()
mallard.waterBehavior?.swim()

let decoy: Duck3 = DecoyDuck3()
decoy.airBehavior = CantFly()
decoy.waterBehavior = Floater()

decoy.soundBehavior?.quack()
decoy.airBehavior?.fly()
decoy.waterBehavior?.swim()

let rubber: Duck3 = RubberDuck3()
rubber.airBehavior = CantFly()
rubber.waterBehavior = Floater()
rubber.soundBehavior = Squeaker()

rubber.soundBehavior?.quack()
rubber.airBehavior?.fly()
rubber.waterBehavior?.swim()

/*
- *Notice: We can add a new rocket power to fly without violating the Open/Closed Principle*.
- This means we don't need to touch any of the Duck sub-types to make the change.
*/


class RockPowered: Flyable {
  func fly() {
    print(#line, "blast off!")
  }
}

// We can change Rubber Duck at run time to give it extra powers!
rubber.airBehavior = RockPowered()
rubber.airBehavior?.fly()

/*:
 - The Strategy Pattern has a bunch of major advantages.
 - One thing is that we can see everything that's happening by looking at the superclass Duck3, which shows how our object are composed of (optional) behaviours that are cast to their interfaces but are actually concrete implementations.
 - We can dynamically switch behaviours at run time, which makes our code dynamic.
 - We were able to add new fly behaviors without violating the Open/Closed Principle. We never had to touch the sub-type of the super-types code to add new behaviors.
 - Also, we don't violate DRY because protocol implementations can be reused.
 - Finally our code is more reusable. Any other class could theortically use our behaviors!
 
 ![](def.png)
 
 */




















