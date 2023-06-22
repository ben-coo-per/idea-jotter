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
                    List(viewStore.ideas.filter({$0.parent==nil}), id: \.self.id) { idea in
                        NavigationLink(destination: {
                            IdeaDetailView(parentId: idea.id, store: viewStore)
                        }){
                            Text(idea.description).lineLimit(1).truncationMode(.tail)
                        }
                    }
                    AddIdeaInputBoxView(store: viewStore)
                }.navigationTitle("Ideas")
            }
        }
    }
}

struct IdeaDetailView: View {
    @State var parentId: UUID
    @State public var store: ViewStore<IdeaList.State, IdeaList.Action>
    
    var body: some View {
        ScrollView {
            VStack {
                IdeaDisplay(idea:store.ideas.first(where: {$0.id==parentId})!)
                ForEach(store.ideas.filter({$0.parent==parentId}), id: \.id) { childIdea in
                    Text(childIdea.description).padding()
                }
            }
        }
        AddIdeaInputBoxView(store: store, parentId: parentId)
    }
}

struct IdeaDisplay: View {
    @State var idea: Idea
    
    var body: some View {
        HStack {
            Text(idea.description)
        }
    }
}


struct AddIdeaInputBoxView: View {
    private enum Field {
        case description
    }
    @State public var store: ViewStore<IdeaList.State, IdeaList.Action>
    @State public var parentId: UUID?
    
    
    @State private var isCreatingIdea: Bool = false
    @State private var description: String = ""
    @FocusState private var focusField: Field?
    
    var body: some View {
        Group {
            if isCreatingIdea {
                VStack {
                    HStack {
                        Text("Enter your idea")
                        Spacer()
                        Button(action: {
                            if(description.count > 0) {
                                store.send(.addIdea(idea: description, parentId: parentId))
                                description = ""
                            }
                            isCreatingIdea = false
                        }) {
                            Text(description.count > 0 ? "Create" : "Close")
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
