# Slack user lookup action

Lookup the Slack profile info providing the email

## Inputs

## `lookup-email`

**Required** The name of the person to greet.

## `slack-token`

**Required** The Slack token to access the API.

## `slack-endpoint`

**Required** The Slack endpoint to access the API.

## Outputs

## `slack-profile-info`

The profile information as JSON object.

## Example usage

```
uses: actions/slack-user-lookup-action
with:
  lookup-email: ...
  slack-token: ...
```
