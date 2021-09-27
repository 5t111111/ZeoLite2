import Foundation
import libmaxminddb

final public class ZeoLite2 {
    fileprivate var db = MMDB_s()

    fileprivate typealias ListPtr = UnsafeMutablePointer<MMDB_entry_data_list_s>
    fileprivate typealias StringPtr = UnsafeMutablePointer<String>

    public init?(_ filename: String) {
        if openDB(atPath: filename) {
            return
        } else {
            return nil
        }
    }

    private func openDB(atPath: String) -> Bool {
        let cfilename = atPath.cString(using: String.Encoding.utf8)
        let cfilenamePtr = UnsafePointer<Int8>(cfilename)
        let status = MMDB_open(cfilenamePtr, UInt32(MMDB_MODE_MASK), &db)
        if status != MMDB_SUCCESS {
            print(String(cString: MMDB_strerror(errno)))
            return false
        } else {
            return true
        }
    }

    fileprivate func lookupString(_ s: String) -> MMDB_lookup_result_s? {
        let string = s.cString(using: String.Encoding.utf8)
        let stringPtr = UnsafePointer<Int8>(string)

        var gaiError: Int32 = 0
        var error: Int32 = 0
        let noErr: Int32 = 0

        let result = MMDB_lookup_string(&db, stringPtr, &gaiError, &error)
        if gaiError == noErr && error == noErr {
            return result
        }
        return nil
    }

    fileprivate func getString(_ list: ListPtr) -> String {
        var data = list.pointee.entry_data
        let type = (Int32)(data.type)

        // Ignore other useless keys
        guard data.has_data && type == MMDB_DATA_TYPE_UTF8_STRING else {
            return ""
        }

        let str = MMDB_get_entry_data_char(&data)
        let size = size_t(data.data_size)
        let cKey = mmdb_strndup(str, size)!
        let key = String(cString: cKey)
        free(cKey)

        return key
    }

    fileprivate func getType(_ list: ListPtr) -> Int32 {
        let data = list.pointee.entry_data
        return (Int32)(data.type)
    }

    fileprivate func getSize(_ list: ListPtr) -> UInt32 {
        return list.pointee.entry_data.data_size
    }


    public func lookup(_ IPString: String) -> Country? {
        guard let dict = lookup(ip: IPString) else {
            return nil
        }

        let country = Country(dictionary: dict)

        return country
    }

    private func dump(list: ListPtr?) -> (ptr: ListPtr?, out: Any?) {
        var list = list
        switch getType(list!) {

        case MMDB_DATA_TYPE_MAP:
            var dict: [String: Any] = [:]
            var size = getSize(list!)

            list = list?.pointee.next
            while size > 0 && list != nil {
                let key = getString(list!)
                list = list?.pointee.next
                let sub = dump(list: list)
                list = sub.ptr
                if let out = sub.out, key.count > 0 {
                    dict[key] = out
                } else {
                    break
                }
                size -= 1
            }
            return (ptr: list, out: dict)

        case MMDB_DATA_TYPE_UTF8_STRING:
            let str = getString(list!)
            list = list?.pointee.next
            return (ptr: list, out: str)

        case MMDB_DATA_TYPE_UINT32:
            var res: UInt32 = 0
            if let entryData = list?.pointee.entry_data {
                var mutableEntryData = entryData
                if let uint = MMDB_get_entry_data_uint32(&mutableEntryData) {
                    res = uint.pointee
                }
            }
            list = list?.pointee.next
            return (ptr: list, out: res)

        default: ()

        }
        return (ptr: list, out: nil)
    }

    public func lookup(ip: String) -> [String: Any]? {
        guard let result = lookupString(ip) else {
            return nil
        }

        var entry = result.entry
        var list: ListPtr?
        let status = MMDB_get_entry_data_list(&entry, &list)
        if status != MMDB_SUCCESS {
            return nil
        }
        let res = self.dump(list: list)
        if let dict = res.out, let d = dict as? [String: Any] {
            return d
        }
        return nil
    }

    deinit {
        MMDB_close(&db)
    }
}
