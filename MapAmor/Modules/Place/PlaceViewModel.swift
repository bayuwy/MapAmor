//
//  PlaceViewModel.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 18/10/22.
//

import UIKit
import MapKit

class PlaceViewModel {
    private let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    var numberOfPlaceImages: Int {
        return place.images.count
    }
    
    func placeImage(at index: Int) -> UIImage? {
        return UIImage(named: place.images[index])
    }
    
    var placeName: String {
        return place.name
    }
    
    var placeCityName: String {
        return place.cityName
    }
    
    var placeDescription: String {
        return place.desc
    }
    
    var wikiUrl: URL? {
        return URL(string: place.link)
    }
    
    var annotation: MKAnnotation {
        return place
    }
}
