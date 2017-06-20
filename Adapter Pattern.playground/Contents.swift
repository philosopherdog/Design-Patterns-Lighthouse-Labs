import UIKit

/*:
![](outlet.png)

- Let's consider the case of a real world outlet adapter.
- The adapter sits in between an outlet and our laptop's plug.
- Let's assume they are incompatible since we are traveling to Europe.
- It would be rediculous for us to either re-wire every outlet we need to plug our laptop in while in Europe, or cut the plug off our laptop and solder in a compatible one!
- Besides being inconvenient, expensive and possibly dangerous, our laptop might still be incompatible since some countries have different voltages.
- Obviously it would be much smarter for us to use an adapter, which doesn't require us to change anything about the wall outlet or our laptop.
- Software adapters do the same thing as real world ones, they take two incompatible API's and make them compatible without altering either API. 
- There is no need to re-write existing code to make it work.
- The adapter acts as a "middleman". It receives requests from the client and converts them into the requests appropriate for the vending class.

![](adap1.png)

![](adap2.png)

![](adap3.png)

*/


protocol Duck {
  func quack()
  func fly()
}

class Mallard: Duck {
  func quack() {
    print(#line, "quack!")
  }
  func fly() {
    print(#line, "flyin high!")
  }
}

protocol Turkey {
  func gobble()
  func fly()
}


class WildTurkey: Turkey {
  func gobble() {
    print(#line, "gobble gobble")
  }
  func fly() {
    print(#line, "I'm flying a short distance")
  }
}

/*:
- Let's say we want to use some Turkey objects where our program expects Ducks.
- We can't use Turkey objects in place of Ducks because they implement a different interface.
- To solve this we can create a TurkeyAdapter which wraps the Turkey object in the Duck interface.
*/

// We will wrap the Turkey in the Duck protocol
class TurkeyAdapter: Duck {
  // The adapater wraps the underlying object so that it can route the expected calls to the underlying API.
  let turkey: Turkey
  
  init(with turkey: Turkey) {
    self.turkey = turkey
  }
  
  func quack() {
    turkey.gobble()
  }
  
  func fly() {
    (0..<5).map{_ in turkey.fly()} // flies 5 times. this is like the wall adapter that changes the voltage.
  }
}


let mallard:Duck = Mallard()

let turkey = WildTurkey()
let turkeyAdapter = TurkeyAdapter(with: turkey)

// Notice the test method which is the client that consumes our objects takes only Ducks.

func test(with duck: Duck) {
  duck.fly()
  duck.quack()
}

test(with: mallard)
test(with: turkeyAdapter)

/*:
![](summary.png)
*/

/*:
![](def.png)
*/

/*:
- The Adapter Pattern allows us to use a client with an imcompatible interface by creating an intermediate object that handles both the conversion and is of a compatible type.
- We encapsulate what changes into an Adapter class.
- Our client code is better able to extend, modify, and adapt to changes without having to anticipate all of those changes and over engineer the class at its inception. 
- The Adapter makes our client code Open for extension but closed to modification.
- The Adapter Pattern is related to the Decorator Pattern, but they are quite different.
- The Adapter changes the interface of an object by wrapping it and it manages routing calls from the new interface to the old.
- The Decorator doesn't change the interface of an object it iteratively wraps an object to add more implementations of the methods defined in the shared interface.
- There is another Pattern Related to the Adapter called the Facade. This pattern makes an interface simpler. Let's have a quick look at that one next.
*/













