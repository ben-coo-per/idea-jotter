//
//  ContentView.swift
//  Idea Box
//
//  Created by Ben Cooper on 6/15/23.
//
import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    let store: StoreOf<IdeaList>
    
    @State private var isCreatingIdea: Bool = false
    @State private var description: String = ""
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack{
                    List(viewStore.ideas, id: \.self.id) { idea in
                        Text(idea.description).swipeActions {
                            Button("Archived") {
                                print("Awesome!")
                            }
                            .tint(.purple)
                        }
                    }
                    Group {
                        if isCreatingIdea {
                            HStack {
                                TextField("Enter your idea", text: $description)
                                Button(action: {
                                    viewStore.send(.addIdea(self.description))
                                    self.description = ""
                                    self.isCreatingIdea = false
                                }) {
                                    Text("Create")
                                }
                            }
                        } else{
                            Button("New Idea", action: {isCreatingIdea.toggle()})
                        }
                    }.padding()
                }.navigationTitle("Ideas")
                // TODO: full screen view of an idea text w/ back button
                // TODO: archive page -> swipe to archive & unarchive
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(initialState: IdeaList.State()) {
                IdeaList()
            }
        )
    }
}
