-- stats_hours.lua -- house filter for "Stats Hours with Itchy".
-- Translates the plain-markdown dialogue conventions (docs/writing-conventions.md)
-- into the HTML classes docs/index.html was hand-coded against:
--   **Name:** text          -> <div class="line"><span class="who name">Name</span><p>text</p></div>
--   **Bold-only paragraph**  -> <p class="scene">text</p>
--   *(aside text)*           -> <p class="aside">text</p>
--   > **⚠ DISAGREE ...**     -> <div class="disagree">...</div>
--   > **... μ ...**          -> <p class="board">...</p>

-- Cast list the dialogue markup recognises. Lower-cased for the CSS class
-- (docs/index.html uses .who.toto, .who.momo, etc.).
local CAST = {
  Itchy = true, Toto = true, Momo = true, Eddie = true, Jaro = true,
}

-- Render a list of inlines to an HTML string (via pandoc's own writer, so
-- nested emphasis/code/strong/etc. all come out correctly).
local function inlines_to_html(inlines)
  return pandoc.write(pandoc.Pandoc({ pandoc.Plain(inlines) }), "html")
end

-- True if `inlines` is exactly one Emph node, e.g. the Para *(writes on the board)*
-- (the parens live inside the Emph, so this is just "one Emph, nothing else").
local function is_single_emph(inlines)
  if #inlines == 1 and inlines[1].t == "Emph" then
    return true, inlines[1].content
  end
  return false, nil
end

-- True if `inlines` is entirely one Strong node (the bold-only scene para).
local function is_all_strong(inlines)
  if #inlines == 1 and inlines[1].t == "Strong" then
    return true, inlines[1].content
  end
  return false, nil
end

-- If Para starts "**Name:**", return Name and the remaining inlines.
local function speaker_prefix(inlines)
  if #inlines >= 1 and inlines[1].t == "Strong" then
    local strong_text = pandoc.utils.stringify(inlines[1].content)
    local name = strong_text:match("^(%a+):$")
    if name and CAST[name] then
      local rest = {}
      for k = 2, #inlines do table.insert(rest, inlines[k]) end
      -- Drop a single leading space left after the bold "Name:".
      if rest[1] and rest[1].t == "Space" then table.remove(rest, 1) end
      return name, rest
    end
  end
  return nil, nil
end

function Para(el)
  local name, rest = speaker_prefix(el.content)
  if name then
    local who_class = "who " .. name:lower()
    -- A speaker line whose entire body is an aside, e.g. "**Itchy:** *(writes
    -- on the board)*", gets the aside as its own <p class="aside">, not an
    -- <em> re-wrapped inside a plain <p> (see gap (a), leaf-s2b).
    local aside_only, aside_inlines = is_single_emph(rest)
    local body, p_attr
    if aside_only then
      body = inlines_to_html(aside_inlines)
      p_attr = ' class="aside"'
    else
      body = inlines_to_html(rest)
      p_attr = ""
    end
    local html = string.format(
      '<div class="line"><span class="%s">%s</span><p%s>%s</p></div>',
      who_class, name, p_attr, body)
    return pandoc.RawBlock("html", html)
  end

  local scene_ok, scene_inlines = is_all_strong(el.content)
  if scene_ok then
    local html = string.format('<p class="scene">%s</p>', inlines_to_html(scene_inlines))
    return pandoc.RawBlock("html", html)
  end

  local aside_ok, aside_inlines = is_single_emph(el.content)
  if aside_ok then
    local html = string.format('<p class="aside">%s</p>', inlines_to_html(aside_inlines))
    return pandoc.RawBlock("html", html)
  end

  return el
end

-- NB: BlockQuote must run as its OWN pass, before Para. Pandoc's default
-- single-pass filter walks bottom-up (children before parents), so a
-- bold-only board/disagree line inside a BlockQuote would otherwise already
-- have been rewritten by Para() into <p class="scene"> before BlockQuote()
-- ever got to look at it. See the `return` at the bottom of this file.
function BlockQuote(el)
  -- Find the first Strong text inside the blockquote (its opening line).
  local first_strong_text = nil
  if el.content[1] and el.content[1].t == "Para" then
    for _, inl in ipairs(el.content[1].content) do
      if inl.t == "Strong" then
        first_strong_text = pandoc.utils.stringify(inl.content)
        break
      end
    end
  end
  if not first_strong_text then return el end

  if first_strong_text:match("^⚠ DISAGREE") then
    local inner = pandoc.write(pandoc.Pandoc(el.content), "html")
    local html = string.format('<div class="disagree">\n%s\n</div>', inner)
    return pandoc.RawBlock("html", html)
  end

  if first_strong_text:find("μ") then
    local body = inlines_to_html(el.content[1].content)
    local html = string.format('<p class="board">%s</p>', body)
    return pandoc.RawBlock("html", html)
  end

  return el
end


-- A deliberate error is teaching material; its stack trace is not. Keep the message, drop the frames.
-- Warnings likewise lose their "@ Module .../file.jl:NN" source lines. The reader sees what went wrong,
-- never where in the engine's source it went wrong.
local function trim_error_output(div)
  local cls = div.classes
  local is_err = cls:includes("cell-output-error")
  local is_stderr = cls:includes("cell-output-stderr")
  if not (is_err or is_stderr) then return nil end
  return div:walk({
    RawBlock = function(rb)
      local t = rb.text
      if is_err then
        t = t:gsub("Stacktrace:.-(</pre>)", "(stack trace omitted)%1")
        t = t:gsub("Stacktrace:.-(</code>)", "(stack trace omitted)%1")
        -- MethodError "Closest candidates" lines carry engine source locations too; the output is
        -- ANSI-coloured HTML, so match the location by its ".jl:NN" tail, whatever tags sit around it
        t = t:gsub("[^\n]*%.jl:%d+[^\n]*\n?", "")
      else
        t = t:gsub("[^\n]*%.jl:%d+[^\n]*\n?", "")
      end
      rb.text = t
      return rb
    end,
    CodeBlock = function(cb)
      local out = {}
      for line in (cb.text .. "\n"):gmatch("(.-)\n") do
        if is_err and (line:match("^%s*@ ") or line:match("%.jl:%d+")) then
          -- source-location line inside an error message: drop it
        elseif is_err and line:match("^%s*Stacktrace:") then
          while #out > 0 and out[#out]:match("^%s*$") do table.remove(out) end
          table.insert(out, "(stack trace omitted)")
          break
        end
        if is_stderr and (line:match("^%s*@ ") or line:match("%.jl:%d+")) then
          -- drop the source-location line
        else
          table.insert(out, line)
        end
      end
      cb.text = table.concat(out, "\n")
      return cb
    end
  })
end

return {
  { Div = trim_error_output },
  { BlockQuote = BlockQuote },
  { Para = Para },
}
