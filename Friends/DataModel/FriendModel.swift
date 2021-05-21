//
//  FriendModel.swift
//  Friends
//
//  Created by Tasia Mosahid on 21/5/21.
//
import UIKit

class FriendModel: NSObject {
    var pictureThumb : String?
    var fullName : String?
    var address : String?
    var city : String?
    var state : String?
    var country : String?
    var email : String?
    var cellPhone : String?
    
    //function for parsing response object of random friend api to friend model object
    func parseData(dictionary : [String : Any]) {
        if let pictureObject = dictionary["picture"] as? [String : String]  {
            //large photo is the most preffered quality, thumb is least preferred as ipads have higher resolution
            if let thumb = pictureObject["large"] {
               self.pictureThumb = thumb
            } else if let thumb = pictureObject["medium"] {
                self.pictureThumb = thumb
            } else if let thumb = pictureObject["thumbnail"] {
                self.pictureThumb = thumb
            }
            
        }
        if let name = dictionary["name"] as? [String : String]  {
            let title = name["title"] ?? ""
            let firstName = name["first"] ?? ""
            let lastName = name["last"] ?? ""
            let tempName = title + " " + firstName + " " + lastName
            self.fullName = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let address = dictionary["location"] as? [String : Any]  {
            if let street = address["street"] as? [String : Any] {
                let name = street["name"] as? String ?? ""
                var numberString = ""
                if let number = street["number"] as? Int {
                    numberString = "\(number)"
                }
                let tempAddress = numberString  + " " + name
                self.address = tempAddress.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if let city = address["city"] as? String {
                self.city = city
            }
            if let state = address["state"] as? String  {
                self.state = state
            }
            if let country = address["country"] as? String  {
                self.country = country
            }
        }
        if let cell = dictionary["cell"] as? String {
            self.cellPhone = cell
        }
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        
        
        
    }

}
