# knots-pre-commit

Fast [pre-commit](https://pre-commit.com) hooks for
[knots](https://github.com/brandon-arrendondo/knots), the multi-language code
complexity analyzer.

These hooks use `language: python` and install the **prebuilt `knots` wheel from
PyPI**, so the first `pre-commit run` is seconds — no Rust toolchain and no
from-source compile. (The main knots repo also ships hooks, but those are
`language: rust`, which compiles on first use.)

## Usage

Add to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/brandon-arrendondo/knots-pre-commit
    rev: v1.11.0            # pin to a released knots version
    hooks:
      - id: knots           # default gate: AIRD ≤ 85
      # - id: knots-verbose  # same gate, per-function detail
      # - id: knots-strict   # McCabe 10, Cognitive 10, Nesting 3, SLOC 30, ABC 5.0, Returns 3
```

Then:

```bash
pre-commit install
```

Override thresholds with `args:` (pre-commit *replaces* args, so you control the
full set):

```yaml
      - id: knots
        args: [--mccabe-threshold=20, --cognitive-threshold=20]
```

## How it works

This repo is a tiny pure-Python shim: its `pyproject.toml` declares a single
dependency, `knots==<version>`. When pre-commit installs the hook it creates a
virtualenv and `pip install`s this shim, which pulls the matching prebuilt wheel
from PyPI and puts the `knots` binary on PATH. There is no source code here.

This mirrors how [`ruff-pre-commit`](https://github.com/astral-sh/ruff-pre-commit)
works.

## Releasing (maintainers)

On each knots release, point this repo at the published version and tag it to
match:

```bash
./bump.sh 1.11.0
git commit -am "knots 1.11.0"
git tag v1.11.0
git push --follow-tags
```

The `knots==X` pin must reference a version that is **already on PyPI** (published
by the main repo's `wheels.yml` workflow).
