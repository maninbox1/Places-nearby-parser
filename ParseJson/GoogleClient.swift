//
//  GoogleClient.swift
//  ParseJson
//
//  Created by Mikhail Ladutska on 2/22/20.
//  Copyright © 2020 Mikhail Ladutska. All rights reserved.
//

import Foundation
import CoreLocation

protocol GoogleClientRequest {
    
    var googlePlacesKey: String { get set }
    
    func getGooglePlacesData(forKeyword keyword: String, location: CLLocation, withinMeters radius: Int, using completionHandler: @escaping (GooglePlacesResponse) -> ())
    
}

class GoogleClient: GoogleClientRequest {
    
    let session = URLSession(configuration: .default)
    //google api key
    var googlePlacesKey: String = "AIzaSyBqwFhT-ucENBcLx2RO1k_BY3LzdlVJQIY"
    
    func getGooglePlacesData(forKeyword keyword: String, location: CLLocation, withinMeters radius: Int, using completionHandler: @escaping (GooglePlacesResponse) -> ()) {
        
        let url = googlePlacesDataURL(forKey: googlePlacesKey, location: location, keyword: keyword)
        
        let task = session.dataTask(with: url) { (responseData, _, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = responseData, let response = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                
                completionHandler(GooglePlacesResponse(results:[]))
                return
            }
            
            completionHandler(response)
        }
        
        task.resume()
    }
    
    func googlePlacesDataURL(forKey apiKey: String, location: CLLocation, keyword: String) -> URL {
        
        //     Url for places nearby, to change place search go https://developers.google.com/places/web-service/search
        //        and check different URLs
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        //https://maps.googleapis.com/maps/api/place/nearbysearch/output?parameters
        let locationString = "location=" + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        let searchRadius = "$radius="
        let type = keyword
        let key = "key=" + apiKey
        
        //  return URL(string: baseURL + locationString + "&" + rankby + "&" + keywrd + "&" + key)!
        return URL(string: baseURL + locationString + "&radius=10000&type=" + type + "&" + key)!
    }
    
}
