import Foundation

enum Storyboard: String {
    case main

    var filename: String {
        return rawValue.capitalized
    }
}
