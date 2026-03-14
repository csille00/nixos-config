# Tailscale ACL Policy

## Access matrix

| Group            | Immich (photos, :443) | Audiobookshelf (:8000) | SSH |
|------------------|-----------------------|------------------------|-----|
| immediate-family | yes                   | yes                    | yes |
| extended-family  | yes                   | yes                    | no  |
| friends          | no                    | yes                    | no  |
| admin            | yes                   | yes                    | yes |

## Applying the policy

Changes to `policy.hujson` are automatically applied via GitHub Actions (`gitops-acl-action`):

- **Pull requests** — validates the policy without applying it
- **Merge to main** — applies the policy to your tailnet

### GitHub secrets required

Set these in your repo's **Settings → Secrets and variables → Actions**:

| Secret | Value |
|--------|-------|
| `TS_API_KEY` | An API key from https://login.tailscale.com/admin/settings/keys |
| `TS_TAILNET` | Your tailnet name (e.g. `yourname.github` or `example.com`) |

To find your tailnet name, check the top of the [admin console](https://login.tailscale.com/admin).

## Adding users

Edit the `groups` section in `acl.hujson` and add the user's Tailscale login email:

```json
"groups": {
  "group:immediate-family": [
    "alice@example.com"
  ],
  "group:friends": [
    "bob@example.com"
  ]
}
```

## Tagging the server

In the [Machines tab](https://login.tailscale.com/admin/machines), click the `...` menu on `ellis-server` and assign the tag `tag:server`.

## Inviting users

Share a pre-auth key or invite users via the [Users tab](https://login.tailscale.com/admin/users). When they join, assign them a tag (`tag:immediate-family`, etc.) from the Machines tab, **or** add their email to the appropriate group in this file.

> Note: Tags and groups are different mechanisms. This policy uses **groups** (email-based, managed here) for users and **tags** (device-based, set in admin console) for the server. You only need to tag the server device with `tag:server`.
