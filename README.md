# fastcon
web-api for fastcon.harknmav.fun  provides V2Ray-based VLESS and Trojan proxy configurations designed for bypassing internet censorship, primarily for Telegram
# main
```swift
import Foundation
import fastcon

let client = Fastcon()

do {
    if let data = try await client.get_telegram_proxy_list() as? [[String: Any]] {
        for proxy in data {
            let server = proxy["server"] as? String ?? ""
            let port = proxy["port"] as? Int ?? 0
            let secret = proxy["secret"] as? String ?? ""
            
            var pingResult = "n/a"
            if let idValue = proxy["id"] {
                let idString = "\(idValue)" 
                if let pingData = try await client.ping_server(server_id: idString) as? [String: Any],
                   let time = pingData["time"] {
                    pingResult = "\(time)ms"
                }
            }
            
            let tgLink = "tg://proxy?server=\(server)&port=\(port)&secret=\(secret)"
            print("link: \(tgLink) >> ping: \(pingResult)")
        }
    }
} catch {
    print("error: \(error)")
}

```

# Launch (your script)
```
swift run
```
