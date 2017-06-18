import UIKit
/*:
 # The Singleton Design Pattern:
 ![](sing_def.png)
 - Singleton is an instance, and there is only 1 of them ever created.
 - The class will prevent any object from creating more than 1 instance of the class.
 - Also, this single instance is globally accessible. What does this mean?
 - It should also be lazy initialized. Why?
 - Why would we need a Singleton?
 */

class MyNetworkManagerSingleton {
}

let mnws = MyNetworkManagerSingleton()

/*:
 - Why is `mnws` not a Singleton?
 */
/*:
 - First step is we want to create a private initializer.
 - This is legal and it prevents outside classes from initializing this class.
 - But how do we initialize it then?
 */
class MyNetworkManagerSingleton2 {
  private init() {}
}

// Causes a compiler error
// let mnws2 = MyNetworkManagerSingleton2()

class MyNetworkManagerSingleton3 {
  private init() {}
  // let sharedInstance = MyNetworkManagerSingleton3()
}

/*:
 - The trick is we want this class to initialize itself, and then retain itself.
 */

// let mnws3 = MyNetworkManagerSingleton3()

/*:
 - To call the `sharedInstance` property we can't call it on an *instance* because our init is now private.
 - So, we have to make `sharedInstance` `static`.
 */

class MyBigSingleTon {
  private init() {
    print(#line, #function, "got hit")
  }
  static let sharedInstance = MyBigSingleTon()
}


var s1: MyBigSingleTon? = MyBigSingleTon.sharedInstance
print(Unmanaged<AnyObject>.passUnretained(s1 as AnyObject).toOpaque())

var s2: MyBigSingleTon? = MyBigSingleTon.sharedInstance
print(Unmanaged<AnyObject>.passUnretained(s2 as AnyObject).toOpaque())

s1 = nil
s2 = nil

let s3 = MyBigSingleTon.sharedInstance
print(Unmanaged<AnyObject>.passUnretained(s3 as AnyObject).toOpaque())





