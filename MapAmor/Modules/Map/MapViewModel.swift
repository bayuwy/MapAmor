//
//  MapViewModel.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 14/10/22.
//

import Foundation
import MapKit

class MapViewModel {
    private var places: [Place] = []
    
    func loadPlaces(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = Bundle.main.url(forResource: "Places", withExtension: "json")!
        
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: url)
            do {
                self.places = try JSONDecoder().decode([Place].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    var annotations: [MKAnnotation] {
        return places
    }
    
    func annotation(at index: Int) -> MKAnnotation {
        return places[index]
    }
    
    func index(of annotation: MKAnnotation) -> Int? {
        if let place = annotation as? Place {
            return places.firstIndex(of: place)
        }
        return nil
    }
    
    var numberOfPlaces: Int {
        return places.count
    }
    
    func placeName(at index: Int) -> String {
        return places[index].name
    }
    
    func placeCityName(at index: Int) -> String {
        return places[index].cityName
    }
    
    func placeImage(at index: Int) -> UIImage {
        if let imageName = places[index].images.first,
           let image = UIImage(named: imageName) {
            return image
        }
        else {
            return UIImage(systemName: "photo")!
        }
    }
    
    func place(at index: Int) -> Place {
        return places[index]
    }
}
