import UIKit

/*:
# Decorator Pattern

#### Model Order System For a Coffee Shop
![](coffee.png)
*/

/*:
##### Our First Attempt
*/
class Beverage: CustomStringConvertible {
  // these method are both abstract
  var description: String {
    fatalError()
  }
  func cost()-> Double {
    fatalError()
  }
}

class HouseBlend: Beverage {
  override var description: String {
    return "House"
  }
  override func cost() -> Double {
    return 0.99
  }
}

class DarkRoast: Beverage {
  override var description: String {
    return "Dark"
  }
  override func cost() -> Double {
    return 1.29
  }
}

class Decaf: Beverage {
  override var description: String {
    return "Decaf"
  }
  override func cost() -> Double {
    return 1.00
  }
}

class Espresso: Beverage {
  override var description: String {
    return "Espresso"
  }
  override func cost() -> Double {
    return 1.99
  }
}

// Problems: There are potentially many variants if we start to take into account condiment

class HouseBlendWithSteamedMilkAndMocha: HouseBlend {
  override func cost() -> Double {
    return super.cost() + 0.10 + 0.50
  }
}

class HouseBlendWithWhipAndMilk: HouseBlend {
  override func cost() -> Double {
    return super.cost() + 1.00 + 0.10
  }
}

let houseWithWhipAndMilk = HouseBlendWithWhipAndMilk()
houseWithWhipAndMilk.cost()

/*:
* This approach produces a "class explosition" 💥 with potentially infinite combinations.
* Adding new beverages or condiments would definitely violate the Open/Closed Principle.

![](class_expl.png)
*/

/*:
### Attempted Redesign Using Properties on the Beverage Class To Track Beverage Options.
*/

class Beverage2: CustomStringConvertible {
  
  var milk: Bool?
  var soy: Bool?
  var mocha: Bool?
  var whip: Bool?
  // we would need a lot more
  
  var description: String {
    var result = ""
    if milk == true {
      result += "milk "
    }
    if soy == true {
      result += "soy "
    }
    if mocha == true {
      result += "mocha "
    }
    if whip == true {
      result += "whip "
    }
    return result.trimmingCharacters(in: .whitespaces)
  }
  
  func cost()-> Double {
    var cost = 0.0
    if milk == true {
      cost += 0.10
    }
    if soy == true {
      cost += 0.60
    }
    if mocha == true {
      cost += 1.00
    }
    if whip == true {
      cost += 1.00
    }
    return cost
  }

}

class HouseBlend2: Beverage2 {
  
  override var description: String {
    return "House" + (super.description.characters.count > 0 ? " with \(super.description)" : "")
  }
  
  override func cost() -> Double {
    return super.cost() + 0.99
  }
}

let house = HouseBlend2()
house.milk = true
house.whip = true
house.cost()
house.description

/*:
- This solution violates the Open/Closed Principle.
- We end up with these huge switch statements in order to compute the cost.
- Since we may also have double, triple, etc. condiments we would have to track this too!
- Some condiments are inappropriate for some beverages, like tea. We will either have to still test teas for all of these condiments or add some kind of complex conditional logic.
- This design is neither flexible nor maintainable. 🍝
- What we want is a design that allows us to create a composite beverage object that can in theory have any number of condiments for which we can compute the cost.
- We will do this using the *decorator pattern*.

![](redesign.png)

*/

/*:
### Decorator Pattern
![](dec_def.png)
![](dec_uml.png)
[Wikipedia](https://en.wikipedia.org/wiki/Decorator_pattern)
*/
// Component
protocol BeverageProtocol: CustomStringConvertible {
  var description: String { get }
  func cost()-> Double
}

// Concrete Components
class HouseBlend3: BeverageProtocol {
  var description: String {
    return "House Blend"
  }
  func cost() -> Double {
    return 0.89
  }
}

class Espresso3: BeverageProtocol {
  var description: String {
    return "Espresso"
  }
  func cost() -> Double {
    return 1.99
  }
}


class BeverageDecorator: BeverageProtocol {
  let beverage: BeverageProtocol
  
  init(beverage: BeverageProtocol) {
    self.beverage = beverage
  }
  
  // protocol conformance
  func cost() -> Double {
    return beverage.cost()
  }
  
  var description: String {
    return beverage.description
  }
}

/*:
 - BeverageDecorator has-a beverage property (it is composed of a beverage) and is-a beverage (implements the Beverage protocol).
 - So, what the decorator does is asks the concrete component that it wraps to implement the component method (cost() in our case).
 - This is the key to the decorator pattern.
 - The decorator implements `cost()` and `description()` from the BeverageProtocol. The same as the concrete beverages do.
 - But the condiment decorators require an instance that implements Beverage to be passed in at initialization.
 - This could be either a concrete beverage, or a decorator, since both satisfy the protocol type!
 - Notice we need the super class BeverageDecorator to avoid repeating the beverage property and initializer in all concrete decorators. All decorators will subclass this super class.
 */

class MilkDecorator: BeverageDecorator {
  
  override var description: String {
    return super.description + " milk"
  }
  
  override func cost() -> Double {
    return 0.10 + super.cost()
  }
}

// If we didn't have the BeverageDecorator super class we would have to do the concrete decorators like this:

//class MilkDecorator: Beverage3 {
//  
//  let beverage: Beverage
//  
//  init(beverage: Beverage) {
//    self.beverage = beverage
//  }
//  
//  var description: String {
//    return beverage.description + " milk"
//  }
//  
//  func cost() -> Double {
//    return 0.10 + beverage.cost()
//  }
//}

class MochaDecorator: BeverageDecorator {
  
  override var description: String {
    return super.description + " mocha"
  }
  
  override func cost() -> Double {
    return 0.50 + super.cost()
  }
}

// Has no condiments
let espresso = Espresso3()
espresso.description
espresso.cost()

// Has 1 condiment
let house3 = HouseBlend3()
let milk3 = MilkDecorator(beverage: house3)
milk3.description
milk3.cost()

// Adding a double mocha to the house!
let mocha = MochaDecorator(beverage: milk3)
let moreMocha = MochaDecorator(beverage: mocha)
moreMocha.description
moreMocha.cost()

/*:
- The cost method is actually computed using recursion.
- The outer wrapped beverage asks its beverage for its cost computation, and it asks its beverage for the same thing until we reach a concrete beverage.
- The decorator is an OO implementation of which data structure?
![](cost.png)
*/
