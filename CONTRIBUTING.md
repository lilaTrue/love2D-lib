# Contributing to Love2D Library Collection

Thank you for your interest in contributing! This project aims to provide high-quality, reusable libraries for the Love2D community.

## How to Contribute

### Reporting Issues

Found a bug or have a feature request? Please create an issue with:

- **Clear title**: Summarize the issue in one line
- **Description**: Detailed explanation of the problem or feature
- **Steps to reproduce**: For bugs, include code snippets
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: Love2D version, OS, Lua version

### Suggesting Features

When suggesting new features or improvements:

1. Check if it already exists or is planned
2. Explain the use case and benefits
3. Provide examples of how it would be used
4. Consider backwards compatibility

### Pull Requests

We welcome pull requests! Please follow these guidelines:

#### Before Starting

1. **Create an issue** to discuss major changes first
2. **Check existing PRs** to avoid duplicate work
3. **Fork the repository** and create a feature branch

#### Development Process

1. **Branch naming**: Use descriptive names
   - `feature/collision-quadtree`
   - `bugfix/timer-fps-calculation`
   - `docs/update-scene-manager`

2. **Code style**:
   ```lua
   -- Use clear, descriptive names
   local function calculateDistance(x1, y1, x2, y2)
       local dx = x2 - x1
       local dy = y2 - y1
       return math.sqrt(dx * dx + dy * dy)
   end
   
   -- Add comments for complex logic
   -- Use 4 spaces for indentation
   -- Keep functions focused and small
   ```

3. **Documentation**:
   - Update relevant documentation in `/docs`
   - Add inline comments for complex code
   - Include usage examples
   - Update CHANGELOG.md

4. **Testing**:
   - Test your changes thoroughly
   - Ensure backwards compatibility
   - Verify examples still work
   - Test on different platforms if possible

5. **Commit messages**:
   ```
   feat: add quadtree spatial partitioning to CollisionManager
   
   - Implement quadtree data structure
   - Add insert, query, and clear methods
   - Update collision detection to use quadtree
   - Add performance benchmarks
   ```

   Use prefixes:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation changes
   - `perf:` - Performance improvements
   - `refactor:` - Code restructuring
   - `test:` - Adding tests
   - `chore:` - Maintenance tasks

#### Pull Request Checklist

Before submitting your PR, ensure:

- [ ] Code follows project style guidelines
- [ ] All functions have clear documentation
- [ ] Examples demonstrate new features
- [ ] CHANGELOG.md is updated
- [ ] No breaking changes (or clearly documented)
- [ ] Code has been tested with Love2D 11.0+
- [ ] Relevant documentation updated in `/docs`

## Library Guidelines

### Design Principles

1. **Modularity**: Each library should be self-contained
2. **Simplicity**: Easy to understand and use
3. **Performance**: Optimized for Love2D's Lua environment
4. **Extensibility**: Easy to extend and customize
5. **Documentation**: Comprehensive and clear

### API Design

- Use clear, descriptive function names
- Follow Lua naming conventions (camelCase for functions)
- Provide sensible defaults
- Support method chaining where appropriate
- Include error checking and validation

### Documentation Standards

Each library should have:

1. **Overview**: What it does and why it's useful
2. **API Reference**: Complete function documentation
3. **Examples**: Basic and advanced usage
4. **Best Practices**: How to use effectively
5. **Performance Notes**: Optimization tips

Example documentation:

```markdown
### functionName(param1, param2, optionalParam)

Brief description of what the function does.

**Parameters:**
- `param1` (type): Description
- `param2` (type): Description  
- `optionalParam` (type, optional): Description (default: value)

**Returns:** Description of return value

**Example:**
\`\`\`lua
local result = functionName(value1, value2)
\`\`\`

**Notes:**
- Important considerations
- Edge cases to be aware of
```

### Adding New Libraries

When proposing a new library:

1. **Validate need**: Is it broadly useful?
2. **Check scope**: Does it fit the project?
3. **Draft API**: Design before implementation
4. **Create example**: Show real-world usage
5. **Write docs**: Complete documentation
6. **Test thoroughly**: Edge cases and performance

Suggested new libraries:
- InputManager (keyboard/gamepad handling)
- AudioManager (sound pooling and management)
- TweenManager (animation/interpolation)
- StateManager (finite state machines)
- SaveManager (save/load game data)

## Code Review Process

1. **Automated checks**: Code style and basic validation
2. **Manual review**: Code quality and design
3. **Testing**: Verify functionality
4. **Documentation review**: Ensure completeness
5. **Approval**: Merge when all checks pass

## Community Guidelines

- Be respectful and constructive
- Help others learn and improve
- Focus on the code, not the person
- Welcome newcomers
- Share knowledge

## Questions?

- Create an issue for questions
- Check existing documentation
- Review examples in `/example`
- Read the CHANGELOG.md

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make Love2D development better! 🎮
