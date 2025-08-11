# Integrations: NADOO-IT and NADOO-Launchpad

This project can use the NADOOIT backend/services and the Launchpad development toolkit.

- NADOO-IT (backend + services + bots): https://github.com/NADOOIT/NADOO-IT
- NADOO-Launchpad (dev toolkit + code generation + functions/classes): https://github.com/NADOOIT/NADOO-Launchpad

## Recommended folder layout
We suggest keeping external dependencies in an `external/` directory at the repo root:

```
repo_root/
  external/
    NADOO-IT/
    NADOO-Launchpad/
```

## Clone or add as submodules

Option A — clone directly:
```bash
mkdir -p external
git clone https://github.com/NADOOIT/NADOO-IT.git external/NADOO-IT
git clone https://github.com/NADOOIT/NADOO-Launchpad.git external/NADOO-Launchpad
```

Option B — use Git submodules (recommended for deployments):
```bash
git submodule add https://github.com/NADOOIT/NADOO-IT.git external/NADOO-IT
git submodule add https://github.com/NADOOIT/NADOO-Launchpad.git external/NADOO-Launchpad
```

Update submodules later:
```bash
git submodule update --init --recursive
```

## External repos setup (simple)
Default to stable `main` branches for both:

```bash
# Bootstrap
make external

# Inspect
make external:status
```

Branch switching (optional):

```bash
# Use specific branches (overrides default main for this run)
LP_BRANCH=feature-x IT_BRANCH=dev make external
```

Work on Launchpad separately? Point this repo at your dev clone:

```bash
LP_DEV_PATH=/abs/path/to/NADOO-Launchpad make external
```

Lock exact SHAs for collaborators (optional):

```bash
make external:lock
git add external/external.lock && git commit -m "lock externals"
```

Note: `external/*` is ignored in Git; `external/.gitkeep` and `external/external.lock` are tracked.

## Using NADOO-IT services
- NADOO-IT provides backend services and bots (e.g., Telegram/WhatsApp).
- Consult its README for configuration (API tokens, webhooks, or service endpoints).
- Add required environment variables to your `.env` as instructed by NADOO-IT docs.

## Using NADOO-Launchpad
- Launchpad contains a code generation tool, `functions/` and `classes/` with reusable business logic.
- Many functions are designed to be plug-and-play (e.g., local AI text generation, voice-to-text, testing helpers).
- Follow the repository instructions to add your functions and to include per-function `requirements` where applicable.

## Importing from these repos
If your code needs to import Python modules from these folders, you can add them to `PYTHONPATH` or create a thin wrapper package:

```bash
export PYTHONPATH="$(pwd)/external/NADOO-IT:$(pwd)/external/NADOO-Launchpad:$PYTHONPATH"
```

Or add an entry in your virtualenv activation script.

## Next steps
- See `docs/nadooit_webauthn.md` for account registration/sign-in with Security Keys.
- See `fido2/README.md` and `fido2/setup_linux.sh` for local FIDO2 setup.
