import Foundation

import UIKit

extension UIStoryboard {

    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }

    func instantiateVC<T: UIViewController>(of type: T.Type) -> T where T: Identifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: type.identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(type.identifier) ")
        }
        return viewController
    }
}
