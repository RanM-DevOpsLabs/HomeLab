```python
markdown_content = """# n8n Disaster Recovery: Import Workflows & Credentials

This guide explains how to restore an n8n instance from exported JSON files (`workflows_backup.json` and `credentials_backup.json`) onto a completely clean Docker installation.

## ⚠️ CRITICAL PREREQUISITE: The Encryption Key
n8n encrypts all exported credentials using the `N8N_ENCRYPTION_KEY`. **You cannot restore credentials without the exact key that was used when the backup was created.** Before starting, ensure your `.env` file contains the original encryption key:

```

```text
File generated successfully.

```dotenv
N8N_ENCRYPTION_KEY=your_original_secret_key_here

```

*(If you are using SOPS, ensure the `.env` file is decrypted locally before spinning up the container).*

---

## Step-by-Step Restoration Guide

### Step 1: Spin up the Clean Container

Ensure your fresh n8n container is running and has successfully loaded the `.env` file.

```bash
docker compose up -d

```

### Step 2: Move the Backup Files into the Volume

n8n needs access to the JSON files. Move your `workflows_backup.json` and `credentials_backup.json` into the folder that is mapped to your n8n Docker volume.

For example, if your `docker-compose.yml` has this volume mapping:
`- ./data:/home/node/.n8n`
You should place the JSON files directly inside that `./data` folder on your host machine.

### Step 3: Import the Credentials

Run the following command from your host machine's terminal. This tells the running container to execute the import command.

```bash
docker exec -it n8n n8n import:credentials --input=/home/node/.n8n/credentials_backup.json

```

*Note: If your container is named something else (e.g., `n8n-server`), replace the first `n8n` with your container name.*

### Step 4: Import the Workflows

Once credentials are in, import the workflows so they can link up properly.

```bash
docker exec -it n8n n8n import:workflow --input=/home/node/.n8n/workflows_backup.json

```

### Step 5: Verify the Restore

1. Log into your n8n web interface.
2. Go to **Credentials** and verify they are listed. (Try opening one to ensure it decrypts successfully without throwing an error).
3. Go to **Workflows** and verify your automations are present.
4. **Important:** Imported workflows are usually disabled by default. You will need to manually toggle them back to **Active**.

---

## Troubleshooting

* **Error: "Decryption failed"**: The `N8N_ENCRYPTION_KEY` in your `.env` does not match the one used when the backup was generated. Update the `.env`, restart the container (`docker compose restart n8n`), and try again.
* **Error: "File not found"**: The container cannot see your JSON files. Ensure they are placed exactly in the directory mapped to `/home/node/.n8n`.
"""
