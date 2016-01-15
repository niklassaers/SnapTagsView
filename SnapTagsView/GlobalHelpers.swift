import Foundation

func dispatchOnMainAfter(theDelay: Double, block: () -> ()) {
    delay(theDelay) {
        block()
    }
}

func delay(theDelay:Double, queue: dispatch_queue_t = dispatch_get_main_queue(), closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(theDelay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
