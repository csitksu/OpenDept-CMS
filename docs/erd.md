# Entity Relationship Diagram (ERD)

This document contains the ER diagram for the core Academic CMS entities.

To render the diagram locally as PNG or SVG, install mermaid-cli (npm i -g @mermaid-js/mermaid-cli) and run:

```bash
mmdc -i docs/erd.mmd -o docs/erd.png
mmdc -i docs/erd.mmd -o docs/erd.svg
```

Or use Docker:

```bash
# from repository root
docker run --rm -v "%cd%:/data" minlag/mermaid-cli -i docs/erd.mmd -o docs/erd.png
```

Mermaid source (docs/erd.mmd) is the single source of truth for the diagram.
