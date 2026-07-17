 VimDoc Plugin — Design Notes

## Project Goal

Create a Neovim/Vim plugin that allows users to access external library documentation from inside Vim using a Vim help-style workflow.

The goal is not to replace documentation websites, but to integrate external documentation into the editor workflow.

The plugin should support different documentation sources and formats, allowing users to access documentation for libraries, frameworks, and tools without leaving Neovim.

Example goal:

```vim
:help love.physics

should eventually open generated documentation for the LÖVE 2D library.

Current Architecture

The plugin is designed around separating documentation sources, fetching, and rendering.

Current structure:

vimdoc
├── plugin/
│   └── vimdoc.lua
├── lua/
│   └── vimdoc/
│       ├── init.lua
│       ├── renderer.lua
│       └── sources/
└── flake.nix
Core

The core plugin handles:

User commands
Documentation queries
Source lookup
Passing documentation to renderers

Example:

:VimDoc hump.timer

The query is split into:

source.page

Example:

hump.timer

source:
hump

page:
timer

The source configuration determines how the documentation should be retrieved.

Documentation Sources

Sources define where documentation comes from.

A source contains:

Documentation location
Fetching method
Documentation format

Examples:

GitHub-hosted documentation
MediaWiki documentation
Future static documentation sources

Example configuration idea:

vimdoc.setup({
    sources = {
        hump = {
            fetcher = "github",
            format = "rst",
            repo = "vrld/hump",
            docs = "docs"
        }
    }
})
Fetchers

Fetchers are responsible for retrieving raw documentation.

The fetcher receives information from the source configuration and returns documentation text.

Example workflow:

vimdoc hump.timer

        |
        v

Source lookup

        |
        v

GitHub fetcher

        |
        v

Generate raw GitHub URL

        |
        v

Fetch documentation file

        |
        v

Return raw documentation text
Current Supported Source
GitHub Documentation Source

The current implementation supports fetching documentation from GitHub-hosted files.

Example:

Repository:

VRLD/HUMP

Documentation:

docs/timer.rst

Workflow:

vimdoc hump.timer

        |
        v

GitHub fetcher

        |
        v

timer.rst

        |
        v

Renderer

        |
        v

Neovim documentation buffer

Currently supported formats:

RST
Markdown
Renderer

The renderer converts fetched documentation into a Neovim buffer.

Current functionality:

Creates a scratch buffer
Assigns a documentation buffer name
Adds Vim help-style headers and tags

Example generated header:

==============================================================================
hump.timer *hump.timer*

Current workflow:

Documentation text

        |
        v

Renderer

        |
        v

Neovim buffer

Future goal:

Documentation text

        |
        v

Vim help formatter

        |
        v

Generated help file

        |
        v

:help documentation
Initial Use Case: LÖVE 2D Documentation

The first documentation source investigated was the LÖVE 2D wiki.

Source:

https://love2d.org/wiki/

The wiki uses:

MediaWiki
Semantic MediaWiki

The documentation is hosted on the wiki rather than stored directly in the GitHub repository.

MediaWiki API Investigation

MediaWiki provides multiple APIs that expose different parts of the wiki.

Investigated:

MediaWiki REST API
MediaWiki Action API

The current design is that multiple APIs may be used together instead of relying on a single endpoint.

MediaWiki REST API

Example endpoint:

https://love2d.org/w/rest.php

Potential uses:

Searching pages by title
Finding documentation pages
Autocomplete suggestions

Possible workflow:

User input:

love.physics.newBody

        |
        v

REST API searches for matching page

        |
        v

Returns:

love.physics page
MediaWiki Action API

Example endpoint:

https://love2d.org/w/api.php

Potential uses:

Retrieving raw page content
Retrieving wikitext
Querying metadata

Example:

action=query
prop=revisions
rvprop=content
titles=love.physics

Possible returned data:

{{newin|[[0.4.0]]}}

Can simulate 2D rigid bodies...

== Functions ==
MediaWiki Current Challenges
Cloudflare Protection

While testing API requests through curl, the LÖVE wiki Cloudflare protection blocked automated requests.

Observed:

HTTP/2 403
server: cloudflare
content-type: text/html

This means:

Lua request handling works
curl integration works
API URL construction works
Cloudflare blocks automated access

Possible future solutions:

Use another documentation source
Support GitHub-hosted documentation
Support static documentation sources
Add configurable documentation backends
Development Environment

A separate Nix development environment was created for plugin testing.

Purpose:

Avoid testing inside the main Home Manager-managed Neovim configuration.

Workflow:

Edit plugin source

        |
        v

Switch to test tmux session

        |
        v

Launch development Neovim

        |
        v

Test plugin changes

The development environment loads the plugin directly from the repository runtime path.

Future: Vim Help Integration

The long-term goal is to integrate with the native Vim help system.

Target workflow:

User

 |
 | :help hump.timer
 |
 v

Generated documentation file

 |
 v

Vim help tags

 |
 v

Normal Vim help navigation

Possible implementation:

Fetch documentation

        |
        v

Convert to Vim help format

        |
        v

Write generated .txt file

        |
        v

Run helptags

        |
        v

:help documentation
Future: Documentation Cache

Documentation should eventually not need to be downloaded every time.

Possible cache location:

~/.local/share/vimdoc/

Possible structure:

vimdoc/
└── libraries/
    └── hump/
        ├── pages/
        └── generated/

Possible cached data:

Raw documentation files
Generated Vim help files

The final caching strategy depends on the renderer architecture.

Completed Milestones
Vertical Slice

Input:

vimdoc hump.timer

Output:

Documentation displayed inside Neovim.

Implemented:

Configurable sources
GitHub fetcher
RST/Markdown fetching
Documentation renderer
Named documentation buffers
Vim help-style headers
Separate testing environment
Next Milestone

Generate real Vim help documentation:

Fetch

 |

 v

Render Vim help file

 |

 v

Write to doc directory

 |

 v

Generate helptags

 |

 v

:help documentation
Development Philosophy

The plugin should be built incrementally.

AI tools should be used as development assistance, not as a replacement for understanding.

Good uses:

Explaining unfamiliar systems
Designing architecture
Debugging problems
Generating small helper functions
Creating test cases

Avoid:

Generating the entire plugin without understanding
Building complex systems before validating smaller pieces
