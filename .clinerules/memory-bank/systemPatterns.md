# System Patterns: Love2D Library Collection

## System Architecture

### Modular Library Design
Each library operates as an independent module with minimal interdependencies:
- **SceneManager**: Handles scene lifecycle and event routing
- **ClassManager**: Provides OOP framework with Love2D integration
- **CollisionManager**: Manages collision detection and state tracking

### Event-Driven Architecture
Libraries integrate seamlessly with Love2D's callback system:
- Automatic event forwarding from Love2D to active scenes
- Callback chaining for extensible behavior
- Event bubbling through scene hierarchies

## Key Technical Decisions

### Lua OOP Implementation
- **Decision**: Custom class system instead of relying on third-party libraries
- **Rationale**: Ensures Love2D-specific optimizations and full control over inheritance patterns
- **Impact**: Consistent API across all game objects, easier debugging and profiling

### Scene Management Pattern
- **Decision**: Stack-based scene management with push/pop operations
- **Rationale**: Supports complex UI flows (menus, dialogs, pause screens) without state conflicts
- **Impact**: Enables complex game state management without manual state tracking

### Collision State Tracking
- **Decision**: Unity-style collision states (enter/stay/exit) instead of simple boolean checks
- **Rationale**: Provides more granular control over collision responses and timing
- **Impact**: Supports advanced game mechanics like trigger zones and state-based interactions

## Design Patterns

### Singleton Pattern
- **Usage**: SceneManager and ClassManager use singleton instances
- **Benefit**: Global access without passing references, consistent state management
- **Implementation**: Lazy initialization with thread-safe access patterns

### Factory Pattern
- **Usage**: Class creation through `createLove2DClass()` and scene creation through `createScene()`
- **Benefit**: Encapsulates object creation logic, ensures proper initialization
- **Implementation**: Returns configured objects ready for immediate use

### Observer Pattern
- **Usage**: Event forwarding system in SceneManager
- **Benefit**: Decouples event producers from consumers
- **Implementation**: Automatic callback delegation to active scenes

### Strategy Pattern
- **Usage**: Pluggable collision detection algorithms
- **Benefit**: Allows different collision strategies (rectangle, circle, custom shapes)
- **Implementation**: Polymorphic collider objects with consistent interfaces

## Component Relationships

### SceneManager Dependencies
```
SceneManager
├── Scene (base class)
│   ├── MenuScene
│   ├── GameScene
│   └── PauseScene
└── Event System
    ├── Love2D Callbacks
    └── Custom Events
```

### ClassManager Dependencies
```
ClassManager
├── Base Class
│   ├── Love2D Class Template
│   └── Custom Classes
└── Mixin System
    ├── Love2D Integration
    └── Custom Behaviors
```

### CollisionManager Dependencies
```
CollisionManager
├── Collider Base
│   ├── RectCollider
│   └── CircleCollider
├── Collision Detection
│   ├── Broad Phase
│   └── Narrow Phase
└── State Tracking
    ├── Collision Events
    └── Debug Visualization
```

## Critical Implementation Paths

### Scene Transitions
1. **Initiate Transition**: Call `SceneManager:setScene()` or `pushScene()`
2. **Unload Current**: Execute `scene:unload()` if exists
3. **Load New Scene**: Execute `scene:load()` if exists
4. **Update Active Reference**: Set new scene as active
5. **Forward Events**: Begin routing Love2D callbacks to new scene

### Class Instantiation
1. **Create Class**: Call `classManager.createLove2DClass()`
2. **Setup Inheritance**: Link to parent class if specified
3. **Add Mixins**: Apply mixin behaviors if provided
4. **Register Class**: Store in class registry for debugging
5. **Return Constructor**: Provide `new()` method for instantiation

### Collision Detection
1. **Broad Phase**: Quick elimination of non-colliding objects
2. **Narrow Phase**: Precise collision detection between candidates
3. **State Update**: Compare current vs previous collision states
4. **Event Dispatch**: Trigger enter/stay/exit callbacks as needed
5. **Debug Render**: Optional visualization of collision bounds

## Performance Optimizations

### Memory Management
- **Object Pooling**: Reuse collider objects to reduce garbage collection
- **Lazy Loading**: Load scenes only when needed
- **Reference Management**: Weak references for event listeners

### Algorithm Optimizations
- **Spatial Partitioning**: Grid-based collision detection for large scenes
- **Early Exit**: Quick rejection tests before expensive calculations
- **Caching**: Store frequently used calculations (collision normals, distances)

### Lua-Specific Optimizations
- **Local Variables**: Cache frequently accessed globals
- **Table Reuse**: Minimize table creation in hot paths
- **Numeric Operations**: Prefer integer arithmetic where possible
