//
//  ViewController.swift
//  ofo
//
//  Created by 吴灶洲 on 2017/7/4.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var btnView: UIView!
    var mapView: MAMapView?
    var search: AMapSearchAPI!
    var pin: MyPinAnnotation!
    var pinView: MAAnnotationView!
    var nearBySearch = true
    //起点和终点坐标
    var start, end: CLLocationCoordinate2D!
    var walkManager: AMapNaviWalkManager = AMapNaviWalkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MAMapView.init(frame: view.bounds)
        view.addSubview(mapView!)
        view.bringSubview(toFront: btnView!)
        mapView?.delegate = self
        mapView?.zoomLevel = 19
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode = .follow
        
        walkManager.delegate = self
        
        search = AMapSearchAPI()
        search.delegate = self
        
        navigationItem.titleView = UIImageView.init(image: #imageLiteral(resourceName: "Login_Logo"))
        navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "user_center_icon").withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil);
        
        
        
        
        if let revealVC = revealViewController() {
            revealVC.rearViewRevealWidth = 251
            navigationItem.leftBarButtonItem?.target = revealVC;
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    // 搜索周边小黄车
    func searchBikeNearby() {
        searchCustomLocal(center: (mapView?.userLocation.coordinate)!)
    }

    func searchCustomLocal(center: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "超市"
        request.radius = 500
        request.requireExtension = true
        
        search.aMapPOIAroundSearch(request)
        
    }
    
    @IBAction func locationBtn(_ sender: Any) {
        nearBySearch = true
        searchBikeNearby()
    }
    
    /// 大头针动画
    func pinAnimation() {
        //坠落效果，y周位移
        let endFrame = pinView.frame
        pinView.frame = endFrame.offsetBy(dx: 0, dy: -16)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            self.pinView.frame = endFrame
        }, completion: nil)
        
    }

}


// MARK: - 导航的代理
extension ViewController: AMapNaviWalkManagerDelegate {
    /// 规划路线
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("路线规划")
        mapView?.removeOverlays(mapView?.overlays)
        var coordinates = walkManager.naviRoute?.routeCoordinates!.map{
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
        
        let polyLine = MAPolyline(coordinates: &coordinates!, count: UInt(coordinates!.count))
        mapView?.add(polyLine)
        
        let walkMinute = (walkManager.naviRoute?.routeTime)! / 60
        var timeDesc = "一分钟以内"
        if walkMinute > 0 {
            timeDesc = "\(walkMinute)分钟"
        }
        let hintTitle = "步行"+timeDesc
        let hintSubTitle = "距离\(walkManager.naviRoute?.routeLength)米"
        
//        let 
        
    }
}


// MARK: - MAMapViewDelegate
extension ViewController: MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        if overlay is MAPolyline {
            pin.isLockedToScreen = false
            mapView.visibleMapRect = overlay.boundingMapRect
            
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.blue
            
            return renderer
        }
        return nil
    }
    
    
    /// 点击小黄车
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        start = pin.coordinate
        end = view.annotation.coordinate
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
        
        
    }
    
    /// 小黄车出现的动画效果
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        
        for aview in aViews {
            guard aview.annotation is MAPointAnnotation else {
                continue
            }
            aview.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
                aview.transform = .identity
            }, completion: nil)
            
        }
    }
    
    /// 用户移动地图
    ///
    /// - Parameters:
    ///   - mapView: 地图
    ///   - wasUserAction: 用户是否移动
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            pin.isLockedToScreen = true
            pinAnimation()
            searchCustomLocal(center: mapView.centerCoordinate)
        }
    }
    
    
    /// 自定义大头针
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //用户定义的位置不需要自定义
        if annotation is MAUserLocation {
            return nil
        }
        
        if annotation is MyPinAnnotation {
            let reuseid = "anchor"
            var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
            if av == nil {
                av = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            }
            av?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            av?.canShowCallout = false
            
            pinView = av
            
            return av
        }
        
        let reuseid = "myid";
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView
        
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
        }
        
        if annotation.title == "正常可以用" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }else {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }
        
        annotationView?.canShowCallout = true
//        annotationView?.animatesDrop = true
        
        return annotationView
    }
    
    /// 地图初始化完成
    func mapInitComplete(_ mapView: MAMapView!) {
        pin = MyPinAnnotation()
        pin.coordinate = mapView.centerCoordinate
        pin.lockedScreenPoint = view.center
        pin.isLockedToScreen = true
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        
    }
    
    
}


// MARK: - AMapSearchDelegate
extension ViewController: AMapSearchDelegate {
    //搜索周边完成后的处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count > 0 else {
            print("周边没有小黄车")
            return
        }
        
        var anotations: [MAPointAnnotation] = []
        anotations = response.pois.map{
            let anotation = MAPointAnnotation()
            anotation.coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            if $0.distance < 200 {
                anotation.title = "红包区域内开锁任意小黄车"
                anotation.subtitle = "骑行10分钟可获得现金红包"
            }else {
                anotation.title = "正常可以用"
            }
            
            return anotation
        }
        
        mapView?.addAnnotations(anotations)
        if nearBySearch {//用户第一次搜索
            mapView?.showAnnotations(anotations, animated: true)
            nearBySearch = false
        }
        
        
        
    }
}





