  import UIKit

//: ![Lazy Cat](lazy.png)

/*:
# Lazy Initialization:
- The tactic of delaying the creation of an object, the calculation of a value, or some other expensive process until the first time it is needed. [Wikipedia](https://en.wikipedia.org/wiki/Lazy_initialization)
- This is a prerequisite for understanding some other patterns.

- In Objc you typically do this by overriding the getter.
```
@property (nonatomic) NSURL *url;
...
- (NSURL *)url {
 if (!_url) {
 _url = [NSURL URLWithString:@"www.google.com"];
}
return _url;
}
```
*/
/*:
- In Swift there is a keyword `lazy` since there are officially no property getters.
- You can always roll your own Objc style properties in Swift. I will show both.
*/

struct NetWorkManager {
  init() {
    print(#line, #function, "fired")
  }
}

class SwiftLazy {
  lazy var networkManager = NetWorkManager()
}

/*: 
- Try removing `lazy`.
- You can see that without `lazy` the property initializes `NetworkManager` as soon as the class is initialized.
- lazy postpones the initialization until the property is actually accessed.
- `lazy initialization` is a very common pattern.
- `lazy initialization` is part of other patterns like the `Singleton Pattern`, which we will talk about next.
*/

var swiftLazy = SwiftLazy()
print(#line, "line reached")
let manager1 = swiftLazy.networkManager


/*:
### Hand Rolled Lazy Property in Swift
*/



class TheCode {
  
  // private backing store
  private var _networkManager: NetWorkManager?
  
  // computed, readonly, lazy property
  internal var networkManager: NetWorkManager? {
    get {
      if _networkManager == nil {
        print(#line, #function, "fired")
        _networkManager = NetWorkManager()
      }
      return _networkManager
    }
  }
}

let theCode = TheCode()
theCode.networkManager













