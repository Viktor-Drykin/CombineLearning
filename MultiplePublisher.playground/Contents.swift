import Combine
import Foundation

class ViewModel {
    
    let newUserNameEntered = PassthroughSubject<String, Never>()
    let userNamesAnyPublisher: AnyPublisher<[String], Never>

    private let userNamesSubject = CurrentValueSubject<[String], Never>(["Bill"])
    private var subscriptions = Set<AnyCancellable>()

    init() {

        userNamesAnyPublisher =  userNamesSubject.eraseToAnyPublisher()
        /* using scan we can pass data from a subject to a publisher
         userNamesAnyPublisher = newUserNameEntered
             .scan(userNamesSubject.value, { currentArray, newValue in
                 print("currentArray \(currentArray) and newValue \(newValue)")
                 return currentArray + [newValue]
             })
             .eraseToAnyPublisher()
         */

        newUserNameEntered
            .sink { [unowned self] userName in
                // Not good option 1
                //self.userNamesSubject.value = self.userNames.value + [userName]
                // Not good option 2
                self.userNamesSubject.send(userNamesSubject.value + [userName])
            }
            .store(in: &subscriptions)

        userNamesSubject
            .sink {
                print(">>> userNames completion \($0)")
            } receiveValue: { value in
                print(">>> userNames receiveValue \(value)")
            }
            .store(in: &subscriptions)
    }

    deinit {
        print("ViewModel deinit")
    }
}

var viewModel: ViewModel? = ViewModel()

//add new user name
viewModel?.newUserNameEntered.send("Susan")

viewModel?.newUserNameEntered.send("Bob")

viewModel = nil
