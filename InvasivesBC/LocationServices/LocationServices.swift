//
//  LocationServices.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

class LocationServices {
    public static let shared = LocationServices()
    
    // MARK: Constants
    private static let e = 0.081819218048345;
    
    private let b: Double = 6378137;
    private let k0 = 0.9996;
    private let k1 = 0.9992;
    private let pi = Double.pi;
    
    private let e2 = pow(e, 2)
    private let e3 = pow(e, 3)
    private let e4 = pow(e, 4)
    private let e5 = pow(e, 5)
    private let e6 = pow(e, 6)
    private let e7 = pow(e, 7)
    
    // MARK: Initializer
    private init() {}
    
    // MARK: Utilities
    private func toRadian(deg: Double) -> Double {
        return (deg * Double.pi) / 180
    }
    
    private func toDegrees(rad: Double) -> Double {
        return (rad / Double.pi) * 180
    }
    
}

// MARK: Lat Long -> UTM
extension CLLocationCoordinate2D {
    public func toUTM() -> UTMCoordinate? {
        return LocationServices.shared.convertToUTM(coordinates: self)
    }
}

extension LocationServices {
    
    fileprivate func convertToUTM(coordinates: CLLocationCoordinate2D) -> UTMCoordinate? {
        guard let utmZone = getUTMZone(longitude: coordinates.longitude) else {return nil}
        guard let angleP = getAngleP(longitude: coordinates.longitude) else {return nil}
        
        let eP2 = e2 / (1 - e2);
        let angle1 = toRadian(deg: coordinates.longitude)
        let theta = toRadian(deg: coordinates.latitude)
        
        let n2 = b / pow(1 - e2 * pow(sin(theta), 2), 0.5)
        let t = pow(tan(theta), 2)
        let c = eP2 * pow(cos(theta), 2)
        let a = (angle1 - angleP) * cos(theta)
        let m = b * ((1 - e2 / 4 - (3 * e4) / 64 - (5 * e6) / 256) * theta - ((3 * e2) / 8 + (3 * e4) / 32 + (45 * e6) / 1024) * sin(2 * theta) + ((15 * e4) / 256 + (45 * e6) / 1024) * sin(theta * 4) - ((35 * e6) / 3072) * sin(6 * theta))
        
        let utmX = k0 * n2 * (a + ((1 - t + c) * pow(a, 3)) / 6 + ((5 - 18 * t + pow(t, 2) + 72 * c - 58 * eP2) * pow(a, 5)) / 120) + 500000
        
        let q1 = pow(a, 2) / 2
        let q2 = ((5 - t + 9 * c + 4 * pow(c, 2)) * pow(a, 4)) / 24
        let q3 = ((61 - 58 * t + pow(t, 2) + 600 * c - 330 * eP2) * pow(a, 6)) / 720
        
        let utmY = k0 * (m + n2 * tan(theta) * (q1 + q2 + q3))
        return UTMCoordinate(northings: utmY, eastings: utmX, zone: Int(utmZone))
    }
    
    private func getUTMZone(longitude: Double) -> Double? {
        if (longitude >= -114) {
            return 12
        } else if (longitude >= -120) {
            return 11
        } else if (longitude >= -126) {
            return 10
        } else if (longitude >= -132) {
            return 9
        } else if (longitude >= -138) {
            return 8
        } else if (longitude >= -144) {
            return 7
        }
        
        return nil
    }
    
    private func getAngleP(longitude: Double) -> Double? {
        var angleP: Double?
        
        if (longitude >= -114) {
            angleP = -111;
        } else if (longitude >= -120) {
            angleP = -117;
        } else if (longitude >= -126) {
            angleP = -123;
        } else if (longitude >= -132) {
            angleP = -129;
        } else if (longitude >= -138) {
            angleP = -135;
        } else if (longitude >= -144) {
            angleP = -141;
        }
        
        if let _angleP = angleP {
            angleP = toRadian(deg: _angleP)
        }
        
        return angleP;
    }
    
}

// MARK: UTM -> Lat Long

