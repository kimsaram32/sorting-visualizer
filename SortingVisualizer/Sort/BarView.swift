import UIKit

class BarView: UIView {
    
    let ratio: CGFloat
    var highlightColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    init(ratio: CGFloat) {
        self.ratio = ratio
        super.init(frame: .zero)
        updateBackgroundColor()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
            self.updateBackgroundColor()
        }
    }
    
    convenience init(ratio: Float) {
        self.init(ratio: CGFloat(ratio))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func updateBackgroundColor() {
        let highlighted = highlightColor != nil
        
        var hue: CGFloat = highlighted ? 30.0 : 0
        if let highlightColor {
            highlightColor.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        }
        
        let saturation = highlighted ? 0.9 : 0
        
        let brightness = UITraitCollection.current.userInterfaceStyle == .dark
            ? ratio * 0.6 + 0.1
            : ratio * 0.85 + 0.1
        
        backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
}
