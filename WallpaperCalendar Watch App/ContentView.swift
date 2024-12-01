//
//  ContentView.swift
//  WallpaperCalendar Watch App
//
//  Created by 咕噜咕噜 on 2024/12/1.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var wallpaperVM = WallpaperViewModel()
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    // 日期格式化工具
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    var body: some View {
        ZStack {
            // 远程壁纸
            if let image = wallpaperVM.wallpaperImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            }
            
            // 日历样式
            switch connectivityManager.calendarStyle {
            case 0:
                ClassicCalendarView(date: Date())
            case 1:
                MinimalCalendarView(date: Date())
            default:
                ModernCalendarView(date: Date())
            }
        }
        .onAppear {
            wallpaperVM.fetchTodayWallpaper()
        }
    }
}

// 经典日历样式
struct ClassicCalendarView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 8) {
            Text(date.formatted(.dateTime.month(.wide)))
                .foregroundColor(.white)
                .font(.system(size: 16))
            
            Text(date.formatted(.dateTime.day()))
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .bold))
            
            Text(date.formatted(.dateTime.weekday(.wide)))
                .foregroundColor(.white)
                .font(.system(size: 14))
        }
        .padding()
        .background(.black.opacity(0.5))
        .cornerRadius(10)
    }
}

// 极简日历样式
struct MinimalCalendarView: View {
    let date: Date
    
    var body: some View {
        Text(date.formatted(.dateTime.day()))
            .foregroundColor(.white)
            .font(.system(size: 60, weight: .bold))
            .padding()
            .background(.black.opacity(0.3))
            .cornerRadius(8)
    }
}

// 现代日历样式
struct ModernCalendarView: View {
    let date: Date
    
    var body: some View {
        HStack(spacing: 4) {
            Text(date.formatted(.dateTime.month(.abbreviated)))
            Text(date.formatted(.dateTime.day()))
            Text(date.formatted(.dateTime.weekday(.abbreviated)))
        }
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .medium))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

#Preview {
    ContentView()
}
