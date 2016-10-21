import Foundation

func dispatchOnMainAfter(_ theDelay: Double, block: @escaping () -> ()) {
    delay(theDelay) {
        block()
    }
}

func delay(_ theDelay:Double, queue: DispatchQueue = DispatchQueue.main, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(theDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
