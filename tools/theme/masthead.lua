-- masthead.lua -- house masthead/footer, generated from chapter YAML front matter.
--
-- docs/index.html used to hand-code the masthead (kicker, deck, status tag/note,
-- meta: engines/provenance/caveat) and the footer. Chapters now carry that
-- content as front-matter fields (deck, status_tag, status_note, provenance,
-- caveat, footer_note, engine, book, chapter) and this filter emits the same
-- markup Quarto's default title-block-header is hidden in favour of (see
-- `#title-block-header{display:none}` in tools/theme/stats-hours.css).
--
-- Pages with no `deck` field (e.g. the book/index.qmd landing page) are left
-- untouched -- they supply their own in-body heading.

local function get(meta, key)
  if meta[key] == nil then return "" end
  return pandoc.utils.stringify(meta[key])
end

-- Chapters render into book/, the landing page into the site root, so every
-- chapter-to-landing link is this same "../index.html", one level up.
local LANDING_HREF = "../index.html"

-- The book is published under a split licence (see LICENSING.md): prose,
-- figures and data under CC BY 4.0, the code under GPL-3. Every rendered
-- page names both, so a reader who lands on a chapter from search sees the
-- terms without hunting for a repository file. One line, in the footer,
-- everywhere.
local LICENCE_LINE = 'Text, figures and data are ' ..
  '<a href="https://creativecommons.org/licenses/by/4.0/">CC BY 4.0</a>; code is GPL-3.'

-- A couple of chapters' front matter (the preface's caveat, the coda's)
-- point the reader at "the landing page" in prose but, being metadata
-- rather than qmd body markdown, could never actually link it. Turned into
-- an anchor wherever the phrase appears, in whichever meta field.
local function link_landing_page(text)
  return (text:gsub("the landing page", '<a href="' .. LANDING_HREF .. '">the landing page</a>'))
end

-- Fixed reading order for the previous/next foot-nav: the preface, then
-- Classes 1-10, then Appendix A, then the coda. Each entry is looked up by
-- its own `chapter` field (plus `kicker`, which is what already tells the
-- preface and the coda apart from a numbered class -- see `rung` below), so
-- adding a fourteenth chapter later means adding one row here, not touching
-- the chapters that already exist. `name` names the destination -- rung and
-- title, exactly as that page's own masthead shows them.
local CHAPTERS = {
  { chapter = "0",  kicker = "Preface", file = "wk0-preface.html",
    name = "Preface · Why one engine, and what this book will not cover" },
  { chapter = "1",  kicker = "", file = "wk1-base-camp.html",
    name = "Class 1 · Base camp" },
  { chapter = "2",  kicker = "", file = "wk2-linear-models.html",
    name = "Class 2 · One line through a cloud of sparrows" },
  { chapter = "3",  kicker = "", file = "wk3-glms.html",
    name = "Class 3 · The shape of the noise" },
  { chapter = "4",  kicker = "", file = "wk4-overdispersion.html",
    name = "Class 4 · When the family lies about the spread" },
  { chapter = "5",  kicker = "", file = "wk5-diagnostics.html",
    name = "Class 5 · Is the model any good?" },
  { chapter = "6",  kicker = "", file = "wk6-random-intercepts.html",
    name = "Class 6 · Rows are not strangers" },
  { chapter = "7",  kicker = "", file = "wk7-random-slopes.html",
    name = "Class 7 · Not everyone shares a slope" },
  { chapter = "8",  kicker = "", file = "wk8-reml-vs-ml.html",
    name = "Class 8 · Same model, two answers" },
  { chapter = "9",  kicker = "", file = "wk9-glmms.html",
    name = "Class 9 · Both at once" },
  { chapter = "10", kicker = "", file = "wk10-relatedness.html",
    name = "Class 10 · Not even the groups are strangers" },
  { chapter = "A",  kicker = "", file = "appendix-a-simulation.html",
    name = "Appendix A · Simulation as a way of thinking" },
  { chapter = "13", kicker = "Coda", file = "wk13-coda.html",
    name = "Coda · Where you go next" },
}

-- Builds the previous/next <nav>, dropping whichever end is missing rather
-- than emitting an empty link -- the preface has no previous, the coda no
-- next.
local function chapter_nav(chapter, kicker)
  local idx = nil
  for i, c in ipairs(CHAPTERS) do
    if c.chapter == chapter and c.kicker == kicker then
      idx = i
      break
    end
  end
  if idx == nil then return "" end

  local function link(c, dir, class)
    return string.format(
      '<a class="chapter-nav-link %s" href="%s"><span class="chapter-nav-dir">%s</span><span class="chapter-nav-dest">%s</span></a>',
      class, c.file, dir, c.name)
  end

  local links = ""
  if idx > 1 then links = links .. link(CHAPTERS[idx - 1], "Previous", "prev") end
  if idx < #CHAPTERS then links = links .. link(CHAPTERS[idx + 1], "Next", "next") end
  if links == "" then return "" end

  return string.format('<nav class="chapter-nav" aria-label="Chapter">\n  %s\n</nav>', links)
