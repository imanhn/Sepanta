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
    
    enum CodingKeys: String, CodingKey {
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
    
    init(){
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
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
    }
}
