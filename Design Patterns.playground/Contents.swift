 
import UIKit

/*:
 ## The Need for design patterns:
 - Change is a constant in Software
	- Specifications.
	- Clients can change their minds.
	- Features can be added/removed.
	- You will always need to refactor a program to solve problems or fix bugs.
 
 - Design Patterns are ways really smart people before you have figured out how to build software that's flexible enough to handle constant change.
 
 ## What are design patterns?
 - Design Patterns are general solutions to common problems in software development.
 - Many problems in software development are related to how flexible and resilient a program is to change over the long run.
 - Ideally we want to write software that can easily have features added or removed without those changes involving code that shouldn't be impacted by these changes?
 - For instance, by structuring our app properly we should be able to easily swap out `Core Data` for `Realm` without having to rebuild most of our application in the process?
 - But if we put all of our model logic in our view controllers, then if we wanted to change the persistence technology we would have to start making changes to code that shouldn't be impacted by this change.
 - Design patterns are generalized guidelines for building robust code that applies regardless of the specific domain.
 - So they are the same in, say, game development as they are in an e-commerce app.
 - Design Patterns are general solutions on how best to structure your objects and their interactions with other objects.
 - The area of design patterns trace their origins to the book "Design Patterns: Elements of Reusable Object-Oriented Software" by a group of 4 authors referred to as The Gang of Four.
 
![](gang.jpeg)

 - This book talks about 23 patterns. 
 - The original 23 patterns have since been extended.
 - Design patterns give you a shared vocabulary.
 - Design patterns give you ideas about how to build good software because you can see how some of the best developers have solved problems.
 - Using design patterns is reusing the experience of other developers.
 - I'm going to cover some classical design patterns today many of the examples are taken from the Head First Book: `Design Patterns`.
 - Like any tool, design patterns can be abused. 
 - The trade off with developing code to patterns is that your code can become more complex to understand. 
 - But before you can know when to use design patterns you need to understand the main patterns.
 - Today functional styles of programming are fashionable. Knowing OOP will make you a better programmer whether you're working in a functional paradigm or not. 
 - Anyhow, although Swift has some functional elements it is still fundamentally and OO language, as is Objc.
 
![](head.jpeg)
*/
