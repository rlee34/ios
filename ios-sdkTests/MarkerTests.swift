//
//  MarkerTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/22/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import TangramMap

class MarkerTests: XCTestCase {

  let marker = Marker()

  func testPoint() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    marker.point = point
    XCTAssertEqual(marker.point.latitude, point.latitude)
    XCTAssertEqual(marker.point.longitude, point.longitude)
    XCTAssertEqual(marker.tgMarker.point.latitude, point.latitude)
    XCTAssertEqual(marker.tgMarker.point.longitude, point.longitude)
    XCTAssertTrue(marker.tgMarker.stylingString.contains("style: 'points'"))
    XCTAssertFalse(marker.tgMarker.stylingString.contains("size:"))
  }

  func testPolyline() {
    let polyline = TGGeoPolyline()
    marker.polyline = polyline
    XCTAssertEqual(marker.polyline, polyline)
    XCTAssertEqual(marker.tgMarker.polyline, polyline)
    XCTAssertTrue(marker.tgMarker.stylingString.contains("style: 'lines'"))
    XCTAssertFalse(marker.tgMarker.stylingString.contains("size:"))
  }

  func testPolygon() {
    let polygon = TGGeoPolygon()
    marker.polygon = polygon
    XCTAssertEqual(marker.polygon, polygon)
    XCTAssertEqual(marker.tgMarker.polygon, polygon)
    XCTAssertTrue(marker.tgMarker.stylingString.contains("style: 'polygons'"))
    XCTAssertFalse(marker.tgMarker.stylingString.contains("size:"))
  }

  //TODO: failing, fix
//  func testIcon() {
//    let icon = UIImage(named: "ic_find_me_normal")
//    let map = MapViewController()
//    _ = map.view
//    try? map.loadStyle(.bubbleWrap)
//    map.addMarker(marker)
//    marker.icon = icon
//    XCTAssertEqual(marker.icon, icon)
//    XCTAssertEqual(marker.tgMarker.icon, icon)
//    XCTAssertTrue(marker.tgMarker.stylingString.contains("style: 'points'"))
//    XCTAssertEqual(marker.size, icon?.size)
//    XCTAssertTrue(marker.tgMarker.stylingString.contains("size: [\(icon?.size.width)px, \(icon?.size.height)px]"))
//  }

  func testVisible() {
    XCTAssertTrue(marker.visible)
    XCTAssertTrue(marker.tgMarker.visible)
    marker.visible = false
    XCTAssertFalse(marker.visible)
    XCTAssertFalse(marker.tgMarker.visible)
  }

  func testDrawOrder() {
    XCTAssertEqual(marker.drawOrder, 0)
    XCTAssertEqual(marker.tgMarker.drawOrder, 0)
    marker.drawOrder = 8
    XCTAssertEqual(marker.drawOrder, 8)
    XCTAssertEqual(marker.tgMarker.drawOrder, 8)
  }

  func testSize() {
    XCTAssertEqual(marker.size, CGSize.zero)
    let size = CGSize(width: 8, height: 8)
    marker.size = size
    XCTAssertEqual(marker.size, size)
    XCTAssertTrue(marker.tgMarker.stylingString.contains("size: [\(size.width)px, \(size.height)px]"))
  }

  func testBackgroundColor() {
    XCTAssertEqual(marker.backgroundColor, UIColor.white)
    let bgColor = UIColor.red
    marker.backgroundColor = bgColor
    let hex = bgColor.hexValue()
    XCTAssertEqual(marker.backgroundColor, bgColor)
    XCTAssertTrue(marker.tgMarker.stylingString.contains("color: '\(hex)'"))
  }

  func testInteractive() {
    XCTAssertTrue(marker.interactive)
    marker.interactive = false
    XCTAssertFalse(marker.interactive)
    XCTAssertTrue(marker.tgMarker.stylingString.contains("interactive: false"))
  }

  func testInitWithSize() {
    let size = CGSize(width: 30, height: 30)
    let m = Marker.init(size: size)
    XCTAssertEqual(m.size, size)
    XCTAssertEqual(m.backgroundColor, UIColor.white)
    XCTAssertTrue(m.interactive)
    XCTAssertTrue(m.tgMarker.stylingString.contains("size: [\(size.width)px, \(size.height)px]"))
  }

  func testInit() {
    let m = Marker.init()
    XCTAssertEqual(m.backgroundColor, UIColor.white)
    XCTAssertTrue(m.interactive)
    XCTAssertFalse(m.tgMarker.stylingString.contains("size:"))
  }
  
