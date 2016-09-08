//
//  ChordAngle.swift
//  S2Geom
//
//  Created by 十亀眞怜 on 2016/09/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation

extension S1 {

    static let NegativeChordAngle = ChordAngle(val: -1)
    static let RightChordAngle = ChordAngle(val: 2)
    static let StraightAngle = ChordAngle(val: 4)

    static var dblEpsilon = nextafter(1.0, 2.0) - 1

    class ChordAngle {
        let val: Double

        init(val: Double) {
            self.val = val
        }

        init(angle: Angle) {
            if angle.val < 0 {
                self.val = -1
            } else if angle.isInf() {
                self.val = Double.infinity
            } else {
                let l = 2 * sin(0.5 * min(M_PI, angle.radians()))
                self.val = l * l
            }
        }

        func angle() -> Angle {
            if (self.val < 0) {
                return Angle(val: -1 * Radian.val)
            } else if (self.isInf()) {
                return Angle(val: Double.infinity)
            } else {
                return Angle(val: 2 * asin(0.5 * sqrt(Double(self.val))))
            }
        }

        class func infinity() -> ChordAngle {
            return ChordAngle(val: Double.infinity)
        }

        func isInf() -> Bool {
            return self.val.isInfinite
        }

        func isSpecial() -> Bool {
            return self.val < 0 || self.isInf()
        }

        func isValid() -> Bool {
            return (self.val >= 0 && self.val <= 4) || self.isSpecial()
        }

        func maxPointError() -> Double {
            return 2.5 * dblEpsilon * self.val + 16*dblEpsilon*dblEpsilon
        }

        func mapAngleError() -> Double {
            return dblEpsilon * self.val
        }
    }
}
