import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// publishers will pass a limited number of values

let foodArray: Publishers.Sequence<[String], Never> = ["Apple", "Pear", "Orange", "Watermelon"]
    .publisher

//let subscription = foodArray
//    .sink { completion in
//        print(">>> sink completion \(completion)")
//    } receiveValue: { foodItem in
//        print(">>> sink receiveValue \(foodItem)")
//    }

var timer = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
let endDate = Date().addingTimeInterval(3)

struct MyError: Error {}

func throwAtEndDate(foodItem: String, date: Date) throws -> String {
    if date < endDate {
        foodItem + "at \(date)"
    } else {
        throw MyError()
    }
}

let subscriptions = foodArray
    .zip(timer)
    .tryMap { try throwAtEndDate(foodItem: $0, date: $1) }
    .sink { completion in
        switch completion {
        case .finished:
            print(">>> sink completion finished")
        case .failure(let error):
            print(">>> sink completion failure \(error)")
        }
    } receiveValue: { result in
        print(">>> sink receiveValue: \(result)")
    }

