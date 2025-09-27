# Tech Context: Love2D Library Collection

## Technologies Used

### Core Technologies
- **Love2D Framework**: Version 11.0+ - Primary game development framework
- **Lua Programming Language**: Version 5.1+ - Scripting language used by Love2D
- **Git**: Version control system for source code management
- **GitHub**: Repository hosting and collaboration platform

### Development Tools
- **Visual Studio Code**: Primary IDE for development
- **Git**: Version control and collaboration
- **Love2D Executable**: For running and testing games locally
- **Markdown**: Documentation format for README and docs

### Testing and Quality Assurance
- **Manual Testing**: Love2D runtime testing of examples
- **Cross-Platform Testing**: Testing on different operating systems
- **Performance Profiling**: Built-in Love2D debugging tools

## Development Setup

### Environment Requirements
- **Operating System**: Linux, Windows, macOS (Love2D cross-platform support)
- **Love2D Installation**: Version 11.0 or later required
- **Git**: For cloning and version control
- **Text Editor/IDE**: VS Code recommended with Lua extensions

### Project Structure Setup
```
love lib/
├── .clinerules/          # Memory bank and rules
├── lib/                  # Core library files
├── docs/                 # Documentation
├── example/              # Example projects
└── README.md            # Project overview
```

### Local Development Workflow
1. **Clone Repository**: `git clone https://github.com/lilaTrue/love2D-lib.git`
2. **Navigate to Directory**: `cd love lib`
3. **Run Examples**: Use Love2D to execute example projects
4. **Modify Libraries**: Edit files in `lib/` directory
5. **Test Changes**: Run examples to verify functionality
6. **Commit Changes**: Use Git for version control

## Technical Constraints

### Love2D Framework Limitations
- **Lua Version**: Restricted to Lua 5.1 features (no Lua 5.2+ enhancements)
- **Memory Management**: Manual memory management required for performance
- **Threading**: Single-threaded execution model
- **File System**: Sandboxed file access within game directory

### Performance Constraints
- **Frame Rate Target**: 60 FPS minimum for smooth gameplay
- **Memory Usage**: Limited RAM on target platforms
- **CPU Usage**: Must run efficiently on lower-end hardware
- **Garbage Collection**: Minimize GC pauses for consistent performance

### Compatibility Constraints
- **Love2D Versions**: Must support Love2D 11.0+
- **Operating Systems**: Windows, macOS, Linux support required
- **Lua Standards**: Follow Lua 5.1+ best practices
- **API Stability**: Maintain backward compatibility

## Dependencies

### Runtime Dependencies
- **Love2D Framework**: Core dependency for all functionality
- **Lua Standard Library**: Built-in Lua functions and modules
- **Love2D Modules**: Graphics, audio, input, filesystem modules

### Development Dependencies
- **Git**: Version control system
- **Text Editor**: For code editing
- **Love2D Executable**: For running and testing

### No External Dependencies
- **Zero Third-Party Libraries**: All code is self-contained
- **No Package Managers**: Direct file inclusion only
- **No Network Dependencies**: Libraries work offline

## Tool Usage Patterns

### Code Organization
- **Modular Structure**: Each library in separate file
- **Consistent Naming**: CamelCase for classes, lowercase for functions
- **Documentation Comments**: Inline comments explaining complex logic
- **Error Handling**: Graceful failure with meaningful messages

### Testing Patterns
- **Example Projects**: Standalone demos for each library
- **Manual Verification**: Human testing of functionality
- **Performance Testing**: Frame rate monitoring during gameplay
- **Cross-Platform Testing**: Verification on multiple operating systems

### Documentation Patterns
- **Markdown Format**: All documentation in Markdown
- **API Reference**: Comprehensive function documentation
- **Usage Examples**: Code snippets showing common patterns
- **Best Practices**: Guidelines for optimal usage

### Version Control Patterns
- **Feature Branches**: New features developed in separate branches
- **Descriptive Commits**: Clear commit messages explaining changes
- **Semantic Versioning**: Version numbers following semantic rules
- **Release Tags**: Tagged releases for stable versions

## Build and Deployment

### Distribution Method
- **GitHub Repository**: Primary distribution channel
- **Direct Download**: Users can download individual files
- **Git Submodules**: Can be included in other projects
- **Copy/Paste**: Libraries can be copied into existing projects

### Deployment Checklist
- [ ] All examples run without errors
- [ ] Documentation is up-to-date
- [ ] Performance benchmarks pass
- [ ] Cross-platform compatibility verified
- [ ] Version number updated appropriately
