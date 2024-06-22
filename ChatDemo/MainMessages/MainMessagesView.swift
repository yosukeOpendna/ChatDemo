//
//  MainmessagesView.swift
//  ChatDemo
//
//  Created by ISHOWSPEED on 2024/06/22.
//

import SwiftUI

struct MainMessagesView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(0..<10, id: \.self) { num in
                    HStack(spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                        VStack(alignment: .leading){
                            Text("Uesrname")
                            Text("Message sent to user")
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()

                }
            }
            .navigationTitle("Main messages View")
        }
    }
}

struct MainmessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
