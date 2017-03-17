# UTMConversion
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)

Convert between latitude/longitude and the [UTM (Universal Transverse Mercator)](https://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system) coordinate system.

## Installation
### Carthage

To integrate UTMConversion into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```ogdl
github "peterringset/UTMConversion" ~> 1.0
```

## Usage
### Convert to UTM

```swift
let coordinate = CLLocationCoordinate2D(latitude: 63.430493678423012, longitude: 10.394966844991798)
let utmCoordinate = coordinate.utmCoordinate()
```

### Convert from UTM

```swift
let utmCoordinate = UTMCoordinate(northing: 7034313, easting: 569612, zone: 32, hemisphere: .northern)
let coordinate = utmCoordinate.coordinate()
```

### Datum

It is possible to specify your own datum (polar and equitorial radius), the default value is WGS84, which is the latest revision of the WGS standard.

```swift
let utmCoordinate = UTMCoordinate(northing: 7034313, easting: 569612, zone: 32, hemisphere: .northern)
let datum = UTMDatum(equitorialRadius: 6378137, polarRadius: 6356752.3142)
let coordinate = utmCoordinate.coordinate(datum: datum)
```
