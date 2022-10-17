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

extension UIViewController {
    func presentPlaceViewController(_ place: Place) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "place") as! PlaceViewController
        viewController.viewModel = PlaceViewModel(place: place)
        present(viewController, animated: true)
    }
}
