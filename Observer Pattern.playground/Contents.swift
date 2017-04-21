import UIKit

/*:
# Observer Pattern
- The Observer Pattern is quite easy to understand.
- The best way to understand it is to think of a radio station.
- The radio station can broadcast to 0 or any number of radios.
- The radio just needs to tune in and the broadcast pushes the data out.
- The radio doesn't keep polling the station for updates.
- The same thing happens with the Observer Pattern.
- We have a one to many publisher/subscriber relationship.

![](pub.png)

![](def.png)


- Cocoa Touch has NotificationCenter and KVO that already use the Observer Pattern.
- But we can learn some things by rolling our own.
- I'm using blocks instead of Selectors to add observers and post notifications.
*/

class MyNotificationCenter: NSObject {
  
  // this is a singleton
  static let defaultCenter = MyNotificationCenter()
  
  private override init() {}
  
  // this is the type of the block
  typealias MyNotification = (Dictionary<AnyHashable,AnyObject>?) -> Void
  
  private var observers: Dictionary<AnyHashable, [MyNotification]> = [:]
  
  func addObserver(with name: String, block: @escaping MyNotification) {
    if observers[name] == nil {
      observers[name] = [MyNotification]()
    }
    observers[name]?.append(block)
  }
  
  func postNotification(with name: String, data: Dictionary<AnyHashable,AnyObject>?) {
    guard let blocks = observers[name] else {
      return
    }
    for block in blocks {
      block(data)
    }
  }
}

// Publisher
class WeatherStation {
  // receives weather from sensors
  func didReceiveData(data: Dictionary<AnyHashable,AnyObject>?) {
    MyNotificationCenter.defaultCenter.postNotification(with: "WeatherDidChangeNotification", data: data)
  }
}

// Subscriber
class WeatherApp {
  func addObserver() {
    MyNotificationCenter.defaultCenter.addObserver(with: "WeatherDidChangeNotification") { (dict: Dictionary<AnyHashable, AnyObject>?) in
      print(#line, dict as! Dictionary<String,String>)
    }
  }
}

let station = WeatherStation()
let weatherApp1 = WeatherApp()
weatherApp1.addObserver()

let weatherApp2 = WeatherApp()
weatherApp2.addObserver()

let fromSensors: Dictionary<AnyHashable, AnyObject>? = ["Toronto" : "Rainy" as AnyObject]
station.didReceiveData(data: fromSensors)
