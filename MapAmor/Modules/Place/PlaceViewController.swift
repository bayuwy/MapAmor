//
//  PlaceViewController.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 18/10/22.
//

import UIKit
import MapKit
import SafariServices

class PlaceViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var wikiButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel: PlaceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = viewModel.numberOfPlaceImages
        pageControl.isUserInteractionEnabled = false
        
        titleLabel.text = viewModel.placeName
        subtitleLabel.text = viewModel.placeCityName
        descriptionLabel.text = viewModel.placeDescription
        
        mapView.isScrollEnabled = false
        mapView.delegate = self
        reloadMapView()
    }
    
    func reloadMapView() {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = viewModel.annotation
        mapView.addAnnotation(annotation)
        zoom(to: annotation)
    }
    
    func zoom(to annotation: MKAnnotation) {
        let coordinate = annotation.coordinate
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func wikiButtonTapped(_ sender: Any) {
        if let url = viewModel.wikiUrl {
            openUrlInSafari(url)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPlaceImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellId", for: indexPath)
        
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = viewModel.placeImage(at: indexPath.item)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlaceViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: width)
    }
}

// MARK: - MKMapViewDelegate
extension PlaceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        routeToPlace()
    }
    
    func routeToPlace() {
        let actionSheet = UIAlertController(title: "Directions using", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Maps", style: .default, handler: { (_) in
            self.openMaps()
        }))
        
        if canOpen(urlScheme: "comgooglemaps") {
            actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (_) in
                self.openGoogleMaps()
            }))
        }
        
        if canOpen(urlScheme: "waze") {
            actionSheet.addAction(UIAlertAction(title: "Waze", style: .default, handler: { (_) in
                self.openWaze()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
    func openMaps() {
        let coordinate = viewModel.annotation.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = viewModel.placeName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func canOpen(urlScheme: String) -> Bool {
        var components = URLComponents()
        components.scheme = urlScheme
        if let url = components.url {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func openGoogleMaps() {
        let coordinate = viewModel.annotation.coordinate
        let latString = String(format: "%.6f", coordinate.latitude)
        let lngString = String(format: "%.6f", coordinate.longitude)
        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latString),\(lngString)&directionsmode=driving")!
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            application.open(url)
        }
    }
    
    func openWaze() {
        let coordinate = viewModel.annotation.coordinate
        let latString = String(format: "%.6f", coordinate.latitude)
        let lngString = String(format: "%.6f", coordinate.longitude)
        let url = URL(string: "waze://?ll=\(latString),\(lngString)&navigate=yes")!
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            application.open(url)
        }
    }
    
}

extension UIViewController {
    func presentPlaceViewController(_ place: Place) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "place") as! PlaceViewController
        viewController.viewModel = PlaceViewModel(place: place)
        present(viewController, animated: true)
    }
}
