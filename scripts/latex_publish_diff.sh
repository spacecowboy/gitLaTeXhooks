#!/bin/sh

# TODO
# Replace these with values in git-config
#REPO=/home/jonas/temp/bsi_lars_remote
REPO=$(pwd)
# Where to put output folder (see OUT_DIR)
WEBDIR=/home/gibson/jonask/public_html/git_hooks/cindex_bsi
# Corresponding URL for a web client
WEBBASE=http://home.thep.lu.se/~jonask/git_hooks/cindex_bsi
# Temporary clone directory
WORKSPACE=/home/gibson/jonask/temp/sillywalkers25763
# Without .tex
TEX_FILE_NAME=bsi

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
OLD=$2 # 00301ea2af95d
# Short: First 7 chars only
OLDS=$(echo $OLD | cut -c 1-7)
NEW=$3 # 3c8b2a4af8d
# Short version
NEWS=$(echo $NEW | cut -c 1-7)

# Create output directory.
# You can change this if you do not want
# a new folder for each update
OUT_DIR=$WEBDIR/$NOW-$OLDS-$NEWS
OUT_WEB=$WEBBASE/$NOW-$OLDS-$NEWS
# Simple output instead would be for example
# OUT_DIR=$WEBDIR

mkdir $OUT_DIR

#echo "** Building and generating files **"
echo "*** $BRANCH $OLDS -> $NEWS ***"

# Checkout a temporary clone
rm -rf $WORKSPACE
git clone $REPO $WORKSPACE -b $BRANCH
cd $WORKSPACE

unset GIT_DIR

# Compile pdf
echo "Building pdf..."
make pdf  > /dev/null
#pdflatex -interaction=batchmode $TEX_FILE_NAME.tex > /dev/null
#bibtex -terse $TEX_FILE_NAME
#pdflatex -interaction=batchmode $TEX_FILE_NAME.tex > /dev/null
#pdflatex -interaction=batchmode $TEX_FILE_NAME.tex

# Copy pdf to output directory
cp $TEX_FILE_NAME.pdf $OUT_DIR/$TEX_FILE_NAME-$NEWS.pdf

# Make a syntax highlighted diff
git diff $OLD..$NEW | pygmentize -l diff -f html -O full > $OUT_DIR/$GIT_DIFF_NAME

# Create log file
git log $OLD..$NEW > $OUT_DIR/$GIT_LOG_NAME

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
cp $LDIFF.pdf $OUT_DIR/$TEX_FILE_NAME-diff-$OLDS-$NEWS.pdf

# Finish by removing temporary clone
echo "** Removing temporary directories **"
rm -rf $WORKSPACE


# Need to print these last in this specific order
echo "$OUT_WEB/$TEX_FILE_NAME-$NEWS.pdf"
echo "$OUT_WEB/$TEX_FILE_NAME-diff-$OLDS-$NEWS.pdf"
echo "$OUT_WEB/$GIT_DIFF_NAME"
echo "$OUT_WEB/$GIT_LOG_NAME"