//  func testInitWithIcon() {
//    let image = UIImage(named: "ic_find_me_normal")
//    let m = Marker.init(icon: image)
//    XCTAssertEqual(m.size, image?.size)
//    XCTAssertEqual(m.backgroundColor, UIColor.white)
//    XCTAssertTrue(m.interactive)
//    XCTAssertEqual(m.icon, image)
//  }

  func testSetPointEased() {
    let point = TGGeoPoint(longitude: 70.0, latitude: 40.0)
    let tgMarker = TestTGMarker()
    let m = Marker(tgMarker: tgMarker)
    _ = m.setPointEased(point, seconds: 4, easeType: .linear)
    XCTAssertEqual(tgMarker.coordinates.latitude, 40.0)
    XCTAssertEqual(tgMarker.coordinates.longitude, 70.0)
    XCTAssertEqual(tgMarker.seconds, 4)
    XCTAssertEqual(tgMarker.ease, .linear)
  }

  func testTypeCurrentLocation() {
    let m = Marker.initWithMarkerType(.currentLocation)
    XCTAssertEqual(m.tgMarker.stylingPath, "layers.mz_current_location_gem.draw.ux-location-gem-overlay")
    XCTAssertTrue(m.tgMarker.stylingString.isEmpty)
  }

  func testTypeSearchPin() {
    let m = Marker.initWithMarkerType(.searchPin)
    XCTAssertEqual(m.tgMarker.stylingPath, "layers.mz_search_result.draw.ux-icons-overlay")
    XCTAssertTrue(m.tgMarker.stylingString.isEmpty)
  }

  func testTypeRouteLine() {
    let m = Marker.initWithMarkerType(.routeLine)
    XCTAssertEqual(m.tgMarker.stylingPath, "layers.mz_route_line.draw.ux-route-line-overlay")
    XCTAssertTrue(m.tgMarker.stylingString.isEmpty)
  }

  func testTypeCurrentLocationInactive() {
    let m = Marker.initWithMarkerType(.currentLocation)
    m.active = false
    // there is no inactive draw rule for curr location so its same as active state
    XCTAssertEqual(m.tgMarker.stylingPath, "layers.mz_current_location_gem.draw.ux-location-gem-overlay")
    XCTAssertTrue(m.tgMarker.stylingString.isEmpty)
  }

  func testTypeSearchPinInactive() {
    let m = Marker.initWithMarkerType(.searchPin)
    m.active = false
    XCTAssertEqual(m.tgMarker.stylingPath, "layers.mz_search_result.inactive.draw.ux-icons-overlay")
    XCTAssertTrue(m.tgMarker.stylingString.isEmpty)
  }

  func testTypeRouteLineInactive() {
    let m = Marker.initWithMarkerType(.routeLine)
    m.active = false
    // there is no inactive draw rule for route line so its same as active state
    XCTAssertEqual(m.tgMarker.stylingPath, "layers.mz_route_line.draw.ux-route-line-overlay")
    XCTAssertTrue(m.tgMarker.stylingString.isEmpty)
  }
}

class TestTGMarker : TGMarker {

  var coordinates: TGGeoPoint = TGGeoPoint()
  var seconds: Float = 0
  var ease: TGEaseType = .cubic

  private var internalMap: TGMapViewController?

  override public var map : TGMapViewController? {
    set {
      internalMap = newValue
    }
    get {
      return internalMap
    }
  }

  open override func setPointEased(_ c: TGGeoPoint, seconds s: Float, easeType e: TGEaseType) -> Bool {
    coordinates = c
    seconds = s
    ease = e
    return true
  }
}
