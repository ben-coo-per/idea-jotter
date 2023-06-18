//
//  Idea_BoxTests.swift
//  Idea BoxTests
//
//  Created by Ben Cooper on 6/15/23.
//
import ComposableArchitecture
import XCTest
@testable import Idea_Box

@MainActor
class Idea_BoxTests: XCTestCase {
  func testAddingToStoreWithoutParent() async {
    let store = TestStore(initialState: IdeaList.State(ideas: [])) {
        IdeaList()
    }
      
      await store.send(.addIdea(idea: "Why are banana's yellow and mushy?", parentId: nil)) {
          $0.ideas[0].description = "Why are banana's yellow and mushy?"
      }
      
  }
}
