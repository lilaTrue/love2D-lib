-- Luacheck configuration for Love2D Library Collection
-- See https://luacheck.readthedocs.io/en/stable/config.html

-- Ignore specific warnings
ignore = {
    "211", -- Unused local variable
    "212", -- Unused argument
    "213", -- Unused loop variable
    "311", -- Value assigned to variable is unused
    "411", -- Redefining local variable
    "412", -- Redefining argument
    "421", -- Shadowing definition of variable
    "422", -- Shadowing definition of argument
    "431", -- Shadowing upvalue
    "432", -- Shadowing upvalue argument
}

-- Don't check line length
max_line_length = false

-- Don't check cyclomatic complexity
max_cyclomatic_complexity = false

-- Globals that are okay to use
globals = {
    "love",  -- Love2D framework
}

-- Globals that can be set
new_globals = {}

-- Read-only globals
read_globals = {
    "love",
}

-- Files to exclude
exclude_files = {
    "example/*/lib/*.lua",  -- Copied libraries in examples
}

-- Specific file configurations
files["lib/classManager.lua"] = {
    ignore = {"542"},  -- Empty if branch (for template functions)
}

files["lib/SceneManager.lua"] = {
    ignore = {"542"},  -- Empty if branch
}

files["lib/CollisionManager.lua"] = {
    ignore = {"542"},
}

files["lib/TimerManager.lua"] = {
    ignore = {"542"},
}

-- Example files are less strict
files["example/**/*.lua"] = {
    ignore = {
        "111", -- Setting non-standard global variable
        "112", -- Mutating non-standard global variable
        "113", -- Accessing non-standard global variable
    },
}

-- Demo files
files["demo_*.lua"] = {
    ignore = {
        "211", -- Unused local variable (demos are for showing code)
        "311", -- Value assigned to variable is unused
    },
}
