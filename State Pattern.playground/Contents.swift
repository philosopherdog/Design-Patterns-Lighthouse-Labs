import UIKit

/*:
 # State Pattern
 - When writing code we often need to model a state machine.
 - State Machines consist of states and transitions.
 - Good examples are stop lights, or controllers on machines like vending machines.
 
 ![](zune.png)
 
 */

/*:
 ### Play/Pause Button Example Without the State Pattern.
 */

class MP3Player {
  var currentPlayerState = PlayerState.pause {
    didSet {
      print(#line, currentPlayerState.rawValue)
      self.button.setTitle(currentPlayerState.rawValue, for: .normal)
    }
  }
  var button: UIButton
  init() {
    self.button = UIButton()
    self.button.setTitle(currentPlayerState.rawValue, for: .normal)
  }
  enum PlayerState: String {
    case play = "Playing"
    case pause = "Pausing"
  }
  
  func play() {
    if currentPlayerState == .pause {
      currentPlayerState = .play
      return
    }
    if currentPlayerState == .play {
      currentPlayerState = .pause
    }
  }
}

let mp3Player = MP3Player()
mp3Player.play()
mp3Player.button.title(for: .normal)
mp3Player.play()
mp3Player.button.title(for: .normal)

/*:
 - Classes hold instance members that store data.
 - So we can say that Class instances "hold state" (that is, particular bits of stored data).
 - In out code above the `currentPlayerState` property holds an enum value that models the player's state so it can change the button's text to match.
 - A really common issue, represented in this code above, is that changes to the state requires changes to the "behaviours" or methods of a class instance.
 - So in the case above changes to `currentPlayerState` determines which branch of the play's method will be executed.
 - Generally when we see switch statements (if/else) inside methods, or we pass boolean flags or track boolean flags then we are usually writing code that needs to change behavior depending on state.
 - This code above requires the play method to respond differently depending on the state and it does this at run time.
 - Also notice that the play method triggers a state transition.
 - What is wrong with this code?
 - This is where the State Pattern comes in.
 - The GOF defines the State Pattern as a pattern that
 > "Allows an object to alter its behaviour when its internal state changes. The object will appear to change its class."
 - Essentially the state pattern allows us to swap out the guts of a class at run time and it also manages state transitions.
 - Let's look at a very simple example.
 */

/*:
 ### Refactored Using the State Pattern
 - Let's use OO design to build a better Player.
 - We can encapsulate each of the states as an object that implements a protocol.
 
 ![](player_state_obj.png)
 
 */

protocol PlayerState: CustomStringConvertible {
  func play(with context: MP3PlayerContext)
  var description: String { get }
}

class PlayPlayerState: PlayerState {
  func play(with context: MP3PlayerContext) {
    context.currentState = context.states[0]
  }
  var description: String {
    return "Playing Player Now Pausing"
  }
}

class PausePlayerState: PlayerState {
  func play(with context: MP3PlayerContext) {
    context.currentState = context.states[1]
  }
  
  var description: String {
    return "Paused Player Now Playing "
  }
}

class MP3PlayerContext {
  let states: [PlayerState]
  var currentState: PlayerState
  
  init(states: [PlayerState]) {
    self.states = states
    self.currentState = self.states[0]
  }
  
  func play() {
    currentState.play(with: self)
  }
}

let player = MP3PlayerContext(states: [PausePlayerState(),PlayPlayerState()])
player.play()
player.currentState.description
player.play()
player.currentState.description

/*:
 - Why are we passing the Concrete Player States in through the initializer? What's the advantage of doing this?
 - Notice that the Context passes itself into the currentState's play method. Is this a good idea? What alternatives do we have and why are they better/worse?
 */

/*:
 # Vending Machine Example
 - Let's consider a slightly more complex example of a gum ball machine (discussed in Headfirst).
 
 ![](gum.png)
 
 */

/*:
 ## Common Implementation Using Switches
 */



class GumMachine {

// We start with an enum to represent all of the possible states
  
  enum GumMachineState {
    case soldout
    case noQuarter
    case hasQuarter
    case sold
  }
  
  var gumMachinestate = GumMachineState.noQuarter
  
