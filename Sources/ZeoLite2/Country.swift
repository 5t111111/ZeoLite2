import Foundation

public struct Country: CustomStringConvertible {
    public var continent = Continent()
    public var isoCode = ""
    public var names = [String: String]()

    init(dictionary: [String: Any]) {
        if let dict = dictionary["continent"] as? [String: Any],
            let code = dict["code"] as? String,
            let continentNames = dict["names"] as? [String: String]
        {
            continent.code = code
            continent.names = continentNames
        }
        if let dict = dictionary["country"] as? [String: Any],
            let iso = dict["iso_code"] as? String,
            let countryNames = dict["names"] as? [String: String]
        {
            self.isoCode = iso
            self.names = countryNames
        }
    }

    public var description: String {
        var s = "{\n"
        s += "  \"continent\": {\n"
        s += "    \"code\": \"" + (self.continent.code ?? "") + "\",\n"
        s += "    \"names\": {\n"
        var i = continent.names?.count ?? 0
        continent.names?.forEach {
            s += "      \""
            s += $0.0 + "\": \""
            s += $0.1 + "\""
            s += (i > 1 ? "," : "")
            s += "\n"
            i -= 1
        }
        s += "    }\n"
        s += "  },\n"
        s += "  \"isoCode\": \"" + self.isoCode + "\",\n"
        s += "  \"names\": {\n"
        i = names.count
        names.forEach {
            s += "    \""
            s += $0.0 + "\": \""
            s += $0.1 + "\""
            s += (i > 1 ? "," : "")
            s += "\n"
            i -= 1
        }
        s += "  }\n}"
        return s
    }
}
