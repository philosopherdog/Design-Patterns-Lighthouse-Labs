import UIKit
/*:
 # The Singleton Design Pattern:
 ![](sing_def.png)
 - Singleton is an instance, and there is only 1 of them ever created during the apps life time.
 - The singleton class prevents any object from creating more than 1 instance of that class.
 - Also, this single instance is *globally* accessible. What does this mean?
 - It should also be lazy initialized.
 - The Singleton keeps only 1 set of values alive which can be globally shared.
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
 */
class MyNetworkManagerSingleton2 {
  private init() {}
}

// This causes a compiler error
// let mnws2 = MyNetworkManagerSingleton2()

/*:
 - But how do we initialize it if the initializer is private?
 */

class MyNetworkManagerSingleton3 {
  private init() {}
   let sharedInstance = MyNetworkManagerSingleton3()
}

/*:
 - The trick is we want this class to initialize itself, and then retain itself.
 */

// let mnws3 = MyNetworkManagerSingleton3()

/*:
 - To call the `sharedInstance` property we can't call it on an *instance* because our init is now private and so we can't use that to create an instance.
 - So, we have to make `sharedInstance` `static`.
 */

class MyBigSingleTon {
  private init() {
    print(#line, #function, "got hit")
  }
  static let sharedInstance = MyBigSingleTon()
}


var s1: MyBigSingleTon? = MyBigSingleTon.sharedInstance
print(#line, Unmanaged<AnyObject>.passUnretained(s1 as AnyObject).toOpaque())

var s2: MyBigSingleTon? = MyBigSingleTon.sharedInstance
print(#line, Unmanaged<AnyObject>.passUnretained(s2 as AnyObject).toOpaque())

s1 = nil
s2 = nil

let s3 = MyBigSingleTon.sharedInstance
print(#line, Unmanaged<AnyObject>.passUnretained(s3 as AnyObject).toOpaque())

/*:
 ## Caveats:
 - That's pretty much it for the singleton.
 - Some developers are very down on this pattern, but it has its place.
 - The UIApplication instance is a Singleton. Imagine if it weren't??
 - iOS makes copious use of the Singleton all over the SDK.
 - Singletons are very hard to unit test.
*/