end

-- The body's own "# Class N: ..." H1 becomes the masthead's <h1>, with the
-- "Class N: " lead-in dropped (the kicker already names the class number).
-- The header block is removed from the flow so it is not shown twice.
local function take_h1(blocks)
  for i, b in ipairs(blocks) do
    if b.t == "Header" and b.level == 1 then
      local text = pandoc.utils.stringify(b.content)
      local bare = text:match("^Class%s+%d+:%s*(.*)$")
      table.remove(blocks, i)
      return bare or text
    end
  end
  return nil
end

function Pandoc(doc)
  local meta = doc.meta

  -- Pages with no `deck` field (the book/index.qmd landing page) get no
  -- masthead, just the site's `.wrap` measure so they share the column
  -- width and typography rules the rest of the CSS assumes -- but they
  -- still get the licence line, since a reader can land here first.
  if meta["deck"] == nil then
    local wrap = pandoc.Div(doc.blocks, pandoc.Attr("", { "wrap", "landing" }))
    table.insert(wrap.content, pandoc.RawBlock("html", '<footer>\n  ' .. LICENCE_LINE .. '\n</footer>'))
    doc.blocks = { wrap }
    return doc
  end

  local book = get(meta, "book")
  local chapter = get(meta, "chapter")
  local title = get(meta, "title")
  local deck = get(meta, "deck")
  local status_tag = get(meta, "status_tag")
  local status_note = get(meta, "status_note")
  -- `engine` is a reserved Quarto document key (it selects jupyter/knitr/etc.)
  -- and gets stripped from pandoc metadata before filters ever see it, so
  -- chapter front matter must use `engines` instead; `engine` is read too, as
  -- a fallback, in case a page still carries the old (broken) key.
  local engine = get(meta, "engines")
  if engine == "" then engine = get(meta, "engine") end
  local provenance = link_landing_page(get(meta, "provenance"))
  local caveat = link_landing_page(get(meta, "caveat"))
  local footer_note = get(meta, "footer_note")
  status_note = link_landing_page(status_note)

  local h1 = take_h1(doc.blocks) or title
  -- The "Class N: " lead-in this strips left a lower-case word behind
  -- ("...one line through a cloud of sparrows"); capitalise it as its own
  -- sentence now that it opens the masthead on its own.
  h1 = h1:sub(1, 1):upper() .. h1:sub(2)

  -- "sample-draft" -> "Sample draft"; any other `status` value gets the same
  -- dash-to-space, first-letter-capitalised treatment rather than a hardcoded
  -- string, so the kicker stays correct for chapters at other stages.
  local status = get(meta, "status"):gsub("%-", " ")
  if status ~= "" then
    status = status:sub(1, 1):upper() .. status:sub(2)
  else
    status = "Draft"
  end

  -- The kicker's middle segment is generated from `chapter`: "Class 3", and for
  -- a lettered appendix "Appendix A" rather than "Class A". Pages that are not
  -- rungs (the preface, the coda) name that segment themselves with a `kicker`
  -- field, used verbatim. Without the field the generated string is unchanged,
  -- so every existing chapter's markup is byte-identical.
  local kicker_raw = get(meta, "kicker")
  local rung = kicker_raw
  if rung == "" then
    local label = tostring(chapter):match("^%d+$") and "Class" or "Appendix"
    rung = label .. " " .. chapter
  end
  local masthead = string.format([[
<header class="mast">
  <div class="mast-inner">
    <p class="kicker">
      <span><a href="%s">%s</a></span><span class="sep">/</span>
      <span>%s</span><span class="sep">/</span>
      <span>%s</span>
    </p>
    <h1>%s</h1>
    <p class="deck">%s</p>
    <div class="status">
      <span class="tag">%s</span>
      <p>%s</p>
    </div>
    <p class="meta">
      <b>Engines</b> %s<br>
      <b>Provenance</b> %s<br>
      <b>Caveat</b> %s
    </p>
  </div>
</header>
]], LANDING_HREF, book, rung, status, h1, deck, status_tag, status_note, engine, provenance, caveat)

  local footer = string.format('<footer>\n  %s<br>\n  %s\n</footer>', footer_note, LICENCE_LINE)
  local nav = chapter_nav(chapter, kicker_raw)

  local wrap = pandoc.Div(doc.blocks, pandoc.Attr("", { "wrap" }))
  if nav ~= "" then
    table.insert(wrap.content, pandoc.RawBlock("html", nav))
  end
  table.insert(wrap.content, pandoc.RawBlock("html", footer))

  doc.blocks = {
    pandoc.RawBlock("html", masthead),
    wrap,
  }
  return doc
end
