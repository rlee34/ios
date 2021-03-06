//
//  MapzenSearchDataObjectsTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/21/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
import Pelias

class MapzenSearchDataObjectsTests: XCTestCase {

  func testSearchRect() {
    let min = ios_sdk.GeoPoint(latitude: 70.0, longitude: 40.0)
    let max = ios_sdk.GeoPoint(latitude: 80.0, longitude: 50.0)
    let searchRect = SearchRect(minLatLong: min, maxLatLong: max)
    let rect = SearchBoundaryRect(minLatLong: SearchDataConverter.unwrapPoint(min), maxLatLong: SearchDataConverter.unwrapPoint(max))
    XCTAssertEqual(searchRect.rect, rect)
    XCTAssertEqual(searchRect, SearchRect(minLatLong: min, maxLatLong: max))
  }

  func testSearchCircle() {
    let center = ios_sdk.GeoPoint(latitude: 70.0, longitude: 40.0)
    let searchCircle = SearchCircle(center: center, radius: 8)
    let circle = SearchBoundaryCircle(center: SearchDataConverter.unwrapPoint(center), radius: 8)
    XCTAssertEqual(searchCircle.circle, circle)
    XCTAssertEqual(searchCircle, SearchCircle(center: center, radius: 8))
  }

  func testGeoPoint() {
    let point = ios_sdk.GeoPoint(latitude: 70.0, longitude: 40.0)
    let peliasPoint = Pelias.GeoPoint(latitude: 70.0, longitude: 40.0)
    XCTAssertEqual(point.point, peliasPoint)
    XCTAssertEqual(point, GeoPoint(latitude: 70.0, longitude: 40.0))
  }

  func testPlaceQueryItem() {
    let item = PlaceQueryItem(placeId: "id", dataSource: .geoNames, layer: .address)
    let peliasItem = PeliasPlaceQueryItem(placeId: "id", dataSource: .GeoNames, layer: .address)
    XCTAssertEqual(item.peliasItem.placeId, peliasItem.placeId)
    XCTAssertEqual(item.peliasItem.dataSource, peliasItem.dataSource)
    XCTAssertEqual(item.peliasItem.layer, peliasItem.layer)
    XCTAssertEqual(item, PlaceQueryItem(placeId: "id", dataSource: .geoNames, layer: .address))
  }
}
