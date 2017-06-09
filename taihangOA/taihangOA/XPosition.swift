//
//  position.swift
//  OA
//
//  Created by X on 15/5/9.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation

typealias coordinateBlock = (CLLocationCoordinate2D?)->Void
typealias positionBlock = (BMKReverseGeoCodeResult?)->Void

final class XPosition:NSObject,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {
    
    var locationService:BMKLocationService?
    var searcher:BMKGeoCodeSearch?
    var block:positionBlock?
    var cblock:coordinateBlock?
    var distanceFilter:CLLocationDistance = 100.0
    var desiredAccuracy:CLLocationAccuracy = kCLLocationAccuracyBest
    
    var postion:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var location:BMKReverseGeoCodeResult?
    
    static let Share = XPosition()
    
    private override init()
    {
        super.init()
    }
    
    func getCoordinate(block:@escaping coordinateBlock)
    {
        self.cblock = block
        self.getLocation()
    }
    
    func getLocationInfo(block:@escaping positionBlock)
    {
        self.block=block
        self.getLocation()
    }
    
    func getLocation()
    {
        stop()
        
        locationService=BMKLocationService()
        locationService?.distanceFilter = distanceFilter
        locationService?.desiredAccuracy = desiredAccuracy
        locationService?.delegate = self
        searcher=BMKGeoCodeSearch()
        searcher?.delegate = self
        locationService?.startUserLocationService()
    }
    
    func stop()
    {
        locationService?.stopUserLocationService()
        locationService?.delegate=nil
        locationService=nil
        searcher?.delegate = nil
        searcher=nil
    }
    
    func didFailToLocateUserWithError(_ error: Error!) {
        print(error)
        XPosition.Share.cblock?(nil)
        XPosition.Share.block?(nil)
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        postion = userLocation.location.coordinate
        self.cblock?(userLocation.location.coordinate)
        
        let reverseGeoCodeSearchOption=BMKReverseGeoCodeOption()
        reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate
        if let flag = searcher?.reverseGeoCode(reverseGeoCodeSearchOption)
        {
            if !flag{
                self.block?(nil)
            }
        }
        else
        {
            self.block?(nil)
        }

    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if(error.rawValue==BMK_SEARCH_NO_ERROR.rawValue)
        {
            location = result
            block?(result)
        }
        else
        {
            block?(nil)
        }

    }
    
}
