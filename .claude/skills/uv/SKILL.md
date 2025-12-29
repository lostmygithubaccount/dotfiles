---
name: uv
description: Build self-contained Python executables using uv script metadata.
---

# uv scripts

Create standalone Python scripts with inline dependency management using [PEP 723](https://peps.python.org/pep-0723/) script metadata.

## Bootstrap template

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "typer",
#     "rich",
# ]
# ///
"""Script description."""

def main() -> None:
    pass

if __name__ == "__main__":
    main()
```

## Make executable

```bash
chmod +x bin/my-script.py
```

## Run

```bash
./bin/my-script.py
# or
uv run --script bin/my-script.py
```

## Script metadata format

The `# /// script` block declares dependencies inline:

```python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "requests>=2.28",
#     "pydantic",
# ]
# ///
```

## Local package dependencies

Reference local packages with `[tool.uv.sources]`:

```python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "my-local-package",
#     "rich",
# ]
#
# [tool.uv.sources]
# my-local-package = { path = "..", editable = true }
# ///
```

## Add dependencies

Use `uv add --script` to add dependencies to an existing script:

```bash
uv add --script bin/my-script.py httpx rich
```

## Common dependencies

- CLI: `typer`, `click`
- Output: `rich`
- HTTP: `httpx`, `requests`
- Data: `pydantic`, `polars`, `pandas`
- YAML: `pyyaml`, `ruamel.yaml`

## Resources

- uv scripts: https://docs.astral.sh/uv/guides/scripts/
- PEP 723: https://peps.python.org/pep-0723/
