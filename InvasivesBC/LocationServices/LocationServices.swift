//
//  LocationServices.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import MapKit

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
    
    public func convertToUTM(coordinates: CLLocationCoordinate2D) -> UTMCoordinate? {
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
    public func convertToLatLong(utm: UTMCoordinate) -> CLLocationCoordinate2D? {
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
    
    public func convertToAlbers(coordinates: CLLocationCoordinate2D) -> AlbersCoordinate {
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
    public func convertToLatLong(albers: AlbersCoordinate) -> CLLocationCoordinate2D {
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

