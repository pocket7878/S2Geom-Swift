//
//  Point.swift
//  S2Geom
//
//  Created by 十亀眞怜 on 2016/09/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation

func + (left: R2.Point, right: R2.Point) -> R2.Point {
    return R2.Point(
        x: left.x + right.x,
        y: left.y + right.y)
}

func - (left: R2.Point, right: R2.Point) -> R2.Point {
    return R2.Point(
        x: left.x - right.x,
        y: left.y - right.y)
}

func * (left: R2.Point, right: Double) -> R2.Point {
    return R2.Point(
        x: right * left.x,
        y: right * left.y)
}

extension R2 {

    class Point: CustomStringConvertible {
        let x: Double
        let y: Double

        init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }

        func ortho() -> Point {
            return Point(x: -self.y, y: self.x)
        }

        func dot(op: Point) -> Double {
            return self.x * op.x + self.y * op.y
        }

        func cross(op: Point) -> Double {
            return self.x * op.y - self.y * op.x
        }

        func norm() -> Double {
            return hypot(self.x, self.y)
        }

        func normalize() -> Point {
            if (self.x == 0 && self.y == 0) {
                return self
            } else {
                return self * (1 / self.norm())
            }
        }

        var description: String {
            return String(format: "(%.12f, %.12f)", self.x, self.y)
        }
    }
}
