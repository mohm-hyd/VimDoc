
# VimDoc Plugin — Initial Design Notes

## Project Goal

Create a Neovim/Vim plugin that allows users to access external library documentation from inside Vim using the normal Vim help system.

The idea is not to replace existing documentation websites, but to bring documentation into the editor workflow.

Example goal:

```
:help love.physics
```

should be able to open generated documentation for the LÖVE 2D library.

---

# Initial Use Case: LÖVE 2D Documentation

The first documentation source to support will be the LÖVE 2D wiki.

Source:

```
https://love2d.org/wiki/
```

The wiki is powered by:

* MediaWiki
* Semantic MediaWiki extension

The documentation is not stored directly in the GitHub repository. It exists on the wiki.

---

# Documentation Retrieval

## MediaWiki API

MediaWiki provides public APIs for retrieving wiki content.

Important endpoint:

```
https://love2d.org/w/api.php
```

Pages are retrieved using the page title.

Example:

```
page=love.physics
```

means:

```
https://love2d.org/wiki/love.physics
```

The page parameter is not a class name or API object. It is simply the MediaWiki page title.

---

# Possible Retrieval Methods Investigated

## 1. Parse API (HTML)

Example:

```
action=parse
page=love.physics
prop=text
format=json
```

Returns rendered HTML.

Example output:

```html
<h2>Functions</h2>
<table>
...
</table>
```

### Pros

* MediaWiki already processes templates
* Links are resolved
* Semantic MediaWiki output is generated

### Cons

* Requires HTML → Vim help conversion
* Generated HTML contains lots of unnecessary markup
* Harder to control formatting

Decision:

Not preferred for MVP.

---

## 2. Raw / Revision Content (Chosen)

Use the revisions API to retrieve the original wiki source.

Example:

```
action=query
prop=revisions
rvprop=content
titles=love.physics
```

Returns wikitext:

Example:

```
{{newin|[[0.4.0]]|040|type=module}}

Can simulate 2D rigid bodies...

== Types ==

== Functions ==
```

### Pros

* Closest to the author's original documentation
* Easier to transform into Vim help format
* Gives control over output
* Avoids depending on HTML structure

Decision:

Use wikitext as the initial source format.

---

# Initial Data Flow

```
User
 |
 | :VimDoc love.physics
 |
 v
Plugin checks local cache
 |
 |
 +---- Documentation exists
 |          |
 |          v
 |     Generate/open Vim help
 |
 |
 +---- Missing
            |
            v
      MediaWiki API
            |
            v
        Wikitext
            |
            v
     Wikitext converter
            |
            v
      Vim help file
            |
            v
        :helptags
            |
            v
       :help love.physics
```

---

# Local Cache Idea

Documentation should not be downloaded every time.

Possible cache location:

```
~/.local/share/vimdoc/
```

Example:

```
~/.local/share/vimdoc/
└── love2d/
    ├── love.physics.wiki
    ├── love.physics.newBody.wiki
    └── generated/
        └── love2d.txt
```

---

# Vim Help Format

The generated documentation should follow normal Vim help conventions.

Example:

```
==============================================================================
love.physics                                      *love.physics*

Can simulate 2D rigid bodies in a realistic manner.


FUNCTIONS ~

love.physics.newBody()                            *love.physics.newBody*

Creates a new body.
```

Important parts:

* Header lines using `=`
* Help tags using `*tagname*`
* Sections using uppercase headings

---

# Initial Wikitext Conversion Scope

Do NOT attempt to support all MediaWiki syntax initially.

Start with:

| MediaWiki            | Vim Help           |
| -------------------- | ------------------ |
| `== Heading ==`      | section            |
| `=== Subheading ===` | subsection         |
| normal paragraphs    | normal text        |
| `[[Link]]`           | help tag/reference |
| lists                | lists              |

Ignore initially:

* Images
* Complex tables
* Templates
* Semantic MediaWiki queries
* Dynamic generated sections

---

# Current Problem Discovered

The LÖVE wiki uses Semantic MediaWiki.

Example:

```
{{#ask:
 [[Category:Functions]]
 [[parent::love.physics]]
}}
```

These queries generate the function/type tables.

The raw wikitext does not contain the final generated content.

Possible future solutions:

1. Use Parse API for those sections
2. Query Semantic MediaWiki directly
3. Support only normal pages initially
4. Combine raw + API-generated data

For MVP, ignore this problem.

---

# Tree-sitter / Parsers Notes

Investigated:

```
tree-sitter-vimdoc
```

Important distinction:

A parser reads a format and creates a structured representation.

Example:

```
Vim help text
      |
      v
syntax tree
```

Tree-sitter-vimdoc is useful for analyzing existing Vim help files.

It is probably not required for the first version.

---

# AI Usage Plan

AI should be used as a development assistant, not as a replacement for understanding.

Good uses:

* Explain unfamiliar formats
* Help design architecture
* Generate small parser functions
* Create test cases
* Debug conversion problems

Avoid:

* Generating the entire plugin at once
* Building a large system before understanding the pieces

---

# First Milestone (Vertical Slice)

The first successful version should do only this:

Input:

```
love.physics
```

Output:

```
love2d.txt
```

Usage:

```
:help love.physics
```

No:

* fuzzy search
* multiple libraries
* automatic indexing
* fancy UI

Just:

```
Fetch one page → Convert → Open in Vim help
```

---

# Current Decision Summary

Documentation source:
✅ MediaWiki revisions API

Format:
✅ Raw wikitext

Target:
✅ Vim help format

First library:
✅ LÖVE 2D

First goal:
✅ Generate one working `:help` page
