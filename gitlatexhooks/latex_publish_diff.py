#!/usr/bin/env python
# Must be python 2 due to git-multimail
"""\
Read the variables from the git-config
before calling the shell script.
"""

import sys, os, subprocess
import git_multimail

# Section in gitconfig to use
_CONFIGSECTION = "gitlatexhook"

_MISSING_VAR_ERROR = """\
Could not find "{{var}}" in git-config.
Please set {section}.{{var}} in your git-config.
""".format(section=_CONFIGSECTION)

def _getdir():
    """Return the location of the file calling this.
    Should be present in latexhooks root"""
    path, f = os.path.split(os.path.realpath(__file__))
    print("debug", path)
    return path

def getenv(**kwargs):
    """Returns an environment where the variables
    from the git config section 'gitlatexhooks' are
    set as environment variables.

    Any keyword arguments specified are also set."""

    config = git_multimail.Config(_CONFIGSECTION)
    # Use this environment to call command with
    env = os.environ.copy()

    # Read vars, put in env
    if config.get('tempdir') is None:
        raise ValueError(_MISSING_VAR_ERROR.format(var='tempdir'))
    elif config.get('texfilename') is None:
        raise ValueError(_MISSING_VAR_ERROR.format(var='texfilename'))
    elif config.get('outbase') is None:
        raise ValueError(_MISSING_VAR_ERROR.format(var='outbase'))
    elif config.get('urlbase') is None:
        raise ValueError(_MISSING_VAR_ERROR.format(var='urlbase'))

    env['TEMPDIR'] = config.get('tempdir').encode('UTF-8')
    env['TEX_FILE_NAME'] = config.get('texfilename').encode('UTF-8')

    # Dirs and Urls
    env['OUTBASE'] = config.get('outbase').encode('UTF-8')
    env['URLBASE'] = config.get('urlbase').encode('UTF-8')

    # Optional
    for var in [b'OUTDIR', b'URL']:
        if config.get(var, default=None) is not None:
            env[var] = config.get(var).encode('UTF-8')

    # Optional variables
    for k, v in kwargs.items():
        env[k] = v.encode('UTF-8')

    return env

def run(script, *args):
    """Run a given script in an environment where
    the variables from git config under 'gitlatexhooks'
    are present as environment variables.

    Example:
    run("scripts/latex_publish_diff.sh",
        argv[1], argv[2], argv[3])
    """

    env = getenv()
    print(script)
    print(args)
    return subprocess.check_output([script] + list(args),
                                   env=env)


def publish_pdf(branch, oldref, newref):
    # Current directory
    path = _getdir()
    script = os.path.join(path, "latex_publish_diff.sh")

    # Run shell script
    results = run(script, branch, oldref, newref)
    results = results.strip().split('\n')

    # The links are last
    pdf = results[-4]
    pdfdiff = results[-3]
    gitdiff = results[-2]
    gitlog = results[-1]

    return (pdf, pdfdiff, gitdiff, gitlog)
