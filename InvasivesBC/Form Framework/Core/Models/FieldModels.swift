//
//  ItemConfig.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-07.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit


// Standard Cell width
let kStandardCellHeight: CGFloat = 70.0
let kTitleCellHeight: CGFloat = 30.0

// Different fields type
enum FieldType {
    case Dropdown
    case Text
    case Int
    case Double
    case Date
    case Switch
    case TextArea
    case RadioSwitch
    case ViewField
    case RadioBoolean
    case Time
    case Stepper
    case Spacer
    case Title
}

// Various Field Width Size Class
enum FieldWidthClass {
    case Full
    case Half
    case Third
    case Forth
    case Fill
}

// ViewConfig: Visual Config of field cell
protocol FieldConfig {
    var width: FieldWidthClass { set get }
    var height: CGFloat { set get }
    var header: String { set get }
    var key: String { set get }
    var editable: Bool { get set }
    var type: FieldType { get }
}

class BaseFieldViewModel: FieldConfig {
    // ViewConfig
    var width: FieldWidthClass = .Fill
    var height: CGFloat = kStandardCellHeight
    var header: String = ""
    var key: String = ""
    var editable: Bool = false
    var type: FieldType {
        return .Text
    }
}


// General Field View Model Class
class FieldViewModel<T>: BaseFieldViewModel  {
    // Data
    var data: DynamicValue<T>
    
    // Constructor
    init(header: String, key: String, editable: Bool, width: FieldWidthClass = .Fill, data: T) {
        self.data = DynamicValue<T>(data)
        super.init()
        self.header = header
        self.key = key
        self.editable = editable
        self.width = width
    }
    
    var value: T {
        set {
            self.data.value = newValue
        }
        get {
            return self.data.value
        }
    }
    
    override var type: FieldType {
        if T.self == Int.self || T.self == Int?.self {
            return .Int
        } else if T.self == Double.self || T.self == Double?.self {
            return .Double
        } else if T.self == Date?.self || T.self == Date.self {
            return .Date
        } else if T.self == Bool.self || T.self == Bool?.self {
            return .Switch
        } else {
            return .Text
        }
    }
}

// ReadOnlyFieldViewModel: Read
class ReadOnlyFieldViewModel: FieldViewModel<String> {}

// TextInput
class TextFieldViewModel: FieldViewModel<String> {}

// TextAreaInput
class TextAreaFieldViewModel: FieldViewModel<String> {}

// Switch: Boolean Field
class SwitchFieldViewModel: FieldViewModel<Bool> {}

// Date
class DateFieldViewModel: FieldViewModel<Date?> {}

// Title: Display Section or Group Title
class TitleFieldViewModel: FieldViewModel<String> {
    init(title: String, width: FieldWidthClass = .Fill) {
        super.init(header: "", key: UUID().uuidString, editable: false, width: width, data: title)
    }
    
    override var type: FieldType {
        return .Title
    }
}

// Spacer: Space Element
class SpacerFieldViewModel: FieldViewModel<Void> {
    init(width: FieldWidthClass = .Fill, height: CGFloat = kStandardCellHeight) {
        super.init(header: "", key: UUID().uuidString, editable: false, width: width, data: Void())
        self.height = height
    }
    
    override var type: FieldType {
        return .Spacer
    }
}
