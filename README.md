# HNStorage
HNStorage works as a layer to be a simple, efficient, and extendable CRUD layer for different iOS Storing options.

### Inspiration
Working with different storage options such as UserDefaults, Disk, or even keychain can be a hassle especially working with an enterprise project.

### TODO
- [x] Create protocol for CRUD layer
- [x] Support for struct
- [x] Add support to standard iOS storage options
- [ ] Add support for lists.
- [ ] Add a security layer, to secure data at rest.
- [ ] Add support to CoreData.
- [ ] Objective-C support.


### Supported Storing options:
>  Keychain (`HNKeychainStorage`)
> UserDefaults (`HNUserDefaultsStorage`)
> Memory Cache (`HNCacheStorage`)
> Local Disk Cache (`HNDiskStorage`)

### Usage
I tried to make the usage to be very simple using `HNStorage<Storage>`.
you just need to `init` with or without an `id`, id here is being the distinguisher between same storage like `suitname:` for UserDefaults or the location for `Disk`

for example
```
let storage = HNStorage<HNDiskStorage>() //default location.
let storage = HNStorage<HNDiskStorage>(id: "preferred_location_on_disk")
```

- objects must conform to `Storable` protocol and must assign `primaryKey`
- right now we support simple CRUD operation so we have the following functions:

> `insert(object: Storable)`
> `update(object: Storable)`
> `delete(object: Storable)`
> `exists(object: Storable) -> Bool`
> `get<T: Storable>(_ key: String) throws -> T?`


