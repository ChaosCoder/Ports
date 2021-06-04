//
//  Localized.swift
//  Ports
//
//  Created by Andreas Ganske on 02.06.21.
//

import Foundation

func LocalizedString(_ key: String, comment: String? = nil, bundle: Bundle = Bundle.main) -> String {
    return NSLocalizedString(key, bundle: bundle, comment: comment ?? "")
}

func LocalizedFormattedString(_ key: String, _ formatted: String...) -> String {
    let formatString = LocalizedString(key)
    return String.init(format: formatString, arguments: formatted)
}
