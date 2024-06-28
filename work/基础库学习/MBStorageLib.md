MBStorageLib

- MBKV支持根据存储数据量大小来选择存储载体，数据量小于5KB使用MMKV进行存储，数据量在5KB～1M之间使用数据库（FMDB）进行存储，数据量大于1MB使用文件进行存储，既使用MMKV提高了大量小数据存取的效率，也避免了大数据使用MMKV带来的内存问题。
- MBKeychainStorage对KeychainWrapper进行了进一步的封装，在高安全性、App删除后需要保留数据和在App之间共享数据等场景下使用MBKeychainStorage进行存储。
- MBMemoryStorage对YYMemoryCache进行了封装，针对只需要进行内存缓存的数据。
- MBDBStorage对FMDB进行了封装，提供了更简单易用的接口。

##### [Keychain](https://www.cnblogs.com/junhuawang/p/8194484.html)

iOS keychain 是一个相对独立的空间，**保存到keychain钥匙串中的信息不会因为卸载/重装app而丢失,** 。相对于NSUserDefaults、plist文件保存等一般方式，keychain保存更为安全。所以我们会用keyChain保存一些私密信息，比如密码、证书、设备唯一码（**把获取到用户设备的唯一ID 存到keychain 里面这样卸载或重装之后还可以获取到id，保证了一个设备一个ID**）等等。keychain是用SQLite进行存储的。用苹果的话来说是一个专业的数据库，加密我们保存的数据，可以通过metadata（attributes）进行高效的搜索。keychain适合保存一些比较小的数据量的数据，如果要保存大的数据，可以考虑文件的形式存储在磁盘上，在keychain里面保存解密这个文件的密钥。

 

##### [mmkv](https://cloud.tencent.com/developer/article/1066229)

使用零拷贝技术之一`mmap`内存映射的key-value组件，用户空间可以共享内核空间的数据，减少内核空间到用户空间的拷贝次数

采用性能最佳的`protobuf`协议

稳定

