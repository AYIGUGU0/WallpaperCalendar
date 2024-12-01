//
//  ContentView.swift
//  WallpaperCalendar
//
//  Created by 咕噜咕噜 on 2024/12/1.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject private var phoneConnectivityManager = PhoneConnectivityManager.shared
    @AppStorage("selectedStyle") private var selectedStyle = 0
    
    let styles = [
        ("经典样式", "显示月份、日期和星期"),
        ("极简样式", "仅显示日期数字"),
        ("现代样式", "紧凑的横向布局")
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("日历样式")) {
                    ForEach(0..<styles.count, id: \.self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(styles[index].0)
                                    .font(.headline)
                                Text(styles[index].1)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if selectedStyle == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedStyle = index
                            phoneConnectivityManager.sendStyleToWatch(style: index)
                        }
                    }
                }
                
                Section {
                    if phoneConnectivityManager.isWatchAppInstalled {
                        HStack {
                            Image(systemName: "applewatch")
                            Text("Apple Watch 已连接")
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    } else {
                        HStack {
                            Image(systemName: "applewatch.slash")
                            Text("未检测到 Apple Watch")
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("日历壁纸设置")
        }
    }
}

#Preview {
    ContentView()
}
