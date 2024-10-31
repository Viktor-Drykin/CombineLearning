import Foundation
import Combine

//Timer publisher
var subscription: Cancellable? = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .sink { output in
        print(">>> sink1 \(output)")
    } receiveValue: { value in
        print(">>> receiveValue1 \(value)")
    }
RunLoop.main.schedule(after: .init(Date(timeIntervalSinceNow: 5))) {
    print(">>> cancel subscription1")
    // cancel option 1
    //subscription?.cancel()
    // cancel option 2
    subscription = nil // make type Cancellable?
}


// Operator scan and filter and throttle
var subscription2: Cancellable? = Timer.publish(every: 0.1, on: .main, in: .common)
    .autoconnect()
    .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
    .scan(0, { count, _ in
        return count + 1
    })
    .filter {
        $0 > 2 && $0 < 10
    }
    .sink { output in
        print(">>> sink2 \(output)")
    } receiveValue: { value in
        print(">>> receiveValue2 \(value)")
    }
RunLoop.main.schedule(after: .init(Date(timeIntervalSinceNow: 15))) {
    print(">>> cancel subscription2")
    // cancel option 1
    subscription2?.cancel()
}