extension UTMCoordinate {
    public func toLatLong() -> CLLocationCoordinate2D? {
        return LocationServices.shared.convertToLatLong(utm: self)
    }
}

extension LocationServices {
    fileprivate func convertToLatLong(utm: UTMCoordinate) -> CLLocationCoordinate2D? {
        let y = utm.northings
        let x = utm.eastings
        var g1: Double = 0;
        switch (utm.zone) {
        case 12:
            g1 = -111
        case 11:
            g1 = -117
        case 10:
            g1 = -123
        case 9:
            g1 = -129
        case 8:
            g1 = -135
        case 7:
            g1 = -141
        default:
            return nil
        }
        
        let a = b
        let ee2 = 2 * (1 / 298.257222101) - pow(1 / 298.257222101, 2)
        let k = k0
        let eP2 = ee2 / (1 - ee2)
        let m = y / k
        let ee1 = (1 - pow(1 - ee2, 0.5)) / (1 + pow(1 - ee2, 0.5))
        let u = m / (a * (1 - ee2 / 4 - (3 * pow(ee2, 2)) / 64 - (5 * pow(ee2, 4)) / 256))
        let op = u + ((3 * ee1) / 2 - (27 * pow(ee1, 3)) / 32) * sin(2 * u) + ((21 * pow(ee1, 2)) / 16 - (55 * pow(ee1, 4)) / 32) * sin(4 * u) + ((151 * pow(ee1, 3)) / 96) * sin(6 * u)
        let c1 = eP2 * pow(cos(op), 2)
        let n1 = a / pow(1 - ee2 * pow(sin(op), 2), 0.5)
        let t1 = pow(tan(op), 2)
        let r1 =
            (a * (1 - ee2)) / pow(1 - e2 * pow(sin(op), 2), 3 / 2)
        let d = (x - 500000) / (n1 * k)
        let w1 = (op * 180) / pi
        let w2 = (n1 * tan(op)) / r1
        let w3 = pow(d, 2) / 2
        let w4 = ((5 + 3 * t1 + 10 * c1 - 4 * pow(c1, 2) - 9 * eP2) * pow(d, 4)) / 24
        let w5 = ((61 + 90 * t1 + 298 * c1 + 45 * pow(t1, 2) - 252 * eP2 - 3 * pow(c1, 2)) * pow(d, 6)) / 720
        let lat = w1 - w2 * (((w3 - w4 + w5) * 180) / pi)
        let g2 = ((1 + 2 * t1 + c1) * pow(d, 3)) / 6
        let g3 = ((5 - 2 * c1 + 28 * t1 - 3 * pow(c1, 2) + 8 * eP2 + 24 * pow(t1, 2)) * pow(d, 5)) / 120
        let cosOP = cos(op)
        let xlong = (((d - g2 + g3) / cosOP) * 180)
        let longitude = g1 +  xlong / pi
        let latitude = lat
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: Lat Long -> Albers
extension CLLocationCoordinate2D {
    public func toAlbers() -> AlbersCoordinate {
        return LocationServices.shared.convertToAlbers(coordinates: self)
    }
}
extension LocationServices {
    
    fileprivate func convertToAlbers(coordinates: CLLocationCoordinate2D) -> AlbersCoordinate {
        let a = b
        let e2 = 2 * (1 / 298.257) - pow(1 / 298.257, 2)
        let offsetX: Double = 1000000
        let offsetY: Double = 0
        
        let angle1 = toRadian(deg: 50)
        let angle2 = toRadian(deg: 58.5)
        let angle3 = toRadian(deg: 45)
        let angle4: Double = -126
        
        let angle1Squared = pow(sin(angle1), 2)
        let angle2Squared = pow(sin(angle2), 2)
        
        let latY = toRadian(deg: coordinates.latitude)
        let m1 = cos(angle1) / pow(1 - e2 * angle1Squared, 0.5)
        let m2 = cos(angle2) / pow(1 - e2 * angle2Squared, 0.5)
        let q1 = (1 - e2) * (sin(angle1) / (1 - e2 * pow(sin(angle1), 2)) - (1 / (2 * LocationServices.e)) * log((1 - LocationServices.e * sin(angle1)) / (1 + LocationServices.e * sin(angle1))))
        let q2 = (1 - e2) * (sin(angle2) / (1 - e2 * pow(sin(angle2), 2)) - (1 / (2 * LocationServices.e)) * log((1 - LocationServices.e * sin(angle2)) / (1 + LocationServices.e * sin(angle2))))
        let q0 = (1 - e2) * (sin(angle3) / (1 - e2 * pow(sin(angle3), 2)) - (1 / (2 * LocationServices.e)) * log((1 - LocationServices.e * sin(angle3)) / (1 + LocationServices.e * sin(angle3))))
        let n = (pow(m1, 2) - pow(m2, 2)) / (q2 - q1)
        let c = pow(m1, 2) + n * q1
        let p0 = (a * pow(c - n * q0, 0.5)) / n
        let q = (1 - e2) * (sin(latY) / (1 - e2 * pow(sin(latY), 2)) - (1 / (2 * LocationServices.e)) * log((1 - LocationServices.e * sin(latY)) / (1 + LocationServices.e * sin(latY))))
        let p = (a * pow(c - n * q, 0.5)) / n
        let theta = toRadian(deg: n * (coordinates.longitude - angle4))
        let albersX = p * sin(theta) + offsetX
        let albersY = p0 - p * cos(theta) + offsetY
        
        return AlbersCoordinate(x: albersX, y: albersY)
    }
}

// MARK: Albers -> Lat Long
extension AlbersCoordinate {
    public func toLatLong() -> CLLocationCoordinate2D {
        return LocationServices.shared.convertToLatLong(albers: self)
    }
}
extension LocationServices {
    fileprivate func convertToLatLong(albers: AlbersCoordinate) -> CLLocationCoordinate2D {
        let x = albers.x
        let y = albers.y
        let a = b
        let e2 = 2 * (1 / 298.257222101) - pow(1 / 298.257222101, 2)
        let e1 = pow(e2, 0.5)
        let albX = x - 1000000
        // parallel 1
        let angle1 = toRadian(deg: 50)
        // parallel 2
        let angle2 = toRadian(deg: 58.5)
        // parallel origin
        let angle3 = toRadian(deg: 45)
        // longitude origin
        let angle4: Double = -126
        let m1 = cos(angle1) / pow(1 - e2 * pow(sin(angle1), 2), 0.5)
        
        let m2 = cos(angle2) / pow(1 - e2 * pow(sin(angle2), 2), 0.5)
        
        let q1 = (1 - e2) * (sin(angle1) / (1 - e2 * pow(sin(angle1), 2)) - (1 / (2 * e1)) * log((1 - e1 * sin(angle1)) / (1 + e1 * sin(angle1))))
        let q2 = (1 - e2) * (sin(angle2) / (1 - e2 * pow(sin(angle2), 2)) - (1 / (2 * e1)) * log((1 - e1 * sin(angle2)) / (1 + e1 * sin(angle2))))
        let q0 = (1 - e2) * (sin(angle3) / (1 - e2 * pow(sin(angle3), 2)) - (1 / (2 * e1)) * log((1 - e1 * sin(angle3)) / (1 + e1 * sin(angle3))))
        
        let n = (pow(m1, 2) - pow(m2, 2)) / (q2 - q1)
        let c = pow(m1, 2) + n * q1
        let p0 = (a * pow(c - n * q0, 0.5)) / n
        let p = pow(pow(albX, 2) + pow(p0 - y, 2), 0.5)
        let q = (c - (pow(p, 2) * pow(n, 2)) / pow(a, 2)) / n
        let theta = (atan(albX / (p0 - y)) * 180) / pi
        let NewLong = angle4 + theta / n
        let Xm = q / (1 - ((1 - e2) / (2 * e1)) * log((1 - e1) / (1 + e1)))
        let Ba = (atan(Xm / pow(-Xm * Xm + 1, 0.5)) * 180) / pi
        let series1 = (((e2 / 3 + (31 * e2 * e2) / 180 + (517 * e2 * e2 * e2) / 5040) * sin((2 * Ba * pi) / 180) + ((23 * e2 * e2) / 360 + (251 * e2 * e2 * e2) / 3780) * sin((4 * Ba * pi) / 180)) * 180) / pi
        let NewLat = Ba + series1
        return CLLocationCoordinate2D(latitude: NewLat, longitude: NewLong)
    }
}

// MARK: Inside / Outside
extension CLLocationCoordinate2D {
    public func isInBC() -> Bool {
        return LocationServices.shared.isInsideBC(coordinates: self)
    }
}
extension LocationServices {
    private func getBCAlbersBoundry() -> [AlbersCoordinate] {
        guard let path = Bundle.main.path(forResource: "bcAlbersBoundry", ofType: "json") else { return []}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSON(data: data)
            var returnValue: [AlbersCoordinate] = []
            for item in jsonResult.arrayValue {
                if let x = item["x"].double, let y = item["y"].double {
                    returnValue.append(AlbersCoordinate(x: x, y: y))
                }
            }
            return returnValue
        } catch {
            print(error)
        }
        return []
    }
    
    fileprivate func isInsideBC(coordinates: CLLocationCoordinate2D) -> Bool {
        let boundry = getBCAlbersBoundry()
        let albers = coordinates.toAlbers()
        var intersections: Int = 0
        for index in 0..<(boundry.count - 1)  {
            let found = intersect(_x10: 1200000, y10: 900000, x20: albers.x, y20: albers.y, x30: boundry[index].x, y30: boundry[index].y, _x40: boundry[index + 1].x, y40: boundry[index + 1].y)
            
            if (found) {
                intersections += 1
            }
        }
        return intersections % 2 == 0
    }
    
    private func intersect(_x10: Double, y10: Double, x20: Double, y20: Double, x30: Double, y30: Double, _x40: Double, y40: Double) -> Bool {
        var x10 = _x10
        var x40 = _x40
        if (x10 == x20) {
            x10 = x10 + 1
        }
        
        if (x40 == x30) {
            x40 = x40 + 1
        }
        
        let m10 = (y20 - y10) / (x20 - x10)
        let b10 = y10 - (m10 * x10)
        let m20 = (y40 - y30) / (x40 - x30)
        let b20 = y30 - (m20 * x30)
        
        var x50: Double = 0
        var y50: Double = 0
        
        if ((m10 - m20) != 0) {
            x50 = (b20 - b10) / (m10 - m20)
            y50 = m10 * x50 + b10
        } else {
            x50 = 0
            y50 = m10 * x50 + b10
        }
        if (
            ((x50 >= x30 && x50 <= x40) || (x50 >= x40 && x50 <= x30)) &&
                ((x50 >= x10 && x50 <= x20) || (x50 >= x20 && x50 <= x10))
            ) {
            return true
        } else {
            return false
        }
    }
}

// MARK: Hex

extension CLLocationCoordinate2D {
    public func hex() -> HexLocation? {
        return LocationServices.shared.getHexLocation(for: self)
    }
}

extension LocationServices {
    
