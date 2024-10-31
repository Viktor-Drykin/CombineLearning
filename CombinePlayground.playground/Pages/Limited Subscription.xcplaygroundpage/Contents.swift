import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// publishers will pass a limited number of values

let foodArray: Publishers.Sequence<[String], Never> = ["Apple", "Pear", "Orange", "Watermelon"]
    .publisher

let subscription = foodArray
    .sink { completion in
        print(">>> sink completion \(completion)")
    } receiveValue: { foodItem in
        print(">>> receiveValue \(foodItem)")
    }

