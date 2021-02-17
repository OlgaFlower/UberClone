//
//  Service.swift
//  UberClone
//
//  Created by Olha Bereziuk on 16.02.2021.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
    
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData() {
        
        REF_USERS.child(currentUid!).observeSingleEvent(of: .value) { snapshot in
           
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let fullName = dictionary["fullname"] as? String else { return }
        }
    }
}
