import SwiftUI
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let intSubject = PassthroughSubject<Int, Never>()

let subscription = intSubject
    .receive(on: DispatchQueue.main)
    .sink { value in
        print(">>> sink RecieveValue \(value)")
        print(Thread.current)
    }

intSubject.send(1)

DispatchQueue.global().async {
    intSubject.send(2)
}

// with just sink we will get
/*
 >>> sink RecieveValue 1
 <_NSMainThread: 0x600001704040>{number = 1, name = main}
 >>> sink RecieveValue 2
 <NSThread: 0x600001701440>{number = 6, name = (null)}
 */

// with .receive(on: DispatchQueue.main)
/*
 >>> sink RecieveValue 1
 <_NSMainThread: 0x600001708000>{number = 1, name = main}
 >>> sink RecieveValue 2
 <_NSMainThread: 0x600001708000>{number = 1, name = main}
 */