    fileprivate class Target {
        var hexID: Int
        var xAlb0: Double
        var yAlb0: Double
        var xLon0: Double
        var yLat0: Double
        
        var keep = false
        var index = -1
        var xLon1: Double = 0
        var xLat1: Double = 0
        var yLon1: Double = 0
        var yLat1: Double = 0
        
        var xLon2: Double = 0
        var xLat2: Double = 0
        var yLon2: Double = 0
        var yLat2: Double = 0
        
        var xLon3: Double = 0
        var xLat3: Double = 0
        var yLon3: Double = 0
        var yLat3: Double = 0
        
        var xLon4: Double = 0
        var xLat4: Double = 0
        var yLon4: Double = 0
        var yLat4: Double = 0
        
        var xLon5: Double = 0
        var xLat5: Double = 0
        var yLon5: Double = 0
        var yLat5: Double = 0
        
        var xLon6: Double = 0
        var xLat6: Double = 0
        var yLon6: Double = 0
        var yLat6: Double = 0
        
        
        init(hexID: Int, xAlb0: Double, yAlb0: Double, xLon0: Double, yLat0: Double) {
            self.hexID = hexID
            self.yAlb0 = yAlb0
            self.xAlb0 = xAlb0
            self.xLon0 = xLon0
            self.yLat0 = yLat0
        }
    }
    
