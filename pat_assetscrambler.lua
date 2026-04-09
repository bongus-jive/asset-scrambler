local assets_add, assets_image, assets_bytes = assets.add, assets.image, assets.bytes
local fmt, find, rand = string.format, string.find, math.random

math.randomseed(os.time())
local function scramble(t)
  for i = #t, 2, -1 do
    local r = rand(i)
    t[i], t[r] = t[r], t[i]
  end
end

local files = assets.byExtension("png")

do
  local j, n = 1, #files
  for i = 1, n do
    local file = files[i]
    if not (find(file, "^/dungeons/") or find(file, "^/ships/.+blocks%.png$")) then
      files[j] = file
      j = j + 1
    end
  end
  for i = j, n do files[i] = nil end
end

scramble(files)

local lastImage = assets_image(files[#files])
local lastSize = lastImage:size()

for i = 1, #files do
  local file = files[i]
  local image = assets_image(file)
  local size = image:size()

  local scale = fmt("?scalenearest=%s;%s", size[1] / lastSize[1], size[2] / lastSize[2])

  assets_add(file, lastImage:process(scale))

  lastImage, lastSize = image, size
end


files = assets.byExtension("ogg")
scramble(files)
local lastBytes = assets_bytes(files[#files])

for i = 1, #files do
  local file = files[i]
  local bytes = assets_bytes(file)
  assets_add(file, lastBytes)
  lastBytes = bytes
end
