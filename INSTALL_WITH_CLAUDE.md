# Install Vitally MCP using Claude Desktop

The easiest way to install the Vitally MCP is to let Claude Desktop do it for you.

## Instructions

1. **Copy this entire message** and paste it into a new conversation in Claude Desktop:

---

Please help me install the Vitally MCP server for my Apple Silicon Mac. Here's what I need you to do:

1. Download the binary from: https://github.com/mattfdigio/vitally-mcp-distribution/releases/latest/download/vitally-mcp-arm64
2. Save it to `~/.local/bin/vitally-mcp`
3. Make it executable and remove quarantine: `chmod +x` and `xattr -d com.apple.quarantine`
4. Ask me for my Vitally API credentials:
   - API subdomain (e.g., medscout.rest.vitally.io)
   - API key (starts with sk_live_)
   - Data center (US or EU, default US)
5. Update my Claude Desktop config at `~/Library/Application Support/Claude/claude_desktop_config.json` to add the vitally MCP server with my credentials
6. Tell me to restart Claude Desktop to use the new MCP

Where to get my Vitally API key:
- Log in to Vitally
- Go to Settings → Integrations
- Enable "Vitally REST API"
- Copy the Secret Token

---

2. **Follow Claude's prompts** - Claude will ask you for your API credentials
3. **Restart Claude Desktop** when done (Cmd+Q, then reopen)
4. **Test it** by asking: "What Vitally tools are available?"

## Why this works

Claude Desktop can:
- Execute bash commands to download and install files
- Read and edit JSON configuration files
- Prompt you for information interactively
- Guide you through the entire process

This is much easier than running commands in Terminal manually!

## Intel Mac Users

If you have an Intel Mac, use this URL instead in step 1:
```
https://github.com/mattfdigio/vitally-mcp-distribution/releases/latest/download/vitally-mcp-x64
```
