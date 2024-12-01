import SwiftUI

class WallpaperViewModel: ObservableObject {
    @Published var wallpaperImage: UIImage?
    private var currentUrl: String = ""
    
    func fetchTodayWallpaper() {
        // TODO: 替换为实际的壁纸URL
        // let wallpaperUrl = "https://images.pexels.com/photos/29549363/pexels-photo-29549363.jpeg"
        let wallpaperUrl = "https://ayigugu-avatar-store.oss-cn-hangzhou.aliyuncs.com/2024-02-27/01/8.png?OSSAccessKeyId=LTAI5t6QuU58e2z6KempnGze&Expires=1733046299&Signature=s6%2B4yXPKlo9x98Vb9gBUMdoAT20%3D"
        
        guard let url = URL(string: wallpaperUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.wallpaperImage = UIImage(data: data)
            }
        }.resume()
    }
}