    fileprivate struct NeighborOffset {
        var offX: Int
        var offY: Int
        init(offX: Int, offY: Int) {
            self.offX = offX
            self.offY = offY
        }
    }
    
    fileprivate func getHexLocation(for coordinates: CLLocationCoordinate2D) -> HexLocation? {
        let r3 = pow(3, 0.5)
        let radiusO = pow(((10000 * 2) / (3 * (r3))), 0.5)
        let radiusI = radiusO / 2 * r3
        let yheight = radiusO / 2
        let yheight2 = radiusO + yheight
        let xWidth2 = radiusO * r3
        let hexPTS = getHexRules()
        
        // Local variables
        var gridID = 0
        var hexagons: [Target] = []
        var target: Target?
        var target7: [Target] = [] //
        // Center of the province
        let startX: Double = -126
        let startY: Double = 54
        let provinceCenter = CLLocationCoordinate2D(latitude: startY, longitude: startX)
        // Convert center to albers
        let albersResult = provinceCenter.toAlbers()
        var albersX0 = albersResult.x
        var albersY0 = albersResult.y
        
        // Convert target lat long to albers
        let albersTargetResult = coordinates.toAlbers()
        let albersX0new = albersTargetResult.x
        let albersY0new = albersTargetResult.y
        
        // Find Target relative to center
        let deltaX = albersX0new - albersX0
        let deltaY = albersY0new - albersY0
        
        let ticX: Int = Int(floor(deltaX / xWidth2))
        var ticY: Int = Int(round(deltaY / yheight2))
        
        if ((ticY % 2) != 0) {
            ticY = ticY - 1
        }
        
        let ticXlow = ticX - 4
        let ticXhigh = ticX + 8
        var ticYlow = 0
        var ticYhigh = 0
        if (ticY > 0) {
            ticYlow = -2
            ticYhigh = 6
        } else {
            ticYlow = -4
            ticYhigh = 4
        }
        
        /* Part 1 Create set of hexagons cells centered around the target (patch) */
        albersX0 = albersX0 + Double(ticX) * radiusI
        albersY0 = albersY0 + Double(ticY) * yheight2
        
        let sequenceY = stride(from: ticYlow, to: ticYhigh, by: 2)
        let sequenceX = stride(from: ticXlow, to: ticXhigh, by: 2)
        for iy in sequenceY {
            for ix in sequenceX {
                let tempx = albersX0 + (Double(ix) * radiusI)
                let tempy = albersY0 + (Double(iy) * yheight2)
                let albers = AlbersCoordinate(x: tempx, y: tempy)
                gridID = gridID + 1
                hexagons.append(Target(hexID: gridID, xAlb0: tempx, yAlb0: tempy, xLon0: albers.toLatLong().longitude, yLat0: albers.toLatLong().latitude))
            }
        }
        
        let sequenceY2 = stride(from: ticYlow + 1, to: ticYhigh, by: 2)
        let sequenceX2 = stride(from: ticXlow - 1, to: ticXhigh, by: 2)
        for iy in sequenceY2 {
            for ix in sequenceX2 {
                let tempx = albersX0 + (Double(ix) * radiusI)
                let tempy = albersY0 + (Double(iy) * yheight2)
                let albers = AlbersCoordinate(x: tempx, y: tempy)
                gridID = gridID + 1
                hexagons.append(Target(hexID: gridID, xAlb0: tempx, yAlb0: tempy, xLon0: albers.toLatLong().longitude, yLat0: albers.toLatLong().latitude))
            }
        }
        
        let totalHEX = gridID
        
        /* Part 2 Cycle through the patch and find the cell center closest to the raw target */
        var dxyOLD: Double = 999999
        var targetID: Int = 0
        for i in 1...totalHEX {
            let _hexagon = hexagons.first { (item) -> Bool in
                return item.hexID == i
            }
            guard let hexagon = _hexagon else {continue}
            let dxy = pow((pow((hexagon.xAlb0 - albersX0new), 2) + pow((hexagon.yAlb0 - albersY0new), 2)), 0.5)
            if (dxy < dxyOLD) {
                dxyOLD = dxy
                targetID = i
            }
        }
        
        /*
         Populate the target(1) array with the key attibutes
         Target(1) is the key element determined from this entire application.
         */
        let _hexagonTarget = hexagons.first { (item) -> Bool in
            return item.hexID == targetID
        }
        guard let hexagonTarget = _hexagonTarget else {
            print("Error while finding target hex")
            return nil
        }
        
        target = Target(hexID: 1, xAlb0: hexagonTarget.xAlb0, yAlb0: hexagonTarget.yAlb0, xLon0: hexagonTarget.xLon0, yLat0: hexagonTarget.yLat0)
        
        /* determine HexID as a composite of the lat/long */
        
        guard let targetLat = target?.yLat0, var targetLong = target?.xLon0 else {return nil}
        targetLong = Double(abs(targetLong))
        var stringTargetLong = String(targetLong)
        stringTargetLong = stringTargetLong.replacingOccurrences(of: ".", with: "")
        stringTargetLong = String(stringTargetLong.prefix(6))
        var stringTargetLat = String(targetLat)
        stringTargetLat = stringTargetLat.replacingOccurrences(of: ".", with: "")
        stringTargetLat = String(stringTargetLat.prefix(6))
        
        let stringTargetId = "\(stringTargetLat)\(stringTargetLong)"
        guard let targetIdInt: Int = Int(stringTargetId) else {return nil}
        target?.hexID = targetIdInt
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /* Part 3 find the 18 surrounding cells to the target (optional)
         The closest 19 hexagon cells fall with 230m of the ceter of the target cell
         Assign “keep=1” to those patch cells proximal to the target */
        
        for i in 1...totalHEX {
            let _hexagon = hexagons.first { (item) -> Bool in
                return item.hexID == i
            }
            guard var hexagon = _hexagon, let target = target else {continue}
            let dxy = pow((pow((hexagon.xAlb0 - target.xAlb0), 2) + pow((hexagon.yAlb0 - target.yAlb0), 2)), 0.5)
            if (dxy < 130) {
                hexagon.keep = true
            }
        }
        var kk = 0
        for i in 1...totalHEX {
            let _hexagon = hexagons.first { (item) -> Bool in
                return item.hexID == i
            }
            guard var hexagon = _hexagon else {continue}
            var newTarget: Target = Target(hexID: 0, xAlb0: 0, yAlb0: 0, xLon0: 0, yLat0: 0)
            newTarget.index = i
            guard hexagon.keep else {continue}
            kk = kk + 1
            newTarget.hexID = kk
            newTarget.xAlb0 = hexagon.xAlb0
            newTarget.yAlb0 = hexagon.yAlb0
            newTarget.xLon0 = hexagon.xLon0
            newTarget.yLat0 = hexagon.yLat0
            for j in 1...6 {
                let nx: Double = 30 + (Double(j) - 1) * 60
                var xC1 = cos(nx / 180 * pi) * radiusO
                var yC1 = sin(nx / 180 * pi) * radiusO
                let xC0 = xC1
                let yC0 = yC1
                xC1 = xC0 * cos((-60) / 180 * pi) - yC0 * sin((-60) / 180 * pi)
                yC1 = xC0 * sin((-60) / 180 * pi) + yC0 * cos((-60) / 180 * pi)
                
                let tempAlbers = AlbersCoordinate(x: hexagon.xAlb0 + xC1, y: hexagon.yAlb0 + yC1)
                let coordinates = tempAlbers.toLatLong()
                switch (j) {
                case 1:
                    newTarget.xLon1 = coordinates.longitude
                    newTarget.yLat1 = coordinates.latitude
                    hexagon.xLon1 = coordinates.longitude
                    hexagon.yLat1 = coordinates.latitude
                case 2:
                    newTarget.xLon2 = coordinates.longitude
                    newTarget.yLat2 = coordinates.latitude
                    hexagon.xLon2 = coordinates.longitude
                    hexagon.yLat2 = coordinates.latitude
                    
                case 3:
                    newTarget.xLon3 = coordinates.longitude
                    newTarget.yLat3 = coordinates.latitude
                    hexagon.xLon3 = coordinates.longitude
                    hexagon.yLat3 = coordinates.latitude
                    
                case 4:
                    newTarget.xLon4 = coordinates.longitude
                    newTarget.yLat4 = coordinates.latitude
                    hexagon.xLon4 = coordinates.longitude
                    hexagon.yLat4 = coordinates.latitude
                    
                case 5:
                    newTarget.xLon5 = coordinates.longitude
                    newTarget.yLat5 = coordinates.latitude
                    hexagon.xLon5 = coordinates.longitude
                    hexagon.yLat5 = coordinates.latitude
                    
                case 6:
                    newTarget.xLon6 = coordinates.longitude
                    newTarget.yLat6 = coordinates.latitude
                    hexagon.xLon6 = coordinates.longitude
                    hexagon.yLat6 = coordinates.latitude
                default:
                    continue
                }
            }
            target7.append(newTarget)
        }
        
        /* Part 3 Determine the StrataID of the raw within the hexagon */
//        for _ in 1...7 {
//            for i in 1...157 {
//                let _currentTarget = target7.first { (item) -> Bool in
//                    return item.index == i
//                }
//                let _hexaPoint = hexPTS.first { (item) -> Bool in
//                    item.index == i
//                }
//                guard let currentTarget = _currentTarget, var hexaPoint = _hexaPoint  else {continue}
//
//                hexaPoint.absX = currentTarget.xAlb0 + hexaPoint.offX
//                hexaPoint.absY = currentTarget.yAlb0 + hexaPoint.offY
//            }
//        }
//
//        for i in 1...157 {
//            let _hexaPoint = hexPTS.first { (item) -> Bool in
//                item.index == i
//            }
//            guard var hexaPoint = _hexaPoint, let target = target else {continue}
//            hexaPoint.absX = target.xAlb0 + hexaPoint.offX
//            hexaPoint.absY = target.yAlb0 + hexaPoint.offY
//        }
//
//        /* find closest strata point */
//        dxyOLD = 1000
//        var dxyID = 0
//        for i in 62...157 {
//            let _hexaPoint = hexPTS.first { (item) -> Bool in
//                item.index == i
//            }
//            guard var hexaPoint = _hexaPoint, let target = target else {continue}
//            hexaPoint.absX = target.xAlb0 + hexaPoint.offX
//            hexaPoint.absY = target.yAlb0 + hexaPoint.offY
//
//            let dxy = pow((pow((hexaPoint.absX - albersX0new), 2) + pow((hexaPoint.absY - albersY0new), 2)), 0.5)
//            if (dxy < dxyOLD) {
//                dxyOLD = dxy
//                dxyID = i
//            }
//
//        }
//
//        let _hexaPoint = hexPTS.first { (item) -> Bool in
//            item.index == dxyID
//        }
//        guard let hexaPoint = _hexaPoint else {return nil}
//        let strataID = hexaPoint.ptID
        
        // Clean array so that only objects with a target id exist
        var cleanTargets: [Target] = []
        for _target in target7 where _target.hexID != -1 {
            cleanTargets.append(_target)
        }
        guard let _target = target else {return nil}
        var _neighbors: [Int] = []
        _neighbors = getNeighbor(offsets: getNeighborOffsets(), target: _target, target7: target7, neighbors: _neighbors)
        let neighbors = Array(_neighbors.reversed())
        return HexLocation(cc: neighbors[0], ur: neighbors[1], cr: neighbors[2], lr: neighbors[3], ll: neighbors[4], cl: neighbors[5], ul: neighbors[6])
    }
    
