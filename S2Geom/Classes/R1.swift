//
//  R1.swift
//  S2Geom
//
//  Created by 十亀眞怜 on 2016/09/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation

func == (left: R1.Interval, right: R1.Interval) -> Bool {
    return (left.lo == right.lo && left.hi == right.hi) || (left.isEmpty() && right.isEmpty())
}
extension R1.Interval: Equatable {}

class R1 {

    class Interval: CustomStringConvertible {
        let lo: Double
        let hi: Double

        init(lo: Double, hi: Double) {
            self.lo = lo
            self.hi = hi
        }

        init() {
            self.lo = 1
            self.hi = 0
        }

        init(point: Double) {
            self.lo = point
            self.hi = point
        }

        func isEmpty() -> Bool {
            return self.lo > self.hi
        }

        func center() -> Double {
            return 0.5 * (self.lo + self.hi)
        }

        func length() -> Double {
            return self.hi - self.lo
        }

        func contains(p: Double) -> Bool {
            return (self.lo <= p && p <= self.hi)
        }

        func contains(inter: Interval) -> Bool {
            guard !inter.isEmpty() else {
                return true
            }
            return (self.lo <= inter.lo && inter.hi <= self.hi)
        }

        func interiorContains(p: Double) -> Bool {
            return (self.lo < p && p < self.hi)
        }

        func interiorContains(inter: Interval) -> Bool {
            guard !inter.isEmpty() else {
                return true
            }
            return (self.lo < inter.lo && inter.hi < self.hi)
        }

        func intersects(inter: Interval) -> Bool {
            if (self.lo <= inter.lo) {
                return (inter.lo <= self.hi && inter.lo <= inter.hi)
            } else {
                return (self.lo <= inter.hi && self.lo <= self.hi)
            }
        }

        func interiorIntersects(inter: Interval) -> Bool {
            return inter.lo < self.hi && self.lo < inter.hi && self.lo < self.hi && inter.lo <= self.hi
        }

        func intersection(inter: Interval) -> Interval {
            return Interval(
                lo: max(self.lo, inter.lo),
                hi: min(self.hi, inter.hi))
        }

        func addPoint(p: Double) -> Interval {
            if self.isEmpty() {
                return Interval(point: p)
            } else if(p < self.lo) {
                return Interval(lo: p, hi: self.hi)
            } else if(p > self.hi) {
                return Interval(lo: self.lo, hi: p)
            } else {
                return self
            }
        }

        func clamPoint(p: Double) -> Double {
            return max(self.lo, min(self.hi, p))
        }

        func expaneded(margin: Double) -> Interval {
            if self.isEmpty() {
                return self
            } else {
                return Interval(lo: self.lo - margin, hi: self.hi + margin)
            }
        }

        func union(other: Interval) -> Interval {
            if (self.isEmpty()) {
                return other
            } else if (other.isEmpty()) {
                return self
            } else {
                return Interval(lo: min(self.lo, other.lo), hi: max(self.hi, other.hi))
            }
        }

        var description: String {
            return String(format: "[%.7f, %7f]", self.lo, self.hi)
        }

        func approxEqual(other: Interval) -> Bool {
            let epsilon: Double.Stride = 1e-14

            if self.isEmpty() {
                return other.length() <= 2 * epsilon
            } else if other.isEmpty() {
                return self.length() <= 2 * epsilon
            } else {
                return (abs(other.lo - self.lo) <= epsilon && abs(other.hi - self.hi) <= epsilon)
            }
        }
    }
}
