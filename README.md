# Git Latex Hooks
... TO DO ...

## Hooks

Some of these do the same thing, but with slight differences. They
depend on the scripts mentioned later.

### post-xxx-mail-attachments

Based on [git-multimail](https://github.com/mhagger/git-multimail/),
this hook will generate and send e-mail reports when new things have
been pushed to the repository. The notable difference from the default
behaviour is that a mail can be generated with the final pdf attached.

Good if you're colaborating with individuals who do not believe in
version control or something...

... explain option for attachment ...

### post-xxx-mail-links

Based on
[latex-hook.sh](https://gist.github.com/alexnederlof/5015614#file-latex-hook-sh),
this hook clones the repo and builds the pdf. It also generates a diff
and a log file. These are then copied to a directory which is expected
to be public on some webserver. The e-mail report then contains links
to these files.

Good if you don't want to spam people's mailboxes with several
megabytes of pdf every other day.

### update

This script runs before any of the post-receive hooks, and it runs
once per branch. It builds and generates the diff used in other
hooks.

## Dependencies

These scripts do the actual work for the hooks above.

### mail_attach.py

Sends reports with attached files.

### mail_links.py

Send reports with links to final versions.
