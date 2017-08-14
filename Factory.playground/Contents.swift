import UIKit
/*:
 ## Simple Factory Pattern
 */

/*:
 ### Programming to Interfaces vs. Implementations
 - Before we start on the Simple Factory Pattern we need to establish a few principles of OOP.
 - In this first example MasterVC is programming to implementations not to an interface.
 - This means that MasterVC has a dependency on the concrete types DetailVC1 and DetailVC2.
 - This is not what we want!
 
 ### Open/Closed Principle
 - The consequence of programming to concrete objects rather than abstractions is that if we add more view controllers we have to open up MasterVC to add new switch cases.
 - This violates what is called the "Open/Closed Principle", which states that
 
 > "software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification"; [Wikipedia](https://en.wikipedia.org/wiki/Open/closed_principle)
 
 ### Polymorphism
 - The other consequence of programming to concrete objects is that we can't take advantage of Polymorphism.
 > Polymorphism allows you to use the same interface for different underlying concrete objects.
 > A good analogy for polymorphism is a button which you can tap or click. All buttons share the same interface (click/tap). But buttons do different things depending on the situation/app. If buttons were not polymorphic they would be next to useless.
 */

class DetailVC1: UIViewController {
  var myObject: AnyObject?
}

class DetailVC2: UIViewController {
  var mySpecialObject: AnyObject?
}

class MasterVC: UIViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    struct Person {}
    struct Employee {}
    if segue.identifier == "DetailVC1" {
      let dvc = segue.destination as! DetailVC1
      dvc.myObject = Person() as AnyObject
    }
    if segue.identifier == "DetailVC2" {
      let dvc = segue.destination as! DetailVC2
      dvc.mySpecialObject = Employee() as AnyObject
    }
    // if we add more then we have to add more switch cases
  }
}


/*:
 - Right now MasterVC is dependent on 2 concrete view controller subclasses DetailVC1 & 2. This makes MasterVC fragile in the face of change.
 - Instead let's make MasterVC dependent on an abstraction or interface so that we can practice the principle of programming to an interface rather than an implementation.
 - By doing this our MasterVC will obey the `Open/Closed Principle`.
 - Our MasterVC will talk to it's dependent children polymorphically. It doesn't need to know any concrete details.
 - That is, setting `object` on the destination view controller can do different things for each concrete view controller, but the setter is the same regardless of implementation details. MasterVC does not need to know about the details.
 */

// I make a protocol and create a new abstract type
protocol MyData {
  // this is a computed property.
  var object: AnyObject? {set get}
}

class DetailVC3: UIViewController, MyData {
  private var _object: AnyObject?
  var object: AnyObject? {
    set {
      _object = newValue
    }
    get {
      return _object
    }
  }
}

class DetailVC4: UIViewController, MyData {
  private var _object: AnyObject?
  var object: AnyObject? {
    set {
      _object = newValue
    }
    get {
      return _object
    }
  }
}

class MasterVC2: UIViewController {
  var someObject: AnyObject? // this could be set somewhere in the code to a Person or Employee instance
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // notice how I'm casting the destination VC as a MyData type!
    if var myData = segue.destination as? MyData {
      myData.object = someObject
    }
  }
}

/*:
 - We can now easily add new view controllers without having to alter anything in MasterVC.
 - MasterVC now programs to an interface not an implementation, obeys the Open/Closed Principle, and uses polymorphism to talk to its children! Pretty cool.
 */


// Adding new controllers can be done without changing MasterVC

//class DetailVC5: UIViewController, MyData {
//  private var _object: AnyObject?
//  var object: AnyObject? {
//    set {
//      _object = newValue
//    }
//    get {
//      return _object
//    }
//  }
//}




/*:
 ## Simple Factory Pattern
 - Let's start by demonstrating the problem that Simple Factory is trying to solve.
 */


