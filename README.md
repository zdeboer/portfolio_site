# Assignment 14 — Component Library Portfolio (Docker)

This repository contains a React portfolio site built with a component library and shipped as a **production build** inside a Docker container.

## Requirements mapping (quick)

- **Runs at** `http://127.0.0.1:5575`
- **Container name**: `deboer_zack_coding_assignment14`
- **Site files hosted in working dir**: `/deboer_zack_final_site` (inside the container)

## How to run (recommended)

From the project root:

```powershell
.\docker-restart.ps1
```

Then open:

- `http://127.0.0.1:5575`

## How to run (manual)

```powershell
# Build the image
docker build -t deboer_zack_final_site:latest .

# Remove any existing container with the required name
docker rm -f deboer_zack_coding_assignment14 2>$null

# Run the required container on port 5575
docker run -d --name deboer_zack_coding_assignment14 -p 5575:80 deboer_zack_final_site:latest
```

## Portfolio sections

The portfolio site includes these sections:

- Basic information
- Work (title, description, image, link, tech list)
- Skills (languages/frameworks, tools)
- Resources (title, image/icon, summary, link)
- Developer Setup (VS Code setup, terminal setup, preferred editor font)

## Notes

- This project uses **Vite** to generate the production build served by Apache in the container.
- The container serves the portfolio from `/deboer_zack_final_site` (symlinked to Apache’s default `/var/www/html`).
