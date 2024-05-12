print("Gitbit: loading")

local M = {}

local function find_git_remote_base()
  local handle = io.popen("git remote get-url origin")
  if handle == nil then
    return "no git remote set yet"
  end

  local result = handle:read("*a")
  handle:close()

  return result
end

local function get_remote_https_base(base)
  -- if base is https, return it
  if base:match("https://") then
    return base:match("(.*).git")
  end

  -- if base is ssh, convert it to https
  local owner = base:match("github.com:(.*)/")
  local repo = base:match("github.com:.*/(.*).git")
  local https_url = "https://github.com/" .. owner .. "/" .. repo
  return https_url
end


local function convert_git_remote_url_to_https(path)
  local remote_base = find_git_remote_base()
  print("remote_base: " .. remote_base)
  local remote_https_base = get_remote_https_base(remote_base)
  local https_url = remote_https_base .. "/tree/master/" .. path
  print("https_url: " .. https_url)

  return https_url
end

local function find_current_file_path_in_remote()
  local current_file_path = vim.fn.expand("%")
  print("current_file_path: " .. current_file_path)
  local remote_path = convert_git_remote_url_to_https(current_file_path)
  print("remote_path: " .. remote_path)
  return remote_path
end

M.git_remote_url = find_git_remote_base()
M.show_remote_path = function()
  local remote_path = find_current_file_path_in_remote()
  print(remote_path)
end

M.open_url = function()
  local remote_path = find_current_file_path_in_remote()
  vim.cmd("silent !open " .. remote_path)
end


return M
