# AWS MFA Login
> Simple tool to orchestrate your MFA login

## Introduction
When AWS MFA login is enabled you have to get a session token in order
to login into AWS over CLI. This script will log you in and store the 
credentials in your environment in order that other scripts will work
too.

## How to use
There are two flavours: bash/zsh and fish. Install either of these in your
path and run it...

### Note for fish users
Just copy the fish script into your `functions` folder.

```bash
cp *.fish ~/.config/fish/functions/
```

Afther that the commands are available as:

```fish
aws-mfa-login
aws-mfa-logout
```
