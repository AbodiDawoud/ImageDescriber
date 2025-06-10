//
//  DescribeRequest.swift
//  ImageDescriberX
    

import Foundation

/// A request describing the parameters for generating an image description.
///
/// The `DescribeRequest` structure allows you to specify the language, detail level,
/// tone, and additional context to influence how an image should be described.
/// This is useful for customizing the output of an image description system.
///
/// - Parameters:
///   - language: The human language in which the description will be generated.
///   - detail: The amount of detail to include in the description (e.g., standard, verbose).
///   - tone: The desired tone of the description (e.g., friendly, neutral).
///   - context: Optional additional information or instructions that provide context for the description.
///
/// `DescribeRequest` conforms to `Codable` for easy serialization.
struct DescribeRequest {
    var language: Language
    var detail: DetailLevel
    var tone: Tone
    var context: String
    
    init(
        language: Language = .english,
        detail: DetailLevel = .standard,
        tone: Tone = .friendly,
        context: String = ""
    ) {
        self.language = language
        self.detail = detail
        self.tone = tone
        self.context = context
    }
}

extension DescribeRequest: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        language = try container.decode(Language.self, forKey: .language)
        detail = try container.decode(DetailLevel.self, forKey: .detail)
        tone = try container.decode(Tone.self, forKey: .tone)
        context = try container.decode(String.self, forKey: .context)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(language.rawValue, forKey: .language)
        try container.encode(detail.rawValue, forKey: .detail)
        try container.encode(tone.rawValue, forKey: .tone)
        try container.encode(context, forKey: .context)
    }

    private enum CodingKeys: String, CodingKey {
        case language, detail, tone, context
    }
}
