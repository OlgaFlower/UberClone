//
//  User.swift
//  UberClone
//
//  Created by Olha Bereziuk on 17.02.2021.
//

struct User {
    let fullname: String
    let email: String
    let accountType: Int
    
    init(dictionary: [String : Any]) {
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
}
