//  The converted code is limited to 2 KB.
//  Upgrade your plan to remove this limitation.
// 
//  Converted to Swift 4 by Swiftify v4.2.20547 - https://objectivec2swift.com/
//
//  YYDiskCache.m
//  YYCache <https://github.com/ibireme/YYCache>
//
//  Created by ibireme on 15/2/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//
import CommonCrypto
import ObjectiveC
import UIKit
func Lock() {
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER)
}
func Unlock() -> Int {
    return lock.signal()
}
private let extended_data_key: Int = 0
/// weak reference for all instances
private var _globalInstances: NSMapTable?
private var _globalInstancesLock: DispatchSemaphore?
/// Free disk space in bytes.
private func YYDiskSpaceFree() -> Int64 {
    var error: Error? = nil
    let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
    if error != nil {
        return -1
    }
    var space = Int64(attrs?[.systemFreeSize] ?? 0)
    if Int(space) < 0 {
        space = -1
    }
    return space
}
/// String's md5 hash.
private func YYNSStringMD5(string: String?) -> String? {
    if string == nil {
        return nil
    }
    let data: Data? = string?.data(using: .utf8)
    let result = [UInt8](repeating: 0, count: CC_MD5_DIGEST_LENGTH)
    CC_MD5(data?.bytes, (data?.count ?? 0) as? CC_LONG, result)
    return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15])
}
private func YYDiskCacheInitGlobal() {
    // TODO: [Swiftify] ensure that the code below is executed only once (`dispatch_once()` is deprecated)
    {
        globalInstancesLock = DispatchSemaphore(value: 1)
        globalInstances = NSMapTable(keyOptions: .strongMemory, valueOptions: .weakMemory, capacity: 0)
// 
//  The converted code is limited to 2 KB.
//  Upgrade your plan to remove this limitation.
// 
//  %< ----------------------------------------------------------------------------------------- %<
