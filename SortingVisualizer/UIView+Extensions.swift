import UIKit

extension UIView {
    
    static func make<T: UIView>(_ block: ((T) -> Void)? = nil, _ initializer: (() -> T)? = nil) -> T {
        let view = initializer?() ?? T()
        view.translatesAutoresizingMaskIntoConstraints = false
        block?(view)
        return view
    }
    
}

extension UIView {
    
    func pin(to layoutGuide: UILayoutGuide) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
        ])
    }
    
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}
