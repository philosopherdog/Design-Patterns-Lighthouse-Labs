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
- In my hand rolled Observer I'm using blocks instead of Selectors to add observers and post notifications.
- The Observer Pattern is at the heart of the reactive programming. 
- The Observer is a very good fit for asynchronous programming, multi-threaded programming, and event chaining.
*/

class MyNotificationCenter: NSObject {
  
  // this is a singleton
  static let defaultCenter = MyNotificationCenter()
  
  private override init() {}
  
  // this is the type of the block
  typealias Observer = (Dictionary<AnyHashable,AnyObject>?) -> Void
  
  // We will hold an array of observers
  private var observers: Dictionary<AnyHashable, [Observer]> = [:]
  
  func addObserver(with name: String, block: @escaping Observer) {
    if observers[name] == nil {
      observers[name] = [Observer]()
    }
    observers[name]?.append(block) // what does the ? do here
  }
  
  // If somebody wants to post a notification, they pass us the name of the notification, and the data. 
  // We then check to see if any objects have signed up to receive notifications by that name, and if they have we send out the notification to all observers
  
  func postNotification(with name: String, data: Dictionary<AnyHashable,AnyObject>?) {
    guard let observersForName = observers[name] else {
      return
    }
    for observer: Observer in observersForName {
      observer(data)
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

let weatherData: Dictionary<AnyHashable, AnyObject>? = ["Toronto" : "Rainy" as AnyObject]
station.didReceiveData(data: weatherData) // 2 weather apps received the notification about the new weather.

