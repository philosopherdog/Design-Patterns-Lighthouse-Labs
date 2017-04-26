import UIKit

/*:
#Command Pattern

![](remote.png)

- The problem is that the remote needs to control vender classes that have no consistent API.

![](inconsistent.png)

- What we want to avoid is a bunch of switch statements like if `slot1 == self.light` then `light.on()`.
- The Command allows you to decouple the object that requests an action (the remote) from the object that executes the acton (the appliance).
- The classical pattern does this by introducing "command objects" that encapsulates a request (light turn on the lights) and the concrete object that is to execute this request.
- The remote has no idea about the concrete class or its API. They are decoupled.
- BTW, this pattern is used all over the place in iOS. For instance, it is used in the Observer Pattern (NotificationCenter) and OperationQueue. The primary way you to this in iOS if you're to hand roll your own command pattern would be to use blocks/closures.
- Let's start with a simple example of the Command Pattern that is a remote that controls Lights and a GarageDoor.

*/



struct Light {
  func on() {
    print(#line, "light on")
  }
  func off() {
    print(#line, "light off")
  }
}

protocol Command {
  func execute()
}

struct LightOnCommand: Command {
  let light: Light
  func execute() {
    light.on()
  }
}

struct LightOffCommand: Command {
  let light: Light
  func execute() {
    light.off()
  }
}

// This is the Invoker
struct SimpleRemoteControl {
  var slot: Command? = nil
  mutating func set(command: Command) {
    self.slot = command
  }
  func buttonWasPressed() {
    slot?.execute()
  }
}

var remote = SimpleRemoteControl()
let light = Light()
let lightOnCommand = LightOnCommand(light: light)
remote.set(command: lightOnCommand)
remote.buttonWasPressed()

struct GarageDoor {
  func up() {
    print(#line, "garage up")
  }
  func down() {
    print(#line, "garage down")
  }
  func stop() {
    print(#line, "garage stop")
  }
  func lightOn() {
    print(#line, "garage light on")
  }
  func lightOff() {
    print(#line, "garage light off")
  }
  
}
struct GarageDoorOpenCommand: Command {
  let garageDoor: GarageDoor?
  func execute() {
    garageDoor?.lightOn()
    garageDoor?.up()
  }
}

// This is the client
var garageDoor = GarageDoor()
let garageDoorOpenCommand = GarageDoorOpenCommand(garageDoor: garageDoor)
remote.set(command: garageDoorOpenCommand)
remote.buttonWasPressed()

/*:
![](def.png)

- Command Objects encapsulate a request.
- It binds together a set of concrete actions and the concrete receiver that will execute those actions.
- But it only exposes a single method `execute()` that calls the actual actions on the receiver.

![](command-obj.png)

- We could change the remote's set(command:) method to take in more than 1 command and map that to one particular buttonPress.

![](multi.png)

## UML Diagram

![](uml.gif)

*/

/*:
- To add multiple commands to all of the buttons we will need an array to hold all of the command objects on the Remote class and appropriate button actions to invoke them when pressed.
*/

// Something like this:

var onCommands: [Command] = []
var offCommands: [Command] = []

onCommands.append(lightOnCommand)
onCommands.append(garageDoorOpenCommand)
offCommands.append(LightOffCommand(light: light))

// If we had tags on our buttons then we could just have two button methods, one for the onCommands, and one for the offCommands

/*:
![](all.png)
*/

func onCommand(sender: UIButton) {
  let command = onCommands[sender.tag]
  command.execute()
}

func off2Command(sender: UIButton) {
  let command = onCommands[sender.tag]
  command.execute()
}


/*:
#### Implementing Undo
- All we have to do is add an `undo()` method to the `Command` protocol.

*/

protocol Command2 {
  func execute()
  func undo()
}

/*:
- How we have to make each of the Concrete Command objects implement undo in a way that is specific to their API.
- So, in the case of the Light, when you run undo it should turn the light off for the `LightOnCommand` and on for the `LightOffCommand`
*/

struct LightOnCommand2: Command2 {
  let light: Light
  func execute() {
    light.on()
  }
  func undo() {
    light.off()
  }
}

struct LightOffCommand2: Command2 {
  let light: Light
  func execute() {
    light.off()
  }
  func undo() {
    light.on()
  }
}

/*:
- From here we probably want to create an undo array in the Remote class to hold each command as it's executed.
- We can add an `undo()` button action to the remote to handle undo events.
- These will run the last element in the undo stack by executing its `undo()` method which will execute on the concrete command object encapsulated by the command object.
- We could then pop these off the end of the array or we could come up with other solutions.
*/



















