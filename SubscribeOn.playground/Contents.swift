import SwiftUI
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var cancellables = Set<AnyCancellable>()
let intSubject = PassthroughSubject<Int, Never>()

intSubject
    .subscribe(on: DispatchQueue.global())
    .sink { value in
        print(">>> \(value)")
        print(">>> \(Thread.current)")
    }
    .store(in: &cancellables)

intSubject.send(1)
intSubject.send(2)
intSubject.send(3)

/* because subscribe means on which thread we a going to do upstream operations
 >>> 1
 >>> <_NSMainThread: 0x600001700040>{number = 1, name = main}
 >>> 2
 >>> <_NSMainThread: 0x600001700040>{number = 1, name = main}
 >>> 3
 >>> <_NSMainThread: 0x600001700040>{number = 1, name = main}
 */


let subscription = URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com")!)
    .map { result in
        print(">>> URLSession map isMainThread \(Thread.current.isMainThread)")
    }
    .receive(on: DispatchQueue.main)
    .sink { _ in

    } receiveValue: { value in
        print(">>> URLSession receiveValue isMainThread \(Thread.current.isMainThread)")
    }

// Without.receive(on: DispatchQueue.main)
/*
 >>> URLSession map isMainThread false
 >>> URLSession receiveValue isMainThread false
*/
// With .receive(on: DispatchQueue.main)
/*
>>> URLSession map isMainThread false
>>> URLSession receiveValue isMainThread true
*/


//func generateInt() -> Future<Int, Never> {
//    return Future { promise in
//        promise(.success(Int.random(in: 1...10)))
//    }
//}
//
//let sub2 = generateInt()
//    .map { value in
//        sleep(5)
//        return value
//    }