    private func getNeighborOffsets() -> [NeighborOffset] {
        var neighborOffsets: [NeighborOffset] = []
        neighborOffsets.append(NeighborOffset(offX: 0, offY: 0))
        neighborOffsets.append(NeighborOffset(offX: 60, offY: 100))
        neighborOffsets.append(NeighborOffset(offX: 100, offY: 0))
        neighborOffsets.append(NeighborOffset(offX: 60, offY: -100))
        neighborOffsets.append(NeighborOffset(offX: -60, offY: -100))
        neighborOffsets.append(NeighborOffset(offX: -100, offY: 0))
        neighborOffsets.append(NeighborOffset(offX: -60, offY: 100))
        return neighborOffsets
    }
    
    private func getNeighbor(offsets _offsets: [NeighborOffset], target: Target, target7: [Target], neighbors: [Int])-> [Int] {
        var offsets = _offsets
      
        guard let offset: NeighborOffset = offsets.popLast() else {
            return neighbors
        }
        
         struct Final7 {
            var xAlb0: Double
            var yAlb0: Double
            var xLon0: Double
            var yLat0: Double
            
            init(xAlb0: Double, yAlb0: Double, xLon0: Double, yLat0: Double) {
                self.xAlb0 = xAlb0
                self.yAlb0 = yAlb0
                self.xLon0 = xLon0
                self.yLat0 = yLat0
            }
        }
       
        var dxy: Double = 100
       
        let offX: Double = Double(offset.offX)
        let offy: Double = Double(offset.offY)
        
        var closestTarget: Target?
        
        for targetItem in target7 {
            dxy = pow((pow((targetItem.xAlb0 - target.xAlb0 - offX), 2) + pow((targetItem.yAlb0 - target.yAlb0 - offy), 2)), 0.5)
            if (dxy < 50) {
                closestTarget = targetItem
            }
        }
        
        guard let _closestTarget = closestTarget else {return []}
        
        let final7 = Final7(xAlb0: _closestTarget.xAlb0, yAlb0: _closestTarget.yAlb0, xLon0: _closestTarget.xLon0, yLat0: _closestTarget.yLat0)

        
        var bchexID = (floor(final7.yLat0) * 10000 + floor((final7.yLat0 - floor(final7.yLat0)) * 10000))
        bchexID = bchexID * 1000000
        bchexID = floor(bchexID + ((floor(-1 * final7.xLon0)) - 100) * 10000 + (-1 * final7.xLon0 - floor(-1 * final7.xLon0)) * 10000)
        var _neighbors = neighbors
        _neighbors.append(Int(bchexID))
        return getNeighbor(offsets: offsets, target: target, target7: target7, neighbors: _neighbors)
    }
    
    private func getHexRules() -> [HexRule] {
        guard let path = Bundle.main.path(forResource: "hexRules", ofType: "json") else { return []}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSON(data: data)
            var returnValue: [HexRule] = []
            for item in jsonResult.arrayValue {
                guard let index = item["index"].int else {continue}
                guard let ptID = item["ptID"].int else {continue}
                guard let ruleX = item["ruleX"].string else {continue}
                guard let ruleY = item["ruleY"].string else {continue}
                guard let ptX = item["ptX"].double else {continue}
                guard let ptY = item["ptY"].double else {continue}
                guard let offX = item["offX"].double else {continue}
                guard let offY = item["offY"].double else {continue}
                returnValue.append(HexRule(index: index, ptID: ptID, ruleX: ruleX, ruleY: ruleY, ptX: ptX, ptY: ptY, offX: offX, offY: offY))
            }
            return returnValue
        } catch {
            print(error)
        }
        return []
    }
}
