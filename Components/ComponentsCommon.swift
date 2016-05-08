//
//  ComponentsCommon.swift
//  SwiftyBones Component Library
//
//  Created by Jon Hoffman on 5/7/16.
//


enum ComponentErrors: ErrorType {
    case GPIOCanNotBeNil
    case InvalidGPIOType(String)
    case PinNotInitalized(String)
}

protocol SBComponentProtocol {
    var componentName: String {get}
    init(gpio: GPIO?,componentName: String) throws
    init(header: BBExpansionHeader, pin: Int, componentName: String) throws
}

protocol SBComponentInProtocol: SBComponentProtocol {
    func getRawValue() -> Int?
}

protocol SBComponentOutProtocol: SBComponentProtocol {
    func setRawValue(value: Int) -> Bool
}