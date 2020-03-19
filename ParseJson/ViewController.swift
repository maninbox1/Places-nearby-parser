//
//  ViewController.swift
//  ParseJson
//
//  Created by Mikhail Ladutska on 2/22/20.
//  Copyright © 2020 Mikhail Ladutska. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class ViewController: UIViewController {
    
    lazy var googleClient: GoogleClientRequest = GoogleClient()

    // Put here coordinates for your city (here is Grodno, Belarus coordinates)
    var currentLocation: CLLocation = CLLocation(latitude: 53.6688, longitude: 23.8223)
    var searchType = ""
    var searchRadius = 10000
    
    //MARK: - buttons
    
    @IBAction func foodButtonTapped(_ sender: UIButton) {
        searchType = "food"
         fetchGoogleData(forLocation: currentLocation, keyword: searchType, searchRadius: searchRadius)
    }
    
    @IBAction func shopsButtonTapped(_ sender: UIButton) {
        searchType = "supermarket"
        fetchGoogleData(forLocation: currentLocation, keyword: searchType, searchRadius: searchRadius)
    }
    
    @IBAction func museumsButtonTapped(_ sender: UIButton) {
        searchType = "museum"
        fetchGoogleData(forLocation: currentLocation, keyword: searchType, searchRadius: searchRadius)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ViewController {
    
   private func fetchGoogleData(forLocation location: CLLocation, keyword: String, searchRadius: Int) {
        googleClient.getGooglePlacesData(forKeyword: keyword, location: location, withinMeters: searchRadius) { (response) in

            //self.printFirstFive(places: response.results)
            self.printAllPlaces(places: response.results)
      //      print(response.results)
        }
    }
    
    private func printFirstFive(places: [Place]) {
       for place in places.prefix(5) {
           print("*******NEW PLACE********")
           let name = place.name
           let address = place.address
           let location = ("lat: \(place.geometry.location.latitude), lng: \(place.geometry.location.longitude)")
           guard let open = place.openingHours?.isOpen else {
                   print("\(name) is located at \(address), \(location)")
                   return
           }
              
           if open {
               print("\(name) is open, located at \(address), \(location)")
           } else {
               print("\(name) is closed, located at \(address), \(location)")
           }
        }
    }
    
    private func printAllPlaces(places: [Place]) {
       for place in places {
           let name = place.name
           let address = place.address
           let location = ("lat: \(place.geometry.location.latitude), lng: \(place.geometry.location.longitude)")
            print(name, address, location)
        }
    }
    
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
