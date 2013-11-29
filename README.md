# git LaTeX Hooks
Some convenient git hooks for LaTeX projects.

Enable by checking out this project somewhere, and then
linking the hook script, for example the update hook:

```bash
ln -s /path/to/gitLaTeXhooks/update /path/to/myproject/.git/hooks/update
```

## Hooks

Some of these do the same thing, but with slight differences. They
depend on the scripts mentioned later.

### update

Intended for a repo that is considered the master repo, which users do
_git push_ to update.

Based on [git-multimail](https://github.com/mhagger/git-multimail/),
this hook will generate and send e-mail reports when new things have
been pushed to the repository.

The important difference is that it also calls *latex_build_publish_diff.sh*
below, which builds the pdf and pdf diff. Links to these files are
then included in the report mail.

## Scripts (Dependencies)

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
