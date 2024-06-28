//
//  CharacterExtensions.swift
//  MBFoundation
//
//  Created by rensihao on 2021/3/3.
//

import Foundation

public extension MBFoundationWrapper where T == Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji: Bool {
        guard let firstProperties = this.unicodeScalars.first?.properties else {
            return false
        }
        if #available(iOS 10.2, *) {
            return this.unicodeScalars.count == 1 &&
                (firstProperties.isEmojiPresentation || firstProperties.generalCategory == .otherSymbol)
        } else {
            return this.unicodeScalars.count == 1 &&
                (firstProperties.generalCategory == .otherSymbol)
        }
    }

    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji: Bool {
        return this.unicodeScalars.count > 1 &&
            this.unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji: Bool {
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}
