//
//  iOSKeywords1.swift
//  AiAiOh
//  2/5/26
//  iOS Keywords & Phrases - simplified for native SwiftUI Text rendering
//

import Foundation

let iOSKeywordsMarkdown = """
**iOS Keywords & Phrases**

**1. Core iOS Concepts**

**App Lifecycle**
App launch, Cold start, Warm start, Scene lifecycle, Foreground, Background, Suspended state, Terminated state, Active state, Inactive state, State restoration

**App Architecture Terms**
MVC (Model–View–Controller), MVVM (Model–View–ViewModel), Clean Architecture, Feature-based architecture, Modular architecture, Dependency injection, Single source of truth, Unidirectional data flow, State-driven UI, Reactive architecture, Coordinator pattern, Repository pattern

**Apple Frameworks**
SwiftUI, UIKit, Combine, Core Data, CloudKit, WidgetKit, ActivityKit, StoreKit, Core Animation, Core Graphics, AVFoundation, Vision, MapKit, Core Location, UserNotifications

**2. SwiftUI Vocabulary**

**Core Structure**
View, View hierarchy, Scene, WindowGroup, NavigationStack, NavigationSplitView, TabView, List, ScrollView, LazyVStack, LazyHStack, ZStack, VStack, HStack

**State Management**
@State, @Binding, @StateObject, @ObservedObject, @Environment, @EnvironmentObject, @Published, ObservableObject, Data binding, Two-way binding, View refresh cycle, Source of truth, State mutation, Derived state

**Layout & Positioning**
Safe area, SafeAreaInset, GeometryReader, Frame modifier, Alignment, Padding, Spacer, Layout priority, Intrinsic content size, Adaptive layout, Responsive layout, Dynamic type scaling, Size classes, Compact width, Regular width

**Navigation**
Push navigation, Modal presentation, Sheet, Full screen cover, Popover, Deep linking, Programmatic navigation, Navigation destination, Navigation path, Back stack

**3. UIKit Vocabulary**

**Core UIKit**
UIView, UIViewController, UINavigationController, UITabBarController, UITableView, UICollectionView, UICollectionViewCompositionalLayout, Diffable data source, Reusable cell, Auto Layout, NSLayoutConstraint, Storyboard, XIB, Programmatic UI, First responder, Responder chain

**View Controller Lifecycle**
viewDidLoad, viewWillAppear, viewDidAppear, viewWillDisappear, viewDidDisappear, Layout pass, Rendering cycle

**4. Visual & Interaction Design**

**Apple Design Language**
Human Interface Guidelines (HIG), Native feel, Platform conventions, Visual hierarchy, Depth, Blur materials, Vibrancy, San Francisco font, Dynamic type, Accessibility-first design

**Common UI Components**
Button, Label, TextField, TextEditor, Toggle, Slider, Stepper, Picker, Segmented control, Search bar, Toolbar, Context menu, Swipe actions, Floating action button, Card UI, Bottom sheet

**Interaction Patterns**
Tap gesture, Long press gesture, Drag gesture, Swipe gesture, Pinch gesture, Haptic feedback, Microinteractions, Pull to refresh, Infinite scroll, Skeleton loading, Shimmer loading, Empty state, Error state, Success state

**5. Animation & Motion**

**SwiftUI Animation Terms**
withAnimation, Implicit animation, Explicit animation, Spring animation, Ease in/out, Linear animation, MatchedGeometryEffect, Transition, Opacity transition, Scale transition, Slide transition, Asymmetric transition

**Core Animation**
CALayer, CABasicAnimation, Keyframe animation, Timing curve, Animation duration, Rendering pipeline, 60 FPS, 120Hz ProMotion, GPU compositing

**Motion Design Phrases**
Smooth animation, Fluid motion, Interruptible animation, Physics-based motion, Natural deceleration, Responsive feedback, Tactile feel

**6. Data & Persistence**

**Local Storage**
UserDefaults, Core Data, SwiftData, FileManager, Keychain, On-device storage, Cache layer, Persistent store, In-memory state

**Networking**
REST API, GraphQL, URLSession, Async/await, JSON decoding, Codable, Pagination, Rate limiting, Retry logic, Offline mode, Sync engine, Background fetch

**Cloud & Sync**
CloudKit sync, iCloud storage, Real-time sync, Conflict resolution, Eventual consistency, Local-first architecture

**7. Performance & Optimization**

Lazy loading, Memory management, ARC (Automatic Reference Counting), Retain cycle, Weak reference, Main thread, Background thread, Concurrency, Task, TaskGroup, Actor, Debouncing, Throttling, Rendering performance, Launch time optimization, Battery efficiency

**8. Accessibility**

VoiceOver, Dynamic Type, Reduce Motion, Reduce Transparency, High contrast mode, Accessibility label, Accessibility identifier, Accessibility hint, Focus order, Screen reader support, Tap target size, Color contrast compliance

**9. AI + Modern iOS Feature Language**

**AI/LLM Integration**
On-device model, Foundation Models (Apple), LLM integration, Prompt-driven UI, AI-assisted workflow, Streaming responses, Token usage, Context window, Agent workflow, Tool calling, Structured output

**Modern iOS Features**
Live Activities, Dynamic Island, Interactive widgets, Lock screen widgets, StandBy mode, SharePlay, App Intents, Shortcuts integration, Spotlight indexing, Siri integration

**10. Prompt Phrases for LLM iOS Building**

**UI Construction**
"Create a native iOS SwiftUI interface", "Follow Apple Human Interface Guidelines", "Use state-driven SwiftUI architecture", "Ensure accessibility support", "Use modern iOS design patterns", "Optimize for performance and responsiveness"

**Architecture**
"Use MVVM architecture", "Single source of truth", "Unidirectional data flow", "Modular feature-based structure", "Testable and scalable"

**Animation**
"Add subtle, smooth iOS-style animations", "Use spring-based motion", "Ensure 60fps performance", "Use matched geometry transitions"

**Interaction**
"Native iOS gestures", "Haptic feedback where appropriate", "Fluid and responsive UI", "Minimal latency interaction"

**11. Example Master Prompt Snippet**

*Use this when prompting an LLM:*

Build a native iOS SwiftUI interface using MVVM architecture and state-driven UI. Follow Apple Human Interface Guidelines and use modern iOS patterns like NavigationStack, sheets, and smooth spring animations. Ensure accessibility, performance optimization, and clean unidirectional data flow. The interface should feel native, responsive, and production-quality.
"""
