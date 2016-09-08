//
//  Angle.swift
//  S2Geom
//
//  Created by 十亀眞怜 on 2016/09/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation
import Darwin

let Radian: S1.Angle = S1.Angle(val: 1)
let Degree = S1.Angle(val: (M_PI / 180) * Radian.val)
let E5 = S1.Angle(val: 1e-5)
let E6 = S1.Angle(val: 1e-6)
let E7 = S1.Angle(val: 1e-7)


extension S1 {


    class Angle: CustomStringConvertible {
        let val: Double

        init(val: Double) {
            self.val = val
        }

        class func infAngle() -> Angle {
            return Angle(val: Double.infinity)
        }

        func radians() -> Double {
            return self.val
        }

        func degrees() -> Double {
            return Double(self.val / Degree.val)
        }

        func isInf() -> Bool {
            return self.val.isInfinite
        }

        func e5() -> Int32 {
            return S1.round(self.degrees() * 1e5)
        }

        func e6() -> Int32 {
            return S1.round(self.degrees() * 1e6)
        }

        func e7() -> Int32 {
            return S1.round(self.degrees() * 1e7)
        }

        func abs() -> Angle {
            return Angle(val: Swift.abs(self.val))
        }

        func normalized() -> Angle {
            var rad = self.val % (2 * M_PI)
            if (rad < 0) {
                rad += 2 * M_PI
            }
            return Angle(val: rad)
        }

        var description: String {
            return String(format: "%.7f", self.val)
        }
    }

    static func round(val: Double) -> Int32 {
        if val < 0 {
            return Int32(val - 0.5)
        } else {
            return Int32(val + 0.5)
        }
    }
}
