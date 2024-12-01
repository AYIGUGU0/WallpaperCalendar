import Foundation
import WatchConnectivity

class PhoneConnectivityManager: NSObject, ObservableObject {
    static let shared = PhoneConnectivityManager()
    
    @Published var isWatchAppInstalled: Bool = false
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sendStyleToWatch(style: Int) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let message = ["calendarStyle": style]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}

extension PhoneConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isWatchAppInstalled = session.isWatchAppInstalled
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // 处理会话变为非活动状态
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // 处理会话停用
        WCSession.default.activate()
    }
} 