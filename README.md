 # VimDoc

A Neovim plugin for accessing external library documentation without leaving the editor.

The goal of VimDoc is to bring external documentation sources into a Neovim help-style workflow.

VimDoc fetches documentation from external sources, converts it into native Vim help files, generates help tags,
and integrates it with Neovim's built-in `:help` system.

VimDoc first downloads and converts documentation into Vim help files.
Once generated, the documentation becomes available through Neovim's built-in :help command.
Each documentation format (RST, Markdown, HTML, etc.) is implemented as an adapter
that converts raw documentation into a common intermediate representation before rendering.
This architecture allows multiple documentation formats to share the same rendering pipeline.

## Current Features

- Fetches documentation from supported sources.
- Tree-sitter–based RST parsing.
- Adapter architecture.
- Renderer that generates native Vim help files and helptags automatically.
- Automatic caching.
- Configurable documentation sources.

## Examples

### Example Config:
```lua

require("vimdoc").setup({
    output_dir = "./doc",
    sources = { 
        hump = {
            name = "hump",
            fetcher = "github",
            repo = "vrld/hump",
            branch = "master",
            doc_path = "docs",
            format = "rst",
            extension = ".rst",
        }, 
    },
})
```

### Example Workflow:
```vim
:Vimdoc hump timer
```
Fetches:
```
VRLD/HUMP
docs/timer.rst
```

and allows for the usage of:
```vim
:help hump.timer
```
to access documentation inside Neovim.

## Supported Documentation Formats

✓ reStructuredText
  - Tree-sitter parsing
  - Helptag generation

○ Markdown
  - Planned

○ HTML
  - Planned

○ MediaWiki
  - Planned

## Architecture

Fetcher
    ↓
Extractor
    ↓
Parser / Adapter
    ↓
Block representation
    ↓
Renderer
    ↓
Vim + Helptags


## Project Roadmap

- Markdown adapter
- HTML adapter
- Additional fetchers
- Download entire documentation sets
- Improved cache management
- Better configuration API

## Project Status

VimDoc is currently in active development and the API may change while additional
documentation formats and source backends are implemented.
