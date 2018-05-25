# ZeoLite2

A tiny wrapper for [libmaxminddb](https://github.com/maxmind/libmaxminddb) which allows you to lookup Geo data by IP address.

This product uses [GeoLite2 data](http://dev.maxmind.com/geoip/geoip2/geolite2/) created by ZeoLite2, available from [http://www.maxmind.com](http://www.maxmind.com).

(Currently supports only SPM)

## Swift Package Manager

### Package.swift

```swift
import PackageDescription

let package = Package(
    name: "YOUR_AWESOME_PROJECT",
    dependencies: [
        .package(url: "https://github.com/5t111111/MMDB-Swift.git", .branch("master"))
    ],
    ...
)
```

## Usage

```swift
import ZeoLite2

guard let db = ZeoLite2("/path/to/database/file") else {
    print("Failed to open DB.")
    return
}

if let country = db.lookup("8.8.4.4") {
    print(country)
} else {
    print("Not found")
}
```

## Author

Originally written by [Lex Tang](https://github.com/lexrus) (Twitter: [@lexrus](https://twitter.com/lexrus))

## License

ZeoLite2 is available under the [Apache License Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See the [LICENSE](https://github.com/5t111111/ZeoLite2/blob/master/LICENSE) file for more info.

The GeoLite2 databases are distributed under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).

