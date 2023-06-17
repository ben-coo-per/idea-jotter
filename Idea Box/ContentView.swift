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
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack{
                    List(viewStore.ideas, id: \.self.id) { idea in
                        Text(idea.description)
                    }
                    AddIdeaInputBoxView(store: viewStore)
                }.navigationTitle("Ideas")
                // TODO: full screen view of an idea text w/ back button
                // TODO: archive page -> swipe to archive & unarchive
            }
        }
    }
}




struct AddIdeaInputBoxView: View {
    private enum Field {
        case description
    }
    @State public var store: ViewStore<IdeaList.State, IdeaList.Action>
    
    @State private var isCreatingIdea: Bool = false
    @State private var description: String = ""
    @FocusState private var focusField: Field?
    
    func ideaboxSwipe(gestureVal: CGFloat){
        if(gestureVal < 0){ // up
            isCreatingIdea = true
        }
        if(gestureVal > 0) { // down
            isCreatingIdea = false
        }
    }
    
    var body: some View {
        Group {
            if isCreatingIdea {
                VStack {
                    HStack {
                        Text("Enter your idea")
                        Spacer()
                        Button(action: {
                            store.send(.addIdea(self.description))
                            description = ""
                            isCreatingIdea = false
                        }) {
                            Text("Create")
                        }
                    }.frame(maxWidth: .infinity)
                    TextEditor(text: $description)
                        .focused($focusField, equals: .description)
                }.onAppear {
                    focusField = .description
                }
            } else{
                Button("Add a new idea", action: {isCreatingIdea.toggle()})
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in ideaboxSwipe(gestureVal: value.translation.height)
            }))
        .padding()
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
