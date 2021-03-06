//
//  SSPerKeyProperties+Layout.swift
//  PrismUI
//
//  Created by Erik Bautista on 12/24/21.
//

import PrismClient

// Layout Map
public extension PerKeyProperties {
    // Not exactly equaling to 20 because of some emtpy spaces in between the keys

    static let perKeyMap: [[CGFloat]] = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],   // 20
        [1.25, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2.75, 1, 1, 1, 1],   // 20
        [1.50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2.50, 1, 1, 1],      // 19
        [2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1],            // 20
        [2.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2.5, 1, 1, 1, 1],           // 19
        [2, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]                      // 20
    ]

    static let perKeyKeySize: CGFloat = 50.0

    static let perKeyShortKeyMap: [[CGFloat]] = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],          // 15
        [0.50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.50, 1],    // 15
        [0.75, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.25, 1],    // 15
        [1.25, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.75, 1],       // 15
        [1.50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.50, 1, 1],       // 15
        [1.25, 1, 1, 4.75, 1, 1, 1, 1, 1, 1, 1]                 // 15
    ]

    static let perKeyShortKeySize: CGFloat = 60.0

    static func getKeyboardMap(for model: PrismDevice.Model) -> [[CGFloat]] {
        switch model {
        case .perKey:
            return perKeyMap
        case .perKeyShort:
            return perKeyShortKeyMap
        default:
            return []
        }
    }

    static func getKeyboardCodes(for model: PrismDevice.Model) -> [[(UInt8, UInt8)]] {
        switch model {
        case .perKey:
            return perKeyRegionKeyCodes
        case .perKeyShort:
            return perKeyShortRegionKeyCodes
        default:
            return []
        }
    }
}

// Generating Layout for a key

extension PerKeyProperties {
    public struct KeyLayout: Hashable {
        let width: CGFloat
        let height: CGFloat
        let yOffset: CGFloat
        let requiresExtraView: Bool
    }

    public static func getKeyLayout(for key: Key, model: PrismDevice.Model, padding: CGFloat) -> KeyLayout? {
        let keyCodes: [[(UInt8, UInt8)]] = PerKeyProperties.getKeyboardCodes(for: model)
        let keyMaps: [[CGFloat]] = PerKeyProperties.getKeyboardMap(for: model)
        let keySizes: CGFloat = model == .perKey ? PerKeyProperties.perKeyKeySize : PerKeyProperties.perKeyShortKeySize

        let rowIndex = keyCodes.firstIndex { column in
            column.contains { (region, keycode) in
                key.region == region && key.keycode == keycode
            }
        }

        if let rowIndex = rowIndex {
            let columnIndex = keyCodes[rowIndex].firstIndex { region, keycode in
                key.region == region && key.keycode == keycode
            }

            if let columnIndex = columnIndex {
                let keyMap = keyMaps[rowIndex][columnIndex]

                let keyWidth = keySizes * keyMap
                let keyHeight = (key.keycode == 0x57 || key.keycode == 0x56) ? keySizes * 2 + padding : keySizes
                let addExtraView = key.keycode == 0x5A || key.keycode == 0x60

                let keyYOffset: CGFloat
                if model == .perKey {
                    if key.keycode == 0x57 {
                        keyYOffset = -keySizes - padding
                    } else if rowIndex <= 3 && key.keycode != 0x56 {
                        keyYOffset = keySizes + padding
                    } else {
                        keyYOffset = 0
                    }
                } else {
                   keyYOffset = 0
                }

                return .init(
                    width: keyWidth,
                    height: keyHeight,
                    yOffset: keyYOffset,
                    requiresExtraView: addExtraView
                )
            }
        }

        return nil
    }
}
