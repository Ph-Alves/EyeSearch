//
//  ChatView2.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 28/04/26.
//

import SwiftUI

struct ChatView: View {
    @Environment(Coordinator.self) private var coordinator
    
    @StateObject var chatVM: ChatViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ReturnButton(action: {
                coordinator.pop()
            })
            Spacer()
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chatVM.displayedMessages) { message in
                        MessageBubble(message: message)
                    }
                    
                    if chatVM.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .onChange(of: chatVM.displayedMessages.count) {
                    if let last = chatVM.displayedMessages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: chatVM.isLoading) {
                    if chatVM.isLoading {
                        withAnimation {
                            proxy.scrollTo("loading", anchor: .bottom)
                        }
                    }
                }
            }
            
            Spacer()
            ChatUserText(chatVM: chatVM)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CoordinatedNavigationStack {
        ChatView(chatVM: ChatViewModel(manager: FoundationsManager()))
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
