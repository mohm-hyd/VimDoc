---@meta

---@class Text
---@field type "text"
---@field text string

---@class InlineCode
---@field type "inline_code"
---@field text string

---@class Link
---@field type  "link"
---@field children InlineNode[]
---@field target string

---@class Strong
---@field type  "strong"
---@field children InlineNode[]

---@class Emphasis
---@field type  "emphasis"
---@field children  InlineNode[]

---@class Anchor
---@field type  "anchor"
---@field id  string
---@field children  InlineNode[]

---@alias InlineNode
---|    Text
---|    InlineCode
---|    Link
---|    Strong
---|    Emphasis
---|    Anchor

---@class Heading
---@field type  "heading"
---@field level integer
---@field children InlineNode[]

---@class Paragraph
---@field type "paragraph"
---@field children InlineNode[]

---@class Code
---@field type  "code"
---@field language string
---@field text string

---@class ListItem
---@field children InlineNode[]

---@class List
---@field type "list"
---@field items ListItem[]
---
---@class Table
---@field type "table"
---@field rows InlineNode[][][]

---@alias Block
---|    Heading
---|    Paragraph
---|    Code
---|    List
---|    Table

---@class GithubSource
---@field name string
---@field fetcher "github"
---@field repo string
---@field branch string
---@field doc_path string
---@field format "rst"|"markdown"
---@field extension string

---@class MediaWikiSource
---@field name string
---@field fetcher "mediawiki"
---@field project_url string
---@field endpoint string
---@field format "html"

---@alias Source
---| GithubSource
---| MediaWikiSource

---@alias Fetcher
---| "github"
---| "mediawiki"

---@alias Format
---| "rst"
---| "markdown"
---| "html"

---@class GithubDocument
---@field source GithubSource
---@field page string
---@field tag string
---@field raw string?
---@field content Block[]?
---@field output string?

---@class MediaWikiDocument
---@field source MediaWikiSource
---@field page string
---@field tag string
---@field raw string?
---@field content Block[]?
---@field output string?

---@alias Document
---|GithubDocument
---|MediaWikiDocument

---@class OpenRequest
---@field source string
---@field page string

---@alias Handler fun(node:TSNode, blocks: Block[], lines: string)

---@alias InlineParser fun(text: string): InlineNode[]
---@alias InlineRule fun(text: string, parse_inline: InlineParser): InlineNode?, string

---@alias InlineRenderer fun(node: InlineNode): string
---@alias BlockRenderer fun(block: Block, output: string[]): nil
