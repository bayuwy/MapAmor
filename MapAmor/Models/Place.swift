//
//  Place.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 14/10/22.
//

import Foundation
import MapKit

class Place: NSObject, Decodable {
    let name: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let desc: String
    let images: [String]
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case cityName
        case latitude
        case longitude
        case desc = "description"
        case images = "imageNames"
        case link
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.desc = try container.decodeIfPresent(String.self, forKey: .desc) ?? ""
        self.images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        self.link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
    }
}

// MARK: - MKAnnotation
extension Place: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return cityName
    }
}
