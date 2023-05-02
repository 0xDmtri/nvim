-- see if the file exists
local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file
local function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

-- test if it reads
local file = 'remappings.txt'
local my_lines = lines_from(file)

-- print all lines numbers and their contetns
local function lalka(lines)
  local tab = {}

  for _, str in pairs(lines) do
    local separated = {}

    for v in str:gmatch "[^%=]+" do
      table.insert(separated, v)
    end

    -- TODO: check if separated is len 2
    tab[separated[1]] = separated[2]
  end
  return tab
end


local my_tab = lalka(my_lines)

-- Loop by pairs
for key, value in pairs(my_tab) do
  print("key ->" .. key .. " " .. "value ->" .. tostring(value))
end
