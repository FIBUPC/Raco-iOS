//
//  MapViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 03/03/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import MapKit
import Kml_swift

class MapViewController: UIViewController {
	
	@IBOutlet weak var menuButton: UIBarButtonItem!
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if self.revealViewController() != nil {
			menuButton.target = self.revealViewController()
			menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
			self.revealViewController().rearViewRevealWidth = 300
		}
		
		mapView.delegate = self
		mapView.register(Kml_swift.KMLAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		loadKml("sample")
		
		let initialLocation = CLLocationCoordinate2D(latitude: 41.389391, longitude: 2.113376)
		let coordianteRegion = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
		mapView.setRegion(coordianteRegion, animated: true)
		
	}
	
	func loadKml(_ path: String) {
		let url = Bundle.main.url(forResource: "FIB", withExtension: "kml")
		KMLDocument.parse(url: url!, callback:
			{ [unowned self] (kml) in
				// Add overlays
				self.mapView.addOverlays(kml.overlays)
				// Add annotations
				self.mapView.showAnnotations(kml.annotations, animated: true)
			}
		)
	}
	
}

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		view.canShowCallout = true
		view.subtitleVisibility = .hidden
		view.calloutOffset = CGPoint(x: 0, y: 2)
		let title = annotation.title!!
		view.glyphText = String(title.first!)
		
		if (annotation.subtitle != nil) {
			let detailLabel = UILabel()
			detailLabel.numberOfLines = 0
			detailLabel.font = detailLabel.font.withSize(12)
			let text = "<html><style>body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; } @media (prefers-color-scheme: dark) {body {color: white;}}</style>" + "<body>" + annotation.subtitle!! + "</body></html>"
			detailLabel.attributedText = text.htmlToAttributedString
			view.detailCalloutAccessoryView = detailLabel
		}
		return view
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let overlayPolyline = overlay as? KMLOverlayPolyline {
			// return MKPolylineRenderer
			return overlayPolyline.renderer()
		}
		if let overlayPolygon = overlay as? KMLOverlayPolygon {
			// return MKPolygonRenderer
			return overlayPolygon.renderer()
		}
		return MKOverlayRenderer(overlay: overlay)
	}
}
