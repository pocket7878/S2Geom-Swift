//
//  Rect.swift
//  S2Geom
//
//  Created by 十亀眞怜 on 2016/09/08.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Foundation

extension R2 {

    class Rect: CustomStringConvertible {
        let x: R1.Interval
        let y: R1.Interval

        init(x: R1.Interval, y: R1.Interval) {
            self.x = x
            self.y = y
        }

        init(points: Point...) {
            if (points.count == 0) {
                self.x = R1.Interval()
                self.y = R1.Interval()
            } else {
                self.x = R1.Interval(lo: points[0].x, hi: points[0].x)
                self.y = R1.Interval(lo: points[0].y, hi: points[0].y)
                for p in points[points.startIndex.advancedBy(1) ..< points.endIndex] {
                    self.addPoint(p)
                }
            }
        }

        init(center: Point, size: Point) {
            self.x = R1.Interval(lo: center.x - size.x / 2,
                              hi: center.x + size.x / 2)
            self.y = R1.Interval(lo: center.y - size.y / 2,
                              hi: center.y + size.y / 2)
        }

        init() {
            self.x = R1.Interval()
            self.y = R1.Interval()
        }

        func isValid() -> Bool {
            return self.x.isEmpty() == self.y.isEmpty()
        }

        func isEmpty() -> Bool {
            return self.x.isEmpty()
        }

        func vertices() -> [Point] {
            return [
                Point(x: self.x.lo, y: self.y.lo),
                Point(x: self.x.hi, y: self.y.lo),
                Point(x: self.x.hi, y: self.y.hi),
                Point(x: self.x.lo, y: self.y.hi)
            ]
        }

        func vertexIJ(i: Int, j: Int) -> Point {
            var x = self.x.lo
            if i == 1 {
                x = self.x.hi
            }
            var y = self.y.lo
            if j == 1 {
                y = self.y.hi
            }
            return Point(x: x, y: y)
        }

        func lo() -> Point {
            return Point(x: self.x.lo, y: self.y.lo)
        }

        func hi() -> Point {
            return Point(x: self.x.hi, y: self.y.hi)
        }

        func center() -> Point {
            return Point(x: self.x.center(), y: self.y.center())
        }

        func size() -> Point {
            return Point(x: self.x.length(), y: self.y.length())
        }

        func contains(p: Point) -> Bool {
            return self.x.contains(p.x) && self.y.contains(p.y)
        }

        func contains(other: Rect) -> Bool {
            return self.x.contains(other.x) && self.y.contains(other.y)
        }

        func interiorContains(p: Point) -> Bool {
            return self.x.interiorContains(p.x) && self.y.interiorContains(p.y)
        }

        func interiorContains(other: Rect) -> Bool {
            return self.x.interiorContains(other.x) && self.y.interiorContains(other.y)
        }

        func intersects(other: Rect) -> Bool {
            return self.x.intersects(other.x) && self.y.intersects(other.y)
        }

        func interiorIntersects(other: Rect) -> Bool {
            return self.x.interiorIntersects(other.x) && self.y.interiorIntersects(other.y)
        }

        func addPoint(p: Point) -> Rect {
            return Rect(x: self.x.addPoint(p.x), y: self.y.addPoint(p.y))
        }

        func addRect(other: Rect) -> Rect {
            return Rect(x: self.x.union(other.x), y: self.y.union(other.y))
        }

        func clamPoint(p: Point) -> Point {
            return Point(x: self.x.clamPoint(p.x), y: self.y.clamPoint(p.y))
        }

        func expanded(margin: Point) -> Rect {
            let xx = self.x.expaneded(margin.x)
            let yy = self.y.expaneded(margin.y)

            if (xx.isEmpty() || yy.isEmpty()) {
                return Rect()
            }

            return Rect(x: xx, y: yy)
        }

        func expandedByMargin(margin: Double) -> Rect {
            return self.expanded(Point(x: margin, y: margin))
        }

        func union(other: Rect) -> Rect {
            return Rect(x: self.x.union(other.x), y: self.y.union(other.y))
        }

        func intersection(other: Rect) -> Rect {
            let xx = self.x.intersection(other.x)
            let yy = self.y.intersection(other.y)
            if xx.isEmpty() || y.isEmpty() {
                return Rect()
            }
            return Rect(x: xx, y: yy)
        }

        func approxEquals(r2: Rect) -> Bool {
            return self.x.approxEqual(r2.x) && self.y.approxEqual(r2.y)
        }

        var description: String {
            return "[Lo\(self.lo()), Hi\(self.hi())]"
        }
    }
}
