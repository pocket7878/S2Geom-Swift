//
//  Interval.swift
//  S2Geom
//
//  Created by 十亀眞怜 on 2016/09/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation

extension S1 {
    class Interval: CustomStringConvertible {
        let lo: Double
        let hi: Double

        init(lo: Double, hi: Double) {
            self.lo = lo
            self.hi = hi
        }

        class func fromEndpoints(lo: Double, hi: Double) -> Interval {
            var llo = lo
            var hhi = hi
            if (lo == (-M_PI) && hi != M_PI) {
                llo = M_PI
            } else {
                llo = lo
            }
            if (hi == (-M_PI) && lo != M_PI) {
                hhi = M_PI
            } else {
                hhi = hi
            }
            return Interval(lo: llo, hi: hhi)
        }

        class func empty() -> Interval {
            return Interval(lo: M_PI, hi: -M_PI)
        }

        class func full() -> Interval {
            return Interval(lo: -M_PI, hi: M_PI)
        }

        func isValid() -> Bool {
            return (
                Swift.abs(self.lo) <= M_PI &&
                Swift.abs(self.hi) <= M_PI &&
            !(self.lo == -M_PI && self.hi != M_PI) &&
            !(self.hi == -M_PI && self.lo != M_PI))
        }

        func isFull() -> Bool {
            return self.lo == -M_PI && self.hi == M_PI
        }

        func isEmpty() -> Bool {
            return self.lo == M_PI && self.hi == -M_PI
        }

        func isInverted() -> Bool {
            return (self.lo > self.hi)
        }

        func invert() -> Interval {
            return Interval(lo: self.hi, hi: self.lo)
        }

        func center() -> Double {
            let c = 0.5 * (self.lo + self.hi)
            if !self.isInverted() {
                return c
            }
            if c <= 0 {
                return c + M_PI
            }
            return c - M_PI
        }

        func length() -> Double {
            var l = self.hi - self.lo
            if l >= 0 {
                return l
            }
            l += 2 * M_PI
            if l > 0 {
                return l
            }
            return -1
        }

        func fastContains(p: Double) -> Bool {
            if self.isInverted() {
                return (p >= self.lo || p <= self.hi) && !self.isEmpty()
            } else {
                return (p >= self.lo && p <= self.hi)
            }
        }

        func contains(p: Double) -> Bool {
            if (p == -M_PI) {
                return self.fastContains(M_PI)
            } else {
                return self.fastContains(p)
            }
        }

        func contains(inter: Interval) -> Bool {
            if (self.isInverted()) {
                if (inter.isInverted()) {
                    return inter.lo >= self.lo && inter.hi <= self.hi
                }
                return (inter.lo >= self.lo || inter.hi <= self.hi) && !self.isEmpty()
            }
            if inter.isInverted() {
                return self.isFull() || inter.isEmpty()
            }
            return inter.lo >= self.lo && inter.hi <= self.hi
        }

        func interiorContains(p: Double) -> Bool {
            var pp = p
            if (pp == -M_PI) {
                pp = M_PI
            }
            if (self.isInverted()) {
                return (pp > self.lo || pp < self.hi)
            }
            return (pp > self.lo && pp < self.hi) || self.isFull()
        }

        func interiorContains(oi: Interval) -> Bool {
            if (self.isInverted()) {
                if (oi.isInverted()) {
                    return (oi.lo > self.lo && oi.hi < self.hi) || oi.isEmpty()
                }
                return (oi.lo > self.lo || oi.hi < self.hi)
            }
            if (oi.isInverted()) {
                return self.isFull() || oi.isEmpty()
            }
            return (oi.lo > self.lo && oi.hi < self.hi) || self.isFull()
        }

        func intersects(oi: Interval) -> Bool {
            if (self.isEmpty() || oi.isEmpty()) {
                return false
            }
            if self.isInverted() {
                return oi.isInverted() || oi.lo <= self.hi || oi.hi >= self.lo
            }
            if (oi.isInverted()) {
                return oi.lo <= self.hi || oi.hi >= self.lo
            }
            return oi.lo <= self.hi && oi.hi >= self.lo
        }

        func interiorIntersects(oi: Interval) -> Bool {
            if (self.isEmpty() || oi.isEmpty() || self.lo == self.hi) {
                return false
            }
            if (self.isInverted()) {
                return oi.isInverted() || oi.lo < self.hi || oi.hi > self.lo
            }
            if (oi.isInverted()) {
                return oi.lo < self.hi || oi.hi > self.lo
            }
            return (oi.lo < self.hi && oi.hi > self.lo) || self.isFull()
        }

        func unison(oi: Interval) -> Interval {
            if (oi.isEmpty()) {
                return self
            }
            if (self.fastContains(oi.lo)) {
                if (self.fastContains(oi.hi)) {
                    if (self.contains(oi)) {
                        return self
                    }
                    return Interval.full()
                }
                return Interval(lo: self.lo, hi: oi.hi)
            }
            if (self.fastContains(oi.hi)) {
                return Interval(lo: oi.lo, hi: self.hi)
            }
            if (self.isEmpty() || oi.fastContains(self.lo)) {
                return oi
            }
            if S1.positiveDistance(oi.hi, b: self.lo) < S1.positiveDistance(self.hi, b: oi.lo) {
                return Interval(lo: oi.lo, hi: self.hi)
            }
            return Interval(lo: self.lo, hi: oi.hi)
        }

        func intersection(oi: Interval) -> Interval {
            if (oi.isEmpty()) {
                return Interval.empty()
            }
            if (self.fastContains(oi.lo)) {
                if (self.fastContains(oi.hi)) {
                    if (oi.length() < self.length()) {
                        return oi
                    }
                    return self
                }
                return Interval(lo: oi.lo, hi: self.hi)
            }
            if (self.fastContains(oi.hi)) {
                return Interval(lo: self.lo, hi: oi.hi)
            }
            if (oi.fastContains(self.lo)) {
                return self
            }
            return Interval.empty()
        }

        func addPoint(p: Double) -> Interval {
            var pp = p
            if (Swift.abs(p) > M_PI) {
                return self
            }
            if (pp == -M_PI) {
                pp = M_PI
            }
            if (self.fastContains(pp)) {
                return self
            }
            if (self.isEmpty()) {
                return Interval(lo: pp, hi: pp)
            }
            if (S1.positiveDistance(pp, b: self.lo) < S1.positiveDistance(self.hi, b: pp)) {
                return Interval(lo: pp, hi: self.hi)
            }
            return Interval(lo: self.lo, hi: pp)
        }

        func expanded(margin: Double) -> Interval {
            if (margin >= 0) {
                if (self.isEmpty()) {
                    return self
                }
                if (self.length() + 2 * margin + 2 * S1.epsilon >= 2 * M_PI) {
                    return Interval.full()
                }
            } else {
                if (self.isFull()) {
                    return self
                }
                if (self.length() + 2 * margin - 2 * S1.epsilon <= 0) {
                    Interval.empty()
                }
            }
            var result = Interval.fromEndpoints(
                remainder(self.lo - margin, 2 * M_PI),
                hi: remainder(self.hi + margin, 2 * M_PI))
            if (result.lo <= -M_PI) {
                result = Interval(lo: M_PI, hi: result.hi)
            }
            return result
        }

        var description: String {
            return String(format: "[%.7f, %.7f]", self.lo, self.hi)
        }
    }

    static let epsilon: Double = nextafter(0, 1)

    static func positiveDistance(a: Double, b: Double) -> Double {
        var d = b - a
        if d >= 0 {
            return d
        }
        return (b + M_PI) - (a - M_PI)
    }
}
