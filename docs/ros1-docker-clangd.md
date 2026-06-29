# ROS 1 + Docker + clangd LSP

Per-project setup. Two files go in each catkin workspace root inside the container.

## Prerequisites

- Container is running before opening Neovim
- Workspace has been built: `catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
- `exrc = true` is set in `lua/core/options.lua` (already done)
- clangd is installed inside the container

## File 1: `.nvim.lua` (workspace root, gitignore this)

Edit the three variables for your project.

```lua
local container  = 'my_ros_container'       -- docker container name
local host_path  = '/home/user/catkin_ws'   -- path on your Computer
local guest_path = '/home/ros/catkin_ws'    -- path inside container

vim.lsp.config('clangd', {
  cmd = {
    'docker', 'exec', '-i', container,
    'clangd',
    '--background-index',
    '--path-mappings=' .. host_path .. '=' .. guest_path,
    '--compile-commands-dir=' .. guest_path .. '/build',
    '--completion-style=bundled',
    '--header-insertion=iwyu',
  },
  capabilities = { offsetEncoding = 'utf-8' },
  filetypes = { 'c', 'cpp' },
})
vim.lsp.enable('clangd')
```

## File 2: `.clangd` (workspace root, can commit this)

Points clangd at the generated message headers in `devel/include/`.

```yaml
CompileFlags:
  Add:
    - -I/home/ros/catkin_ws/devel/include
```

Use the **container-side** path here, not the host path.

## Gitignore

Add `.nvim.lua` to `~/.gitignore_global` (container name is machine-specific):

```
.nvim.lua
```

## Workflow

1. Start container
2. `catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` inside container
3. Open Neovim from workspace root on host — exrc sources `.nvim.lua` automatically
4. Open any `.cpp` file — clangd starts inside the container, custom messages resolve

## Troubleshooting

**clangd not starting** — check `:LspInfo`. Container must be running and `docker exec` must work.

**Custom messages not resolving** — confirm `devel/include/your_msgs/` exists (workspace must be built first).

**Wrong paths** — run `:LspLog` to see the exact command clangd was started with.
