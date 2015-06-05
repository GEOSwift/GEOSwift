//
//  ViewController.swift
//  HumboldtDemo
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import UIKit
import MapKit
import Humboldt

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let polygon = Geometry.create("POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))") as? Polygon {
            let overlay = polygon.mapShape() as! MKOverlay
            self.mapView.addOverlay(overlay)
        }
        self.mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolygon {
            var polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
            polygonRenderer.lineWidth = 2.0
            polygonRenderer.fillColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)

            return polygonRenderer
        }
        return nil
    }
}