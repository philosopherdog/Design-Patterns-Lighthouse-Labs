import UIKit
/*:
## Simple Factory Pattern
*/

/*:
### Programming to Interfaces vs. Implementations
- Before we start on the Simple Factory Pattern we need to establish a few principles of OOP.
- In this first example MasterVC is programming to implementations not interface.
- This means that MasterVC has a dependency on the concrete types DetailVC1 and DetailVC2.
### Open/Closed Principle
- The consequence of programming to concrete objects rather than abstractions is that if we add more view controllers we have to open up MasterVC to add new switch cases.
- This violates what is called the "Open/Closed Principle", which states that
> "software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification"; [Wikipedia](https://en.wikipedia.org/wiki/Open/closed_principle)
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
- Right now MasterVC is dependent on 2 concrete view controller subclasses. This makes MasterVC fragile in the face of change.
- Instead we can make MasterVC dependent on an abstraction/interface.
- By doing this our MasterVC will obey the `Open/Closed Principle`.
- By programming to an interface we are able to use polymorphism. That is, setting `object` on the destination view controller can do different things for each concrete view controller, but the setter is the same regardless of implementation details. MasterVC does not need to know about the details.
*/

// I make a protocol and create a new abstract type
protocol MyData {
  // this is a computed property
  var object: AnyObject?{set get}
}

// Why is MyData's property an optional `AnyObject` here?

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
  var someObject: AnyObject?
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    struct Person {}
    // notice how I'm casting the destination VC as a MyData type!
    if var myData = segue.destination as? MyData {
      myData.object = someObject
    }
  }
}

/*:
 - We can now easily add new view controllers without having to alter anything in MasterVC. MasterVC now obeys the Open/Closed Principle. It does this by 1) programming to an interface not concrete implementations, and by 2) encapsulating what changes.
 */

/*
 
 class DetailVC5: UIViewController, MyData {
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
 */



/*:
## Simple Factory Pattern
- Let's now look at the `Simple Factory Pattern`.
- Demonstrating the problem that Simple Factory is trying to solve.
*/


class CheesePizza: CustomStringConvertible {
  var description: String {
    return "cheese"
  }
  func prepare() { print(#line, "preparing cheese") }
  func cook() { print(#line, "cooking cheese") }
}

class VeggiePizza: CustomStringConvertible {
  var description: String {
    return "veg"
  }
  func prepare() { print(#line, "preparing veg") }
  func cook() { print(#line, "cooking veg") }
}

class MeatLovers: CustomStringConvertible {
  var description: String {
    return "meat"
  }
  func prepare() { print(#line, "preparing meat") }
  func cook() { print(#line, "cooking meat") }
}

class PizzaStore {
  var cheese: CheesePizza?
  var meat: MeatLovers?
  var veg: VeggiePizza?
  func orderPizza(ofType type: String) {
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
store.orderPizza(ofType: "veggie")
store.veg?.cook()
store.veg?.prepare()


/*:
## Problems:
- PizzaStore doesn't obey the Open/Closed Principle. 
- Also, code like this often will include even more conditional code.
- If we need to add new Pizza types or remove existing Pizza types the PizzaStore class will have to be changed every place we have a conditional! 
- We can start to have an explosion of conditional code very easily, and this is always a "Code Smell".
- First of all let's fix some of the worst code repetition in our Pizza types by creating an interface/protocol. So, this way PizzaStore will not be as dependent on concrete Pizza types.
*/

protocol Pizza: CustomStringConvertible {
  var description: String { get }
  func prepare()
  func cook()
  func cost() -> Int
}

class CheesePizza2: Pizza {
  var description: String {
    return "cheese"
  }
  func prepare() { print(#line, "preparing cheese") }
  func cook() { print(#line, "cooking cheese") }
  func cost() -> Int {
    return 10
  }
}
class VeggiePizza2: Pizza {
  var description: String {
    return "veg"
  }
  func prepare() { print(#line, "preparing veg") }
  func cook() { print(#line, "cooking veg") }
  func cost() -> Int {
    return 11
  }
}
class MeatLovers2: Pizza {
  var description: String {
    return "meat"
  }
  func prepare() { print(#line, "preparing meat") }
  func cook() { print(#line, "cooking meat") }
  func cost() -> Int {
    return 14
  }
}

class PizzaStore2 {
  var orderedPizza: Pizza?
  func orderPizza(ofType type: String) {
    switch type {
    case "cheese":
      orderedPizza = CheesePizza() as? Pizza
    case "meat":
      orderedPizza = MeatLovers() as? Pizza
    case "veggie":
      orderedPizza = VeggiePizza() as? Pizza
    default:
      orderedPizza = CheesePizza() as? Pizza
    }
  }
  func cost(for pizza: Pizza) -> Int {
    return pizza.cost()
  }
}

let store2 = PizzaStore2()
store2.orderPizza(ofType: "veggie")
store2.orderedPizza?.prepare()



/*:
- This code is an improvement over our first iteration, but the problem is that the PizzaStore does not obey the Open/Closed Principle.
- Whenever the concrete pizza types change we will have to open this code.
 - The HeadFirst discusses a principle that can help us here:
> **Encapsulate What Varies:** [Software Engineering](https://softwareengineering.stackexchange.com/questions/337413/what-does-it-mean-when-one-says-encapsulate-what-varies)
> Firstly, what does it mean to "encapsule" something, or what is "encapsulation"? [Wikipedia](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming))
> It refers to 2 related but distinct ideas:
 
> 1. "A language mechanism for restricting direct access to some of the object's components."
> 2. "A language construct that facilitates the bundling of data with the methods (or other functions) operating on that data."

- We want to concentrate on the second definition of "encapsulate".
- We can solve our problem by moving the creation code, which can and will change outside the Store class into its own class.
- This is called a "Simple Factory" class. 
- It's only job is to create concrete Pizza objects and return them as generic Pizza objects.
![](fact.png)
*/

final class SimplePizzaFactory {
  func createPizza(of type: String) -> Pizza {
    switch type {
    case "cheese":
      return CheesePizza2() as Pizza
    case "meat":
      return MeatLovers2() as Pizza
    case "veggie":
      return VeggiePizza2() as Pizza
    default:
      return CheesePizza2() as Pizza
    }
  }
}

class PizzaStore3 {
  internal var orderedPizza: Pizza?
  private let _factory: SimplePizzaFactory
  init(factory: SimplePizzaFactory) {
    self._factory = factory
  }
  internal func orderPizza(ofType type: String) {
    orderedPizza = _factory.createPizza(of: type)
  }
  internal func cost(for pizza: Pizza) -> Int {
    return pizza.cost()
  }
}

let store3 = PizzaStore3(factory: SimplePizzaFactory())
store3.orderPizza(ofType: "veggie")
store3.orderedPizza?.prepare()
store3.orderedPizza?.cook()

/*:
- Notice PizzaStore3 now obeys the Open/Closed Principle.
- We can easily add or remove Pizza types.
- The goal of this pattern is to separate the creation of the objects from the client that uses those objects.
- This way changes to the creation code will leave the client unaffected.
- By injecting the factory into the PizzaStore initializer we could pass in a dummy factory for unit testing. We could also create other factories and change them at run time if needed.
- This is called "Dependency Injection". You pass in the dependencies rather than inialize them internally.
![](uml_simple_fact.png)
*/

/*: 
### Summary:
- Open/Closed
- Programming to an interface rather than to concrete details.
- Encapsulate what changes, that is move what changes into its own class so that you limit the disruption that change can cause.
*/













