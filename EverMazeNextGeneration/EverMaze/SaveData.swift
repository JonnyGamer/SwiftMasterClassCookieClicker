//
//  SaveData.swift
//  EverMazeNextGeneration
//
//  Created by Jonathan Pappas on 7/22/21.
//

import Foundation

@propertyWrapper struct MasterData<T> {
    var foo: String
    let defaultValue: T
    public var wrappedValue: T {
        get { return UserDefaults.standard.object(forKey: foo) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: foo) }
    }
    public init(wrappedValue: T, key: SuperSaveData) { defaultValue = wrappedValue; foo = key.rawValue }
    public init(wrappedValue: T, str: String) { defaultValue = wrappedValue; foo = str }
}

struct SaveData {
    @MasterData(key: .orbs) static var orbs: Int = 0
    @MasterData(key: .level) static var level: Int = 1
    @MasterData(key: .currentLevel) static var currentLevel: String = ""
    
    static func deleteLevel() { currentLevel = "" }
    
    @MasterData(key: .minimal) static var minimal: Bool = false
    
    // @MasterData(key: .trueLevel)
    static var trueLevel: Int = 5
}

enum SuperSaveData: String {
    case currentLevel
    case orbs
    case level
    case minimal
    
    case trueLevel
}
