import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    @Published var calendarStyle: Int = UserDefaults.standard.integer(forKey: "calendarStyle")
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("会话激活错误: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("收到消息：", message)
        DispatchQueue.main.async { [weak self] in
            if let style = message["calendarStyle"] as? Int {
                self?.calendarStyle = style
                UserDefaults.standard.set(style, forKey: "calendarStyle")
                print("日历样式已更新为：\(style)")
            }
        }
    }
}