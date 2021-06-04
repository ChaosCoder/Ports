//
//  Localized.swift
//  Ports
//
//  Created by Andreas Ganske on 02.06.21.
//

import Foundation

func localizedString(_ key: String, comment: String? = nil, bundle: Bundle = Bundle.main) -> String {
    return NSLocalizedString(key, bundle: bundle, comment: comment ?? "")
}

func localizedFormattedString(_ key: String, _ formatted: String...) -> String {
    let formatString = localizedString(key)
    return String(format: formatString, arguments: formatted)
}
