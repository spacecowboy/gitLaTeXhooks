#!/bin/bash

# TODO
# Replace these with values in git-config
#REPO=/home/jonas/temp/bsi_lars_remote
REPO=$(pwd)
# Where to put output folder (see OUTDIR)
#OUTBASE=/home/gibson/jonask/public_html/git_hooks/cindex_bsi
# Corresponding URL for a web client
#URLBASE=http://home.thep.lu.se/~jonask/git_hooks/cindex_bsi
# Temporary clone directory
#TEMPDIR=/home/gibson/jonask/temp/sillywalkers25763
# Without .tex
#TEX_FILE_NAME=bsi

# These should not be necessary to change
GIT_DIFF_NAME=git_diff.html
GIT_LOG_NAME=git_log.txt
# Latex diff filename
LDIFF=ldiff # Only temporary file

NOW=$(date +"%Y-%m-%d-%H%M")

# Given by git or you, examples listed
BRANCH=$1 # /refs/heads/master
# Remove /refs/heads/
BRANCH=$(echo $BRANCH | sed 's/.*\///')

# 00301ea2af95d
# Short: First 7 chars only
OLD=$(echo $2 | cut -c 1-7)

# 3c8b2a4af8d
# Short version
NEW=$(echo $3 | cut -c 1-7)

# Create output directory.
# You can change this if you do not want
# a new folder for each update
if [[ -z "$OUTDIR" ]]
then
    OUTDIR=$OUTBASE/$NOW-$OLD-$NEW
fi

mkdir $OUTDIR

if [[ -z "$URL" ]]
then
    URL=$URLBASE/$NOW-$OLD-$NEW
fi

if [[ -z "$TEMPDIR" ]]
then
    echo "Need a tempdir!"
    exit 1
fi

#echo "** Building and generating files **"
echo "*** $BRANCH $OLD -> $NEW ***"

# Checkout a temporary clone
TEMPDIR="$TEMPDIR/sillytempgithook252"
rm -rf $TEMPDIR
git clone $REPO $TEMPDIR -b $BRANCH
cd $TEMPDIR

unset GIT_DIR

# Compile pdf
echo "Building pdf..."
make pdf  > /dev/null
#pdflatex -interaction=batchmode $TEX_FILE_NAME.tex > /dev/null
#bibtex -terse $TEX_FILE_NAME
#pdflatex -interaction=batchmode $TEX_FILE_NAME.tex > /dev/null
#pdflatex -interaction=batchmode $TEX_FILE_NAME.tex

# Copy pdf to output directory
cp $TEX_FILE_NAME.pdf $OUTDIR/$TEX_FILE_NAME-$NEW.pdf

# Make a syntax highlighted diff
git diff $OLD..$NEW | pygmentize -l diff -f html -O full > $OUTDIR/$GIT_DIFF_NAME

# Create log file
git log $OLD..$NEW > $OUTDIR/$GIT_LOG_NAME

# Create latexdiff
echo "Building diff pdf..."
git show $OLD:$TEX_FILE_NAME.tex > .old_ldiff.tex
git show $NEW:$TEX_FILE_NAME.tex > .new_ldiff.tex
latexdiff .old_ldiff.tex .new_ldiff.tex > $LDIFF.tex

# Build latexdiff
pdflatex -interaction=batchmode $LDIFF.tex > /dev/null
bibtex -terse $LDIFF
pdflatex -interaction=batchmode $LDIFF.tex > /dev/null
pdflatex -interaction=batchmode $LDIFF.tex

# Copy latexdiff
cp $LDIFF.pdf $OUTDIR/$TEX_FILE_NAME-diff-$OLD-$NEW.pdf

# Finish by removing temporary clone
echo "** Removing temporary directories **"
#rm -rf $TEMPDIR


# Need to print these last in this specific order
echo "$URL/$TEX_FILE_NAME-$NEW.pdf"
echo "$URL/$TEX_FILE_NAME-diff-$OLD-$NEW.pdf"
echo "$URL/$GIT_DIFF_NAME"
echo "$URL/$GIT_LOG_NAME"