class CheesePizza: CustomStringConvertible {
  var description: String {
    return "cheese"
  }
  func prepare() { print(#line, "preparing", description) }
  func cook() { print(#line, "cooking", description) }
}

class VeggiePizza: CustomStringConvertible {
  var description: String {
    return "veg"
  }
  func prepare() { print(#line, "preparing", description) }
  func cook() { print(#line, "cooking", description) }
}

class MeatLovers: CustomStringConvertible {
  var description: String {
    return "meat"
  }
  func prepare() { print(#line, "preparing", description) }
  func cook() { print(#line, "cooking", description) }
}

class PizzaStore {
  var cheese: CheesePizza?
  var meat: MeatLovers?
  var veg: VeggiePizza?
  
  func orderPizza(of type: String) {
    switch type {
    case "cheese":
      cheese = CheesePizza()
    case "meat":
      meat = MeatLovers()
    case "veggie":
      veg = VeggiePizza()
    default:
      cheese = CheesePizza()
    }
  }
  
  func computeCost()-> Int {
    var total = 0
    if cheese != nil {
      total += 10
    }
    if meat != nil {
      total += 12
    }
    if veg != nil {
      total += 13
    }
    return total
  }
}

let store = PizzaStore()
let type = "veggie"
store.orderPizza(of: type)
store.veg?.cook()
store.veg?.prepare()


/*:
 ## Some Problems With This Code:
 - PizzaStore is dependent on concrete Pizza types.
 - So, PizzaStore doesn't obey the Open/Closed Principle.
 - Our concrete Pizza types share the same public methods. But there's nothing enforcing that future Pizza types will be able handle certain messages.
 - Also, code like this usually needs to create switch cases in many other methods.
 - If we need to add new Pizza types or remove Pizza types the PizzaStore class will have to be changed every place we have a conditional!
 - We can start to have an explosion of conditional code very easily.
 - Conditional code like this is hard to understand, hard extend, hard to maintain. It's a mess!
 - First of all, let's fix some of the worst code repetition in our Pizza types by creating an interface/protocol. This way PizzaStore will not be as dependent on concrete Pizza types, but rather will be dependent on an abstract interface/protocol.
 */

protocol PizzaProtocol: CustomStringConvertible {
  var description: String { get }
  func prepare()
  func cook()
  func cost() -> Int
}

class CheesePizza2: PizzaProtocol {
  var description: String {
    return "cheese"
  }
  func prepare() { print(#line, "preparing", description) }
  func cook() { print(#line, "cooking", description) }
  func cost() -> Int {
    return 10
  }
}
class VeggiePizza2: PizzaProtocol {
  var description: String {
    return "veg"
  }
  func prepare() { print(#line, "preparing", description) }
  func cook() { print(#line, "cooking", description) }
  func cost() -> Int {
    return 11
  }
}
class MeatLovers2: PizzaProtocol {
  var description: String {
    return "meat"
  }
  func prepare() { print(#line, "preparing", description) }
  func cook() { print(#line, "cooking", description) }
  func cost() -> Int {
    return 14
  }
}

class PizzaStore2 {
  var orderedPizza: PizzaProtocol?
  func orderPizza(of type: String) {
    switch type {
    case "cheese":
      orderedPizza = CheesePizza() as? PizzaProtocol
    case "meat":
      orderedPizza = MeatLovers() as? PizzaProtocol
    case "veggie":
      orderedPizza = VeggiePizza() as? PizzaProtocol
    default:
      orderedPizza = CheesePizza() as? PizzaProtocol
    }
  }
  func cost(for pizza: PizzaProtocol) -> Int {
    return pizza.cost()
  }
}

let store2 = PizzaStore2()
let cheeseType = "cheese"
store2.orderPizza(of: cheeseType)
store2.orderedPizza?.prepare()



/*:
 - This code is an improvement over our first version, but the problem is that the PizzaStore still does not obey the Open/Closed Principle.
 - This is because the PizzaStore needs to have knowledge of concrete Pizza types.
 - Whenever the concrete pizza types change we will have to open this code.
 - HeadFirst discusses a principle that can help us here:
 > **Encapsulate What Varies:** [Software Engineering](https://softwareengineering.stackexchange.com/questions/337413/what-does-it-mean-when-one-says-encapsulate-what-varies)
 > Firstly, what does it mean to "encapsule" something, or what is "encapsulation"? [Wikipedia](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming))
 > It refers to 2 related but distinct ideas:
 
 > 1. "A language mechanism for restricting direct access to some of the object's components."
 > 2. "A language construct that facilitates the bundling of data with the methods (or other functions) operating on that data."
 
 - We are referring to the second definition of "encapsulate" here.
 - We can solve our problem by moving the creation code, which can and will change, outside the PizzaStore class and into its own class.
 - This solution is sometimes called a "Simple Factory" pattern.
 - It's only job is to create concrete Pizza objects and return them upcasted to an abstract Pizza type.
 
 ![](fact.png)
 */

final class SimplePizzaFactory {
  func createPizza(of type: String) -> PizzaProtocol {
    switch type {
    case "cheese":
      return CheesePizza2()
    case "meat":
      return MeatLovers2()
    case "veggie":
      return VeggiePizza2()
    default:
      return CheesePizza2()
    }
  }
}

class PizzaStore3 {
  internal var orderedPizza: PizzaProtocol?
  private let _factory: SimplePizzaFactory
  init(factory: SimplePizzaFactory) {
    self._factory = factory
  }
  internal func orderPizza(of type: String) {
    orderedPizza = _factory.createPizza(of: type)
  }
  internal func cost() -> Int? {
    return orderedPizza?.cost()
  }
}

let store3 = PizzaStore3(factory: SimplePizzaFactory())
let vegType = "veggie"
store3.orderPizza(of: vegType)
store3.orderedPizza?.prepare()
store3.orderedPizza?.cook()
store3.cost()

/*:
 - Notice PizzaStore3 now obeys the Open/Closed Principle.
 - We can easily add or remove Pizza types without impacting the PizzaStore.
 - The goal of this pattern is to separate the creation of the objects from the client (PizzaStore) that uses those objects.
 - This way changes to the creation code will leave the client unaffected.
 - By "injecting" the factory into the PizzaStore initializer we could pass in a dummy factory for unit testing. We could also create other factories and change them at run time if needed, but to do so we may want to expose the factory property. What else would we need to do?
 - Passing the Factory into the PizzaStore's initializer or assigning it to the factory property from outside is called "Dependency Injection".
 - Dependency injection contrasts with initializing the factory internally, like, inside the initializer.
 - An analogy of Dependency Injection might be something like the difference between growing your own vegetables and having vegetables delivered to your door. What's the difference?
 
 ![](uml_simple_fact.png)
 */

/*:
 ### Summary:
 - Open/Closed Principle.
 - Programming to an interface rather than to concrete details.
 - Using Polymorphism.
 - Encapsulate what changes. That is, move what changes into its own class so that you limit the disruption that change can cause.
 */


/*:
 
 # Factory Method Design Pattern
 
 - So far we have just looked at the simple factory. This is probably the most useful and common, but some people claim it isn't officially a pattern.
 - The Factory Method shares the idea that it doesn't have a concrete dependency on the created object. Just like the Simple Factory, Factory Method depends on the create object through an abstraction, like a protocol or super class.
 - Remember Simple factory has a reference to the concrete factory instance which, in our example was responsible for creating the concrete pizzas and returning them to the PizzaStore as abstract Pizza objects.
 
 ![](simple2.png)
 
 # Factory Method Pattern
 
 > "Defines an interface for creating an object, but let subclasses decide which class to instantiate. The Factory method lets a class defer instantiation it uses to subclasses." (Gang Of Four)
 
 - Most examples of the Factory Pattern that you find online confuse the Simple Factory for other types of factories.
 - The Factory Method Pattern is a distinct pattern, and it is easily confused with the Simple Factory.
 - The main difference is that the client doesn't have a reference to a concrete factory. Rather it has a reference to an abstract factory instead.
 
 ![](method.png)
 
 - This allows us to make run time decisions as to which factory to instantiate.
 - Let's consider a couple of different ways of doing this.
 
 
 */

// Product (I could have used a class)
protocol HomeInternetService {
  var speed: Int {get}
  func cost()-> Double
}

// Protocol extensions allow us to provide a default implementation
extension HomeInternetService {
  var speed: Int {
    return 30
  }
}

class BabyService: HomeInternetService {
  func cost()-> Double {
    return 40
  }
}

class PowerUserService: HomeInternetService {
  var speed: Int {
    return 60
  }
  func cost()-> Double {
    return 55
  }
}

// Factories
class ISPFactory {
  var service: HomeInternetService
  init(serviceType: String) {
    switch serviceType {
    case "Baby":
      self.service = BabyService()
    case "Power":
      self.service = PowerUserService()
    default:
      self.service = BabyService()
    }
  }
  func cost()-> Double {
    return service.cost()
  }
}

final class MontrealFactory: ISPFactory {
  // 10% cheaper in Montreal for PowerUsers
  override func cost() -> Double {
    var cost = super.cost()
    if service is PowerUserService {
      cost += cost * -0.10
    }
    return cost
  }
}

final class OntarioFactory: ISPFactory {
  // it gets the default cost for all packages
}

let montrealFactory =  MontrealFactory(serviceType: "Power") as ISPFactory
montrealFactory.cost()
montrealFactory.service.speed


let ontarioFactory = OntarioFactory(serviceType: "Power") as ISPFactory
ontarioFactory.cost()
ontarioFactory.service.speed

















