import Foundation
import Combine
import PlaygroundSupport

class IntContainer {
    var intValue: Int = 0 {
        didSet {
            print("IntValue was set to: \(intValue)")
        }
    }
}

var container = IntContainer()
let myRange = (0...2)
let subscription = myRange
    .publisher
    .map { $0 * 10 }
//   we can use assign to assign value
    .assign(to: \.intValue, on: container)
//    we can use sink to assign value
//    .sink { value in
//        container.intValue = value
//    }


// CurrentValueSubject

struct User {
    let name: String
    let id: Int
}

class ViewModel {
    
    var user = CurrentValueSubject<User, Never>(.init(name: "John", id: 1))
    var subscriptions = Set<AnyCancellable>()
    var userID = 0 {
        didSet {
            print(">>> ViewModel userID didSet \(userID)")
        }
    }

    init() {
        user
            .map(\.id)
            .sink { [unowned self] value in
                self.userID = value
            }
            //.assign(to: \.userID, on: self)
            .store(in: &subscriptions)
    }

    deinit {
        print(">>> ViewModel deinit")
    }
}

var viewModel: ViewModel? = ViewModel()
viewModel?.user.send(.init(name: "NewName", id: 2))

viewModel = nil
// Not deinit call because of memory leak if we use assign on self
/*
>>> ViewModel userID didSet 1
>>> ViewModel userID didSet 2
*/


// when we add sink with unowned self we will get
/*
 >>> ViewModel userID didSet 1
 >>> ViewModel userID didSet 2
 >>> ViewModel deinit
*/
