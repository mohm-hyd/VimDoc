Updated Design Notes
# VimDoc Plugin — Design Notes

## Project Goal

Create a Neovim/Vim plugin that allows users to access external library documentation from inside Vim using a Vim help-style workflow.

The goal is not to replace documentation websites, but to integrate external documentation into the editor workflow.

Example:

```vim
:help love.physics

should eventually be able to open generated documentation for the LÖVE 2D library.

Initial Use Case: LÖVE 2D Documentation

The first documentation source is the LÖVE 2D wiki.

Source:

https://love2d.org/wiki/

The wiki uses:

MediaWiki
Semantic MediaWiki

The documentation is hosted on the wiki rather than stored directly in the GitHub repository.

Documentation Retrieval
MediaWiki APIs

MediaWiki provides several APIs that expose different parts of the wiki.

Currently investigated:

MediaWiki REST API
MediaWiki Action API

The current idea is that multiple APIs may be used together rather than relying on a single endpoint.

API Investigation
1. MediaWiki REST API

Example endpoint:

https://love2d.org/w/rest.php

The REST API provides higher-level operations.

Potential uses:

Searching pages by title
Finding documentation pages from user input
Autocomplete suggestions

Example workflow:

User input:
love.physics.newBody

        |
        v

REST API searches for matching page

        |
        v

Returns:
love.physics page
2. MediaWiki Action API

Example endpoint:

https://love2d.org/w/api.php

The Action API provides lower-level access to wiki data.

Potential uses:

Retrieving raw page content
Retrieving wikitext
Querying page metadata

Example:

action=query
prop=revisions
rvprop=content
titles=love.physics

Possible returned data:

{{newin|[[0.4.0]]}}

Can simulate 2D rigid bodies...

== Functions ==
Current Retrieval Idea

The current design is moving toward a two-stage process:

User
 |
 | :VimDoc love.physics
 |
 v
Search documentation source
 |
 | REST API
 |
 v
Find matching page
 |
 |
 v
Retrieve page contents
 |
 | Action API
 |
 v
Wikitext
 |
 v
Convert to Vim help format
 |
 v
Generated :help page
Current Challenges
Cloudflare Protection

While testing API requests through curl, the LÖVE wiki Cloudflare protection blocks requests before they reach MediaWiki.

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

Local Cache Idea

Documentation should not be downloaded every time.

Possible cache:

~/.local/share/vimdoc/

Example:

vimdoc/
└── love2d/
    ├── pages/
    └── generated/
First Milestone

The first successful version should:

Input:

love.physics

Output:

Generated Vim help file

Usage:

:help love.physics

No:

fuzzy searching
multiple documentation sources
automatic indexing
advanced UI

First goal:

Find page → Fetch content → Convert → Open in Vim help
