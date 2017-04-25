import UIKit

/*:
![](outlet.png)

- A real world adapter sits in between an outlet whose structure is not easily changeable, and the appliance you want to plug in.
- It would be rediculous if we had to get cut off the cable on our laptop and wire in a new one, or alternately remove the outlet from the wall and wire in a new one just to watch netflix!
- BTW, some adapters just change the shape of the plug, some actually adjust the voltage.
- Software adapters do the same thing as real world ones, they take a piece of software (class, protocol/interface, api) whose interface is incompatible with existing code and adapt it to an interface the client code is expecting. So, we don't need to rewrite our code to make it work.
- The adapter acts as a middleman. It receives requests from the client and converts them into the requests appropriate for the vending class.

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
- So what we have to do is create a TurkeyAdapter that wraps the Turkey object in the Duck interface.
*/


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
### Exercise:
- Let's make the Mallard Duck adapt to the Turkey interface
- We want to be able to call a test method that takes turkeys and be able to pass a Duck to this method:
*/


func test(with turkey: Turkey) {
  turkey.gobble()
  turkey.fly()
}

/*:
![](def.png)
*/

/*:
- The Adapter Pattern allows us to use a client with an imcompatible interface by creating an intermediate object that handles both handles the conversion and is of a compatible type.
- The class that consumes an API/Interface (the client) can be decoupled from changes to that interface. 
- We encapsulate what changes into an Adapter class.
- Our client code is better able to extend, modify, and adapt to changes without having to anticipate all of those changes and over engineer the class at its inception. 
- The Adapter makes our client code Open for extension but closed to modification.
- The Adapter Pattern is related to the Decorator Pattern, but they are quite different.
- The Adapter changes the interface of an object by wrapping it and it manages routing calls from the new interface to the old.
- The Decorator doesn't change the interface of an object it iteratively wraps an object to add more implementations of the methods defined in the shared interface.
- There is another Pattern Related to the Adapter called the Facade. This pattern makes an interface simpler. Let's have a quick look at that one next.
*/













