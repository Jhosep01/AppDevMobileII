import UIKit

extension UIButton {

    func round() {
        layer.cornerRadius = 16
        clipsToBounds = true
    }

    func bounce() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
}
