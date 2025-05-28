# create `bin/` directory

Create a `./bin/` directory for self-contained Python executables (via `uv`). We will want:

- `./bin/check.py`: check and format all dotfiles
- `./bin/sync.py`: sync dotfiles
    - attempt bi-directional
    - detect diffs and user typer.prompt if interactive
- `setup` executable in root that runs `./bin/sync.py` at startup automatically (e.g. in Codespaces)

