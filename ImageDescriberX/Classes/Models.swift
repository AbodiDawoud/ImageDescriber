//
//  Models.swift
//  ImageDescriberX
    

import Foundation


enum DetailLevel: String, CaseIterable, Identifiable, Decodable {
    case standard
    case detailed
    case concise
    
    var id: Self { self }
    
    var displayName: String {
        return rawValue.capitalized
    }
}


enum Tone: String, CaseIterable, Identifiable, Decodable {
    case formal
    case friendly
    case casual
    case professional
    case confident
    case academic
    
    var id: Self { self }
    
    var displayName: String {
        return rawValue.capitalized
    }
}


enum Language: String, CaseIterable, Identifiable, Decodable {
    case english
    case arabic
    case bulgarian
    case bengali
    case danish
    case dutch
    case french
    case german
    case hindi
    case indonesian
    case italian
    case japanese
    case korean
    case norwegian
    case portuguese
    case russian
    case spanish
    case swedish
    case vietnamese
    case chinese
    
    var id: Self { self }
    
    var displayName: String {
        return rawValue.capitalized
    }
    
    var code: String {
        switch self {
        case .english: return "en"
        case .arabic: return "ar"
        case .bulgarian: return "bg"
        case .bengali: return "bn"
        case .danish: return "da"
        case .dutch: return "nl"
        case .french: return "fr"
        case .german: return "de"
        case .hindi: return "hi"
        case .indonesian: return "id"
        case .italian: return "it"
        case .japanese: return "ja"
        case .korean: return "ko"
        case .norwegian: return "no"
        case .portuguese: return "pt"
        case .russian: return "ru"
        case .spanish: return "es"
        case .swedish: return "sv"
        case .vietnamese: return "vi"
        case .chinese: return "zh-Hant"
        }
    }
}
