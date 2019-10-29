//
//  CreditCard.swift
//  Sepanta
//
//  Created by Iman on 1/25/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct CreditCard: Codable {
    var card_id: Int?
    var first_name: String?
    var last_name: String?
    var card_number: String?
    var status: Int?
    var bank_name: String?
    var bank_logo: String?
    var created_at: String?
    var is_edit: Int?    
}

struct LastCard: Codable {
    var message : String?
    var status : String?
    var card : LastCardData?
}
struct LastCardData: Codable {
    var card_id: Int?
    var first_name: String?
    var last_name: String?
    var cellphone : String?
    var melli_code : String?
    var sh_code : String?
    var address : String?
    var birthday : String?
    var city_code : String?
    var gender : String?
    var martial_status : String?
    var email: String?
    var state_code: String?
    
    enum DecodingKeys: String, CodingKey {
        case card_id
        case first_name
        case last_name
        case cellphone
        case melli_code
        case sh_code
        case address
        case birthday
        case city_code
        case gender
        case martial_status
        case email
        case state_code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        do { let genderCode = try container.decode(String.self, forKey: .gender)
            if genderCode == "1" {gender = "مرد"} else if genderCode == "0" {gender = "زن"}
        } catch {}
        
        do { let maritalCode = try container.decode(String.self, forKey: .martial_status)
            if maritalCode == "1" {martial_status = "مجرد"} else if maritalCode == "2" {martial_status = "متاهل"}
        } catch {}
        do { card_id = try container.decode(Int.self, forKey: .card_id)  } catch {}
        do { first_name = try container.decode(String.self, forKey: .first_name) } catch {}
        do { last_name = try container.decode(String.self, forKey: .last_name)  } catch {}
        do { cellphone = try container.decode(String.self, forKey: .cellphone) } catch {}
        do { melli_code = try container.decode(String.self, forKey: .melli_code) } catch {}
        do { sh_code = try container.decode(String.self, forKey: .sh_code) } catch {}
        do { address = try container.decode(String.self, forKey: .address) } catch {}
        do { birthday = try container.decode(String.self, forKey: .birthday) } catch {}
        do { state_code = try container.decode(String.self, forKey: .state_code) } catch {}
        do { city_code = try container.decode(String.self, forKey: .city_code) } catch {}
        do { email = try container.decode(String.self, forKey: .email) } catch {}
    }
}

struct CardRequestResponse: Codable {
    var card_id: Int?
    var status: String?
    var message: String?
    
    enum DecodingKeys: String, CodingKey {
        case card_id
        case status
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        do { card_id = try container.decode(Int.self, forKey: .card_id)  } catch {}
        do { status = try container.decode(String.self, forKey: .status) } catch {}
        do { message = try container.decode(String.self, forKey: .message)  } catch {}
    }
}
