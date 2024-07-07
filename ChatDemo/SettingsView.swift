import SwiftUI
import SDWebImageSwiftUI

struct SettingsView: View {
    
    @ObservedObject private var vm = MainMessagesViewModel()
    @State var shouldShowLogOutOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                accountView
                // 設定項目をここに追加
            }
            .navigationTitle("Mypage")
        }
    }
    
    private var accountView: some View {
        VStack(spacing: 16) {
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipped()
                .cornerRadius(200)
                .overlay(RoundedRectangle(cornerRadius: 200)
                    .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            VStack(alignment: .center, spacing: 4) { // alignment を .center に設定
                let username = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                Text(username)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center) // テキストを中央に配置
                
                HStack {
                    let email = vm.chatUser?.email ?? ""
                    Text(email).font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                .frame(maxWidth: .infinity, alignment: .center) // HStack全体を中央に配置
            }
            .frame(maxWidth: .infinity) // 内部の VStack を幅一杯に広げる
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
                self.vm.fetchRecentMessages()
                
            })
        }
    }
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
