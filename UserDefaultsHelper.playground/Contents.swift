import UIKit

// Protocol to check for Nil
protocol AnyOptional {
    var isNil: Bool { get }
}

// Conforming nil check protocol to optional
extension Optional: AnyOptional {
    var isNil: Bool {
        return self == nil
    }
}

// Helper Class for UserDefaults with Property Wrapper
@propertyWrapper
class UserDefaultsHelper<T> {
    
    private let defaultValue: T // Stores an initial default value
    private let key: String // The key representing the value
    private let store: UserDefaults // Used for defaults initialisation (Eg. .standard or .init(suiteName:))
    
    // Initialiser
    init(defaultValue: T, key: String, store: UserDefaults) {
        self.defaultValue = defaultValue
        self.key = key
        self.store = store
        
        print("\(self.key) initialised with default value \(self.defaultValue)\n")
    }
    
    // Getter Setter fot the wrapped property value
    var wrappedValue: T {
        set {
            self.setValue(newValue: newValue)
        }
        get {
            return self.getValue()
        }
    }
    
    // Sets a value to Defaults or Removes it if nil
    private func setValue(newValue: T) {
        guard let newValue = newValue as? AnyOptional, newValue.isNil == true else {
            self.store.set(newValue, forKey: self.key)
            print("\(self.key) initialised with new value \(newValue)\n")
            return
        }
        self.store.removeObject(forKey: self.key)
        print("\(self.key) is removed\n")
    }
    
    // Fetches a value against a key from Defaults
    private func getValue() -> T {
        let value = self.store.value(forKey: self.key) as? T ?? defaultValue
        print("Value for \(self.key) is \(value)\n")
        return value
    }
}

// Initialiser with nil default value
extension UserDefaultsHelper where T: ExpressibleByNilLiteral {
    
    convenience init(key: String, store: UserDefaults) {
        self.init(defaultValue: nil, key: key, store: store)
    }
}


extension UserDefaults {
    
    // Defaults object
    private static var store: UserDefaults {
        return UserDefaults.standard
    }
    
    // Defaults object shared with app groups
    private static var groupStore: UserDefaults {
        return UserDefaults.init(suiteName: "group.com.orgainsation.appname")!
    }
    
    // User Default Keys
    enum Keys {
        static let firstname: String = "firstname"
        static let lastname: String = "lastname"
        static let grade: String = "grade"
        static let dateModified: String = "dateModified"
        static let subjects: String = "subjects"
        static let subjectTeacher: String = "subjectTeacher"
        static let isActive: String = "isActive"
        static let profileImage: String = "profileImage"
        static let coverImage: String = "coverImage"
        
        static var allCases: [String] = [firstname, 
                                         lastname,
                                         grade,
                                         dateModified,
                                         subjects, 
                                         subjectTeacher,
                                         isActive,
                                         profileImage,
                                         coverImage]
    }
    
    // Using property wrapper to set key values stored in user defaults
    
    @UserDefaultsHelper(defaultValue: "Shivam", key: Keys.firstname, store: .groupStore)
    static var firstname: String
    
    @UserDefaultsHelper(defaultValue: "Maggu", key: Keys.lastname, store: .groupStore)
    static var lastname: String
    
    @UserDefaultsHelper(defaultValue: 5, key: Keys.grade, store: .store)
    static var grade: Int?
    
    @UserDefaultsHelper(defaultValue: Date(), key: Keys.dateModified, store: .store)
    static var dateModified: Date
    
    @UserDefaultsHelper(defaultValue: ["English", "Maths", "Science"], key: Keys.subjects, store: .store)
    static var subjects: Array<String>
    
    @UserDefaultsHelper(defaultValue: ["English": "Mrs. Jaggi", "Maths": "Mr. Karim", "Science": "Mrs. Rita"], 
                        key: Keys.subjectTeacher,
                        store: .store)
    static var subjectTeacher: [String: String]
    
    @UserDefaultsHelper(defaultValue: true, key: Keys.isActive, store: .store)
    static var isActive: Bool
    
    @UserDefaultsHelper(defaultValue: Data(), key: Keys.profileImage, store: .store)
    static var profileImage: Data
    
    @UserDefaultsHelper(key: Keys.coverImage, store: .store)
    static var coverImage: Data?
    
    // Sets all the key-value pairs to their default values
    
    static func clearAll() {
        Keys.allCases.forEach { key in
            self.store.removeObject(forKey: key)
            self.groupStore.removeObject(forKey: key)
        }
    }
}

// Usage of UserDefaults

//print(UserDefaults.firstname)
//print(UserDefaults.lastname)
//print(UserDefaults.grade)
//print(UserDefaults.dateModified)
//print(UserDefaults.subjects)
//print(UserDefaults.subjectTeacher)
//print(UserDefaults.isActive)
//print(UserDefaults.profileImage)
//print(UserDefaults.coverImage)

//UserDefaults.isActive = false
//print(UserDefaults.isActive)

//UserDefaults.grade = 5
//print(UserDefaults.grade)

//UserDefaults.clearAll()
