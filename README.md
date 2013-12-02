# git LaTeX Hooks
Some convenient git hooks for LaTeX projects.

## Quick start [update hook]

Clone the projet somewhere, and then
link the update hook:

```bash
ln -s /path/to/gitLaTeXhooks/update /path/to/myproject/.git/hooks/update
```

Then set the following in your _git-config_:

```
[gitlatexhook]
	# Folder where a temporary clone will be made
	tempdir = /path/to/tempdir
	# Name of your tex-file, minus .tex
	texfilename = report
	# Will place the pdfs somewhere in this dir
	outbase = /www/gitlatexhook/ninja-report
	# Base for all URLs corresponding to folder outbase
	urlbase = http://work.com/gitlatexhook/ninja-report
[multimailhook]
	mailinglist = you@work.com, boss@work.com
```

## Hooks

Just one for now. See it as an example to build your own hooks.

### update

Intended for a repo that is considered the master repo, which users do
_git push_ to update.

Based on [git-multimail](https://github.com/mhagger/git-multimail/),
this hook will generate and send e-mail reports when new things have
been pushed to the repository.

The important difference is that it also calls *latex_publish_diff.sh*
below, which builds the pdf and pdf diff. Links to these files are
then included in the report mail.

## Scripts

These scripts do the actual work for the hooks above.

### latex_publish_diff.sh

Based on
[latex-hook.sh](https://gist.github.com/alexnederlof/5015614#file-latex-hook-sh),
this hook clones the repo and builds the pdf. It also generates a diff
and a log file. These are then copied to a directory which is expected
to be public on some webserver.

The paths are printed last in the script in this specific order:

1. pdf url
2. pdf diff url
3. git diff url
4. git log url

### latex_publish_diff.py

Convenient wrapper of the shell version. This takes care of reading
the variables from your _git-config_.
