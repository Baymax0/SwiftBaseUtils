//
//  UIView+Shake.swift
//  SingleLineShakeAnimation
//
//  Created by Håkon Bogen on 24/04/15.
//  Copyright (c) 2015 haaakon. All rights reserved.
//

import UIKit

public enum ShakeDirection: Int {
    case Horizontal
    case Vertical
    
    case clockwise
    case anticlockwise

    func startPosition() -> ShakePosition {
        switch self {
        case .Horizontal:
            return ShakePosition.Left
        case .Vertical:
            return ShakePosition.Top
        case .clockwise:
            return ShakePosition.clockwise
        default:
            return ShakePosition.anticlockwise
        }
    }
}

struct ShakePosition  {

    let value: CGFloat
    let direction: ShakeDirection

    init(value: CGFloat, direction: ShakeDirection) {
        self.value = value
        self.direction = direction
    }

    func oppositePosition() -> ShakePosition {
        return ShakePosition(value: (self.value * -1), direction: direction)
    }

    static var Left: ShakePosition {
        return ShakePosition(value: 1, direction: .Horizontal)
    }

    static var Right: ShakePosition {
        return ShakePosition(value: -1, direction: .Horizontal)
    }

    static var Top: ShakePosition {
        return ShakePosition(value: 1, direction: .Vertical)
    }

    static var Bottom: ShakePosition {
        return ShakePosition(value: -1, direction: .Vertical)
    }
    
    static var clockwise: ShakePosition {
        return ShakePosition(value: 0.14, direction: .clockwise)
    }
    static var anticlockwise: ShakePosition {
        return ShakePosition(value: -0.14, direction: .clockwise)
    }
    
}

public enum Vibration {
    case Light
    case Medium
    case Heavy
    
    @available(iOS 10.0, *)
    func occurred() {
        switch self {
        case .Heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .Medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .Light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}


public let DefaultValues_numberOfTimes = 6
public let DefaultValues_totalDuration: Float = 0.36

extension UIView {

    /**
    Shake a view back and forth for the number of times given in the duration specified.
    If the total duration given is 1 second, and the number of shakes is 5, it will use 0.20 seconds per shake.
    After it's done shaking, the completion handler is called, if specified.

    - parameter direction:     The direction to shake (horizontal or vertical motion)
    - parameter numberOfTimes: The total number of times to shake back and forth, default value is 5
    - parameter totalDuration: Total duration to do the shakes, default is 0.5 seconds
    - parameter completion:    Optional completion closure
    */
    public func shake(direction: ShakeDirection, numberOfTimes: Int = DefaultValues_numberOfTimes, totalDuration: Float = DefaultValues_totalDuration, completion: (() -> Void)? = nil){
        
        let timePerShake = Double(totalDuration) / Double(numberOfTimes)
        shake(forTimes: numberOfTimes, position: direction.startPosition(), durationPerShake: timePerShake, completion: completion)
        Vibration.Heavy.occurred()

    }

    private func shake(forTimes: Int, position: ShakePosition, durationPerShake: TimeInterval, completion: (() -> Void)?) {
        UIView.animate(withDuration: durationPerShake, animations: { () -> Void in
            if position.direction == .Horizontal{
                self.layer.setAffineTransform( CGAffineTransform(translationX: 3 * position.value, y: 0))
            }else if position.direction == .Vertical{
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: 3 * position.value))
            }else if position.direction == .clockwise{
                self.layer.setAffineTransform( CGAffineTransform(rotationAngle: position.value * CGFloat.pi / 12))
            }
        }) { (complete) -> Void in
            if (forTimes == 0) {
                UIView.animate(withDuration: durationPerShake, animations: { () -> Void in
                    self.layer.setAffineTransform(.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            } else {
                self.shake(forTimes: forTimes - 1, position: position.oppositePosition(), durationPerShake: durationPerShake, completion:completion)
            }
        }
    }

}