  // We can model each of the transitions as a method.
  
  
  func insertQuarter() {
    switch gumMachinestate {
    case .hasQuarter:
      print(#line, "Error, already a quarter")
    case .soldout:
      print(#line, "Error, machine sold out")
    case .sold:
      print(#line, "Already getting you a gumball")
    case .noQuarter:
      gumMachinestate = .hasQuarter
    }
  }
  
  func turnCrank() {
    switch gumMachinestate {
    case .hasQuarter:
      gumMachinestate = .sold
      dispense()
    case .soldout:
      print(#line, "Error, machine sold out")
    case .sold:
      print(#line, "You can't turn crank twice")
    case .noQuarter:
      print(#line, "Insert quarter first")
    }
  }
  
  func dispense() { }
}

/*:
- What is wrong with this code?!
- Consider the case where the requirements change and the client would like us to add a new state for winning a gumball every so often.

![](winner.png)

- How would we add this change to the existing code?
 
*/

/*:
- Instead of this mess let's use the State Pattern to make this code better.
- Just like with the Player example above, we want to encapsulate the states as separate objects that implement a common interface.

![](gum_state_obj.png)

*/
/*:
- The key is that we want to give the GumBallMachine a property that tracks what state it's in.
- The GumBallMachine will call the transition methods on the current state, which will handle its own implementation.
- The state object will also handle the transition to the next state.

*/

// The delegate is used so the states can call back to the gumball machine.
protocol GumBallStateDelegate: class {
  func getState(at index: Int)-> GumBallState
  func setCurrentState(at index:Int)
  func getGumballCount()->Int
  func reduceGumballCount()
}

class GumBallState {
  func insertQuater() {
    fatalError()
  }
  func ejectQuarter() {
    fatalError()
  }
  func turnCrank() {
    fatalError()
  }
  func dispense() {
    fatalError()
  }
  // the GumBallMachine is the delegate
  weak var delegate: GumBallStateDelegate?
  
  // convenience
  enum StateEnum: Int {
    case soldState, soldOutState, noQuarterState, hasQuarterState
  }
}

class SoldState: GumBallState {
  override func insertQuater() {
    print(#line, "error, wait for it to dispense")
  }
  override func ejectQuarter() {
    print(#line, "error, too late!")
  }
  override func turnCrank() {
    print(#line, "error, wait already")
  }
  override func dispense() {
    print(#line, "dispensing gum")
    delegate?.reduceGumballCount()
    delegate?.setCurrentState(at: StateEnum.noQuarterState.rawValue)
    if (delegate?.getGumballCount())! < 1 {
      delegate?.setCurrentState(at: StateEnum.soldState.rawValue)
    }
  }
}

class SoldOutState: GumBallState {
  override func insertQuater() {
    print(#line, "error, sold out")
  }
  override func ejectQuarter() {
    print(#line, "eject quarter")
  }
  override func turnCrank() {
    print(#line, "error, nothing to dispense")
  }
  override func dispense() {
    print(#line, "error, wait for it to dispense")
  }
}

class NoQuarterState: GumBallState {
  override func insertQuater() {
    if (delegate?.getGumballCount())! > 0 {
      print(#line, "you inserted the quarter!")
      delegate?.setCurrentState(at: StateEnum.hasQuarterState.rawValue)
    }
    else {
      delegate?.setCurrentState(at: StateEnum.soldOutState.rawValue)
      ejectQuarter()
    }
  }
  override func ejectQuarter() {
    print(#line, "error, no quarter to eject")
  }
  override func turnCrank() {
    print(#line, "error, need to insert quarter first")
  }
  override func dispense() {
    print(#line, "error, turn crank")
  }
}

class HasQuarterState: GumBallState {
  override func insertQuater() {
    print(#line, "error, your current quarter is blocking it")
  }
  override func ejectQuarter() {
    print(#line, "ejecting quarter")
    delegate?.setCurrentState(at: StateEnum.noQuarterState.rawValue)
  }
  override func turnCrank() {
    print(#line, "crank turned!")
    delegate?.setCurrentState(at: StateEnum.soldState.rawValue)
  }
  override func dispense() {
    print(#line, "error, turn the crank")
  }
}


class GumBallMachine: GumBallStateDelegate {
  var state: GumBallState
  let states: [GumBallState]
  
  var gumballCount: Int
  
  init(states: [GumBallState], gumballCount: Int) {
    self.states = states
    state = self.states[2] // defaults to NoQuarter
    self.gumballCount = gumballCount
    states.map { $0.delegate = self }
  }
  
  func insertQuater() {
    state.insertQuater()
  }
  func ejectQuarter() {
    state.ejectQuarter()
  }
  
  func turnCrank() {
    state.turnCrank()
  }
  
  func dispense() {
    state.dispense()
  }
  
  // Delegate Methods
  func setCurrentState(at index: Int) {
    state = states[index]
  }
  
  func getState(at index: Int) -> GumBallState {
    return states[index]
  }
  
  func getGumballCount()->Int {
    return gumballCount
  }
  
  func reduceGumballCount() {
    gumballCount -= 1
  }
  
}

let gumBallMachine = GumBallMachine(states: [SoldState(), SoldOutState(), NoQuarterState(), HasQuarterState()], gumballCount: 10)

gumBallMachine.insertQuater()
gumBallMachine.ejectQuarter()
print(#line, gumBallMachine.state)
gumBallMachine.insertQuater()
print(#line, gumBallMachine.state)
gumBallMachine.turnCrank()
print(#line, gumBallMachine.state)
gumBallMachine.dispense()
print(#line, gumBallMachine.state)
gumBallMachine.gumballCount

/*:
- This gets rid of all of the conditional code inside the GumBallMachine.
- The behaviors are delegated to the states using polymorphism.
- The GumBallMachine doesn't need to know what state its in.

![](uml.png)

- The Context delegates requests from clients to the state.

![](def.png)


- The State Pattern "encapsulates what varies" by making each state object responsible for its own behavior.
- Our code obeys the Open/Closed principle. So we can add new states without a huge rewrite of the GumballMachine.
*/

/*:
### Practice Exercise
- Let's model a traffic light with 3 states, GoState, YieldState, and StopState.
- The context will be the TrafficLight class that will have a reference to the current state using the property state.
- Make sure your state objects either subclass an abstract state class or implement a protocol so that the context can handle the states polymorphicly.
- Each of the concrete states will implement the behavior, displayLight which should log out the light's color.
- Each concrete state should also have a next method that makes it transition to the next state.
- Initialize the context with the stopped state, and when you call next() on the context it should route this call to the state object which will handle the transition.
*/














