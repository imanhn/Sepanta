//
//  ProfileInfo.swift
//  Sepanta
//
//  Created by Iman on 2/4/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct ProfileInfo : Codable{
    var status : String?
    var message : String?
    var first_name : String?
    var last_name : String?
    private var firstname : String? // Just for the sake of encoding
    private var lastname : String? // just for the sake of encoding
    private var city_id : String? // just for the sake of encoding
    private var state_id : String? // just for the sake of encoding
    var bio : String?
    var banner : String?
    var address : String?
    var image : String?
    var national_code : String?
    var state : String?
    var city : String?
    var gender: String?
    var birthdate : String?
    var email : String?
    var phone : String?
    var marital_status : String?
    
    enum DecodingKeys: String, CodingKey {
        case status
        case message
        case first_name
        case last_name
        case bio
        case banner
        case address
        case image
        case national_code
        case state
        case city
        case gender
        case birthdate
        case email
        case phone
        case marital_status
    }
    
    enum EncodingKeys: String, CodingKey,CaseIterable {
        case status
        case message
        case firstname
        case lastname
        case bio
        case banner
        case address
        case image
        case national_code
        case state
        case city_id
        case gender
        case birthdate
        case email
        case phone
        case marital_status
    }
    
    init(){
    }
    
    init(First_name : String?,Last_name: String?,Bio : String?,Banner : String?,Address : String?,Image : String?,National_code : String?,State_id : String?,City_id : String?,Gender : String?,Birthdate : String?,Email : String?,Phone : String?,Marital_status : String?){
        self.first_name = First_name
        self.last_name = Last_name
        self.bio = Bio
        self.banner = Banner
        self.address = Address
        self.image = Image
        self.national_code = National_code
        self.state_id = State_id
        self.city_id = City_id
        self.gender = Gender
        self.birthdate = Birthdate
        self.email = Email
        self.phone = Phone
        self.marital_status = Marital_status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        do { let genderCode = try container.decode(Int.self, forKey: .gender)
            if genderCode == 1 {gender = "مرد"} else if genderCode == 0 {gender = "زن"}
        } catch {}
        
        
        do { let maritalCode = try container.decode(Int.self, forKey: .marital_status)
            if maritalCode == 1 {marital_status = "مجرد"} else if maritalCode == 2 {marital_status = "متاهل"}
        } catch {}
                
        do { first_name = try container.decode(String.self, forKey: .first_name) } catch {}
        do { last_name = try container.decode(String.self, forKey: .last_name)  } catch {}
        do { bio = try container.decode(String.self, forKey: .bio)  } catch {}
        do { banner = try container.decode(String.self, forKey: .banner) } catch {}
        do { address = try container.decode(String.self, forKey: .address) } catch {}
        do { image = try container.decode(String.self, forKey: .image) } catch {}
        do { national_code = try container.decode(String.self, forKey: .national_code) } catch {}
        do { state = try container.decode(String.self, forKey: .state) } catch {}
        do { city = try container.decode(String.self, forKey: .city) } catch {}
        do { birthdate = try container.decode(String.self, forKey: .birthdate) } catch {}
        do { email = try container.decode(String.self, forKey: .email) } catch {}
        do { phone = try container.decode(String.self, forKey: .phone) } catch {}
        do { status = try container.decode(String.self, forKey: .status) } catch {}
        do { message = try container.decode(String.self, forKey: .message) } catch {}

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        do { try container.encodeIfPresent(first_name, forKey: .firstname) } catch {}
        do { try container.encodeIfPresent(last_name, forKey: .lastname) } catch {}
        do { try container.encodeIfPresent(bio, forKey: .bio) } catch {}
        do { try container.encodeIfPresent(banner, forKey: .banner) } catch {}
        do { try container.encodeIfPresent(address, forKey: .address) } catch {}
        do { try container.encodeIfPresent(image, forKey: .image) } catch {}
        do { try container.encodeIfPresent(national_code, forKey: .national_code) } catch {}
        do { try container.encodeIfPresent(state, forKey: .state) } catch {}
        do { try container.encodeIfPresent(city, forKey: .city_id) } catch {}
        do {
            var genderCode = 1
            if (gender == "مرد") {genderCode = 1} else { genderCode = 0 }
            try container.encodeIfPresent(genderCode, forKey: .gender)
        } catch {}
        do { try container.encodeIfPresent(birthdate, forKey: .birthdate) } catch {}
        do { try container.encodeIfPresent(email, forKey: .email) } catch {}
        do { try container.encodeIfPresent(phone, forKey: .phone) } catch {}
        do {
            var maritalCode = 1
            if (marital_status == "مجرد") {maritalCode = 1} else { maritalCode = 2}
            try container.encodeIfPresent(maritalCode, forKey: .marital_status)
        } catch {}
        
    }
    
    func encodeToDictionary() -> [String: String] {
        let elm = self
        let mirror = Mirror(reflecting: elm)
        var dic : Dictionary<String,String> = [:]
        for child in mirror.children  {
            print("key: \(child.label ?? ""), value: \(child.value as? String ?? "")")
            dic[child.label!] = (child.value as? String) ?? ""
        }
        return dic
    }
}
