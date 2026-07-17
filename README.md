# VimDoc

A Neovim plugin for accessing external library documentation without leaving the editor.

The goal of VimDoc is to bring external documentation sources into a Vim help-style workflow.

Instead of switching between Neovim and a browser, users should eventually be able to do:

```vim
:help library.function

and access documentation directly inside Vim.

Goals
Fetch documentation from external sources
Support different documentation formats and providers
Convert documentation into Vim help-compatible files
Cache documentation locally
Integrate with the native Vim help system
Current Status

VimDoc is currently in early development.

The current implementation focuses on building the documentation pipeline:

Documentation source

        |

        v

Fetcher

        |

        v

Raw documentation text

        |

        v

Renderer

        |

        v

Neovim documentation buffer
Current Features

Implemented:

Neovim plugin structure
Separate development environment using Nix
Isolated testing workflow
Configurable documentation sources
GitHub documentation fetching
RST and Markdown documentation retrieval
Documentation renderer
Named documentation buffers
Vim help-style headers and tags
Example

Current workflow:

:VimDoc hump.timer

Fetches:

VRLD/HUMP

docs/timer.rst

and displays the documentation inside Neovim.

Supported Documentation Sources
GitHub

Currently supported.

Example sources:

RST documentation files
Markdown documentation files
MediaWiki

Initial investigation source.

The LÖVE 2D wiki was used as the first API experiment.

Investigated:

MediaWiki REST API
MediaWiki Action API

Current challenges:

Cloudflare blocks automated requests to the LÖVE wiki API

Future support may include additional documentation backends.

Development

VimDoc uses a separate Nix development environment for testing.

Development workflow:

Edit plugin

    |

    v

Launch testing Neovim instance

    |

    v

Test changes without affecting main configuration

This allows the plugin to be developed independently from the user's main Neovim setup.

Future Plans
Vim Help Integration

The main goal is to generate real Vim help documentation:

Fetch documentation

        |

        v

Convert to Vim help format

        |

        v

Generate help tags

        |

        v

:help documentation
Documentation Cache

Future versions will cache downloaded documentation locally to avoid repeated requests.

Possible cache location:

~/.local/share/vimdoc/
Project Status

This project is currently a learning project focused on:

Neovim plugin development
Documentation formats
API integration
Text processing
Vim help system internals
