import Combine
import Foundation

struct User {
    let name: String
    let id: Int
}

let currentUserID = CurrentValueSubject<Int, Never>(1000)
let userNames = CurrentValueSubject<[String], Never>(["Bob", "NotBob", "John"])
let currentUser = CurrentValueSubject<User, Never>(.init(name: "Bob", id: 1))

// get the value for currentUserID
print("currentUserID \(currentUserID.value)")

// subscribe to Subject
let subscription = currentUserID
    .sink { completion in
        print("currentUserID completion \(completion)")
    } receiveValue: { value in
        print("receiveValue \(value)")
    }

// passing down new values with Subject
currentUserID.send(1)
currentUserID.send(2)

// sending completion finished with Subject
currentUserID.send(completion: .finished)
currentUserID.send(12)

/*
 currentUserID 1000
 receiveValue 1000
 receiveValue 1
 receiveValue 2
 currentUserID completion finished
*/


let passthroughExample = PassthroughSubject<String, Never>()

// Get the value of PassthroughSubject is IMPOSSIBLE

// subscribe to Subject
let passthroughSubscription = passthroughExample
    .sink { completion in
        print("PassthroughSubject completion \(completion)")
    } receiveValue: { value in
        print("PassthroughSubject receiveValue \(value)")
    }

// passing down new values
passthroughExample.send("Bob")

// sending completion finished with Subject
passthroughExample.send(completion: .finished)
passthroughExample.send("Bob2")

/*
 PassthroughSubject receiveValue Bob
 PassthroughSubject completion finished
 */
