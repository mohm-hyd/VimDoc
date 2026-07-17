# VimDoc

A Neovim plugin for accessing external library documentation without leaving the editor.

The goal of VimDoc is to bring external documentation sources into a Neovim help-style workflow.

Instead of switching between Neovim and a browser, users should eventually be able to do:

```vim
:help library.function
```
and access documentation directly inside Neovim.

## Goals
- Fetch documentation from external sources
- Support different documentation formats and providers
- Convert documentation into Neovim help-compatible files
- Cache documentation locally
- Integrate with the native Neovim help system

### Current Status

VimDoc is currently in early development.

The current implementation focuses on building the documentation pipeline:

Documentation source -> Fetcher -> Raw documentation text -> Renderer -> Neovim documentation buffer

## Current Features Implemented:

- Neovim plugin structure
- Separate development environment using Nix
- Isolated testing workflow
- Configurable documentation sources
- GitHub documentation fetching
- RST and Markdown documentation retrieval
- Documentation renderer
- Named documentation buffers
- Neovim help-style headers and tags

### Example

Current workflow:
```vim
:VimDoc hump.timer
```
Fetches:
```
VRLD/HUMP
docs/timer.rst
```

and displays the documentation inside Neovim.

## Supported Documentation Sources

### GitHub

Currently supported.

Example sources:

- RST documentation files
- Markdown documentation files
### MediaWiki

Initial investigation source.

The LÖVE 2D wiki was used as the first API experiment.

Investigated:

- MediaWiki REST API
- MediaWiki Action API

Current challenges:

Cloudflare blocks automated requests to the LÖVE wiki API

Future support may include additional documentation backends.

## Development

VimDoc uses a separate Nix development environment for testing.

Development workflow:

Edit plugin -> Launch testing Neovim instance -> Test changes without affecting main configuration

This allows the plugin to be developed independently from the user's main Neovim setup.

## Future Plans

### Neovim Help Integration


The main goal is to generate real Neovim help documentation:

Fetch documentation -> Convert to Neovim help format -> Generate help tags -> :help documentation

### Documentation Cache

Future versions will cache downloaded documentation locally to avoid repeated requests.

Possible cache location:
```
~/.local/share/vimdoc/
```
 
## Project Status

This project is currently a learning project focused on:

- Neovim plugin development
- Documentation formats
- API integration
- Text processing
- Neovim help system internals
