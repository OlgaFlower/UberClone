//
//  Service.swift
//  UberClone
//
//  Created by Olha Bereziuk on 16.02.2021.
//

import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")
let REF_TRIPS = DB_REF.child("trips")

struct Service {
    
    static let shared = Service()
    
    // Fetch User Data
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    // Fetch Drivers
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        REF_DRIVER_LOCATIONS.observe(.value) { snapshot in
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                
                self.fetchUserData(uid: uid, completion: { user in
                    var driver = user
                    driver.location = location
                    completion(driver)
                })
            })
        }
    }
    
    // Upload Trip
    func uploadTrip(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
        
        let values = ["pickupCoordinates" : pickupArray,
                      "destinationCoordinates" : destinationArray,
                      "state" : TripState.requested.rawValue] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    // Observe Trips
    func observeTrips(completion: @escaping(Trip) -> Void) {
        REF_TRIPS.observe(.childAdded) { snapshot in
            print("---- snapshot.key = \(snapshot.key)")
            guard let dictionary  = snapshot.value as? [String : Any] else { return }
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    // Observe Trip Cancelled
    func observeTripCancelled(trip: Trip, completion: @escaping() -> Void) {
        
        REF_TRIPS.child(trip.passengerUid).observeSingleEvent(of: .childRemoved) { _ in
            completion()
        }
    }
    
    // Accept Trip
    func acceptTrip(trip: Trip, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["driverUid" : uid,
                      "state" : TripState.accepted.rawValue] as [String : Any]
        
        REF_TRIPS.child(trip.passengerUid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    // Observe Current Trip
    func observeCurrentTrip(completion: @escaping(Trip) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_TRIPS.child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    // Cancel Trip
    func deleteTrip(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_TRIPS.child(uid).removeValue(completionBlock: completion)
    }
    
    func updateDriverLocation(location: CLLocation) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        geofire.setLocation(location, forKey: uid)
    }
    
    func updateTripState(trip: Trip, state: TripState, completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_TRIPS.child(trip.passengerUid).child("state").setValue(state.rawValue, withCompletionBlock: completion)
        
        if state == .completed {
            REF_TRIPS.child(trip.passengerUid).removeAllObservers()
        }
    }
}
