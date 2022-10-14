//
//  MapViewController.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 14/10/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel: MapViewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        loadPlaces()
    }

    func setup() {
        mapView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func loadPlaces() {
        viewModel.loadPlaces { [weak self] (_) in
            guard let `self` = self else { return }
            self.reloadMapView()
            self.collectionView.reloadData()
        }
    }
    
    func reloadMapView() {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = viewModel.annotations
        for i in 0..<annotations.count {
            let annotation = annotations[i]
            mapView.addAnnotation(annotation)
            if i == 0 {
                mapView.selectAnnotation(annotation, animated: false)
            }
        }
        
        if let annotation = annotations.first {
            zoom(to: annotation)
        }
    }
    
    func zoom(to annotation: MKAnnotation) {
        let coordinate = annotation.coordinate
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        zoom(to: annotation)
    }
}

// MARK: - UICollectionViewDataSource
extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPlaces
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCellId", for: indexPath) as! PlaceViewCell
        
        let index = indexPath.item
        cell.imageView.image = viewModel.placeImage(at: index)
        cell.titleLabel.text = viewModel.placeName(at: index)
        cell.subtitleLabel.text = viewModel.placeCityName(at: index)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
