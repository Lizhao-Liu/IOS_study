//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Lizhao Liu on 10/05/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var mapView: MKMapView!
    
    //override loadView() to create an instance of MKMapView
    override func loadView(){
        //create a map view
        mapView = MKMapView()
        //set it as the view of this view controller
        view = mapView
        
        //a segmented control allows the user to choose among a discrete set of options
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        // use safe area layout guide to tackle the overlapping issue
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        // every view has a layoutMargins property, we use layoutMarginGuide, which exposes anchors that are tied to the edges of the layoutMargins
//        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        //call the addConstraint() or removeConstraint() to the nearest common ancestor
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("map view controller loaded its view")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}
