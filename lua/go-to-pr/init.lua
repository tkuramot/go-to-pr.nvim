local M = {}

local function get_commit_hash_at_cursor()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]

  local result = vim.system({
    "git",
    "blame",
    "-L", current_line .. "," .. current_line,
    "--porcelain",
    vim.api.nvim_buf_get_name(0)
  }, { text = true }):wait()

  if result.code ~= 0 then
    return nil
  end

  return result.stdout:match("^(%x+)")
end

local function run_gh_command(args)
  return vim.system({ "gh", unpack(args) }, { text = true }):wait()
end

local function create_pr()
  local result = run_gh_command({ "pr", "create", "--web" })

  if result.code == 0 then
    vim.notify("Opening PR creation page in browser", vim.log.levels.INFO)
  else
    vim.notify(("Failed to create PR: %s"):format(result.stderr), vim.log.levels.ERROR)
  end
end

function M.blame_pr()
  local commit_hash = get_commit_hash_at_cursor()
  if not commit_hash then
    vim.notify(
      "Failed to get commit hash for current line. Possible reasons:\n" ..
      "- Current file is not in a git repository\n" ..
      "- Current line is not committed yet\n" ..
      "- Current line contains uncommitted changes\n" ..
      "- Git command is not available in PATH",
      vim.log.levels.ERROR
    )
    return
  end

  local result = run_gh_command({ "pr", "list", "-s", "all", "-S", commit_hash, "--web" })

  if result.code == 0 then
    vim.notify("Searching PR containing commit: " .. commit_hash, vim.log.levels.INFO)
  else
    vim.notify(("Failed to search PR: %s"):format(result.stderr), vim.log.levels.ERROR)
  end
end

function M.open_pr()
  local result = run_gh_command({ "pr", "view", "--web" })

  if result.code == 0 then
    vim.notify("Opening existing PR in browser", vim.log.levels.INFO)
    return
  end

  vim.notify("No existing PR found. Creating new PR...", vim.log.levels.INFO)
  create_pr()
end

function M.setup()
end

return M
