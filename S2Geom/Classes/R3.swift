//
//  R3.swift
//  S2Geom
//
//  Created by 十亀眞怜 on 2016/09/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation

func + (left: R3.Vector, right: R3.Vector) -> R3.Vector {
    return R3.Vector(
        x: left.x + right.x,
        y: left.y + right.y,
        z: left.z + right.z)
}

func - (left: R3.Vector, right: R3.Vector) -> R3.Vector {
    return R3.Vector(
        x: left.x - right.x,
        y: left.y - right.y,
        z: left.z - right.z)
}

func * (left: R3.Vector, right: Double) -> R3.Vector {
    return R3.Vector(
        x: right * left.x,
        y: right * left.y,
        z: right * left.z)
}

func == (left: R3.Vector, right: R3.Vector) -> Bool {
    return (left.x == right.x && left.y == right.y && left.z == right.z)
}
extension R3.Vector: Equatable {}

class R3 {

    class Vector: CustomStringConvertible {
        let x: Double
        let y: Double
        let z: Double

        init(x: Double, y: Double, z: Double) {
            self.x = x
            self.y = y
            self.z = z
        }

        func approxEqual(other: Vector) -> Bool {
            let epsilon: Double.Stride = 1e-16
            return (
                Swift.abs(self.x - other.x) < epsilon &&
                    Swift.abs(self.y - other.y) < epsilon &&
                    Swift.abs(self.z - other.z) < epsilon
            )
        }

        var description: String {
            return "(\(self.x), \(self.y), \(self.z))"
        }

        func norm() -> Double {
            return sqrt(self.dot(self))
        }

        func norm2() -> Double {
            return self.dot(self)
        }

        func normalize() -> Vector {
            if (self == Vector(x: 0, y: 0, z: 0)) {
                return self
            } else {
                return self * (1 / self.norm())
            }
        }

        func isUnit() -> Bool {
            let epsilon: Double.Stride = 5e-14
            return Swift.abs(self.norm2() - 1) <= epsilon
        }

        func abs() -> Vector {
            return Vector(x: Swift.abs(self.x), y: Swift.abs(self.y), z: Swift.abs(self.z))
        }

        func dot(other: Vector) -> Double {
            return self.x * other.x + self.y * other.y + self.z * other.z
        }

        func cross(other: Vector) -> Vector {
            return Vector(
                x: self.y * other.z - self.z * other.y,
                y: self.z * other.x - self.x * other.z,
                z: self.x * other.y - self.y * other.x)
        }

        func distance(other: Vector) -> Double {
            return (self - other).norm()
        }

        func angle(other: Vector) -> S1.Angle {
            return S1.Angle(val: atan2(self.cross(other).norm(), self.dot(other)) * Radian.val)
        }

        func ortho() -> Vector {
            var x = 0.012
            var y = 0.0053
            if (Swift.abs(self.x) > Swift.abs(self.y)) {
                y = 1
            } else {
                x = 1
            }
            return self.cross(Vector(x: x, y: y, z: 0.00457)).normalize()
        }
    }
}
