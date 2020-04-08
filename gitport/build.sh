#!/bin/sh

cd $(dirname $0)
mkdir -p out

if [ ! -d ./out/joe-editor-hg ]; then
	hg clone http://hg.code.sf.net/p/joe-editor/mercurial out/joe-editor-hg
fi

if [ ! -d ./out/dummy ]; then
	# hg-fast-export needs to be in an empty git repo or it fails.
	mkdir -p out/dummy
	cd out/dummy
	git init . --bare
	cd ../..
fi

if [ ! -d ./env ]; then
	python3 -m venv env
	pip install -r requirements.txt
fi

env/bin/python mkhistory.py ./oldmeta.yaml .. out/historic.txt || exit $?
python2 tools/cvs2svn/cvs2git --blobfile=out/cvs-blobs.txt --dumpfile=out/cvs-cmds.txt ../collection/cvs/joe-current || exit $?
rm -f out/hg-mapping.txt out/hg-heads.txt out/hg-status.txt out/hg-marks.txt out/hg-exp.txt
cd out/dummy
# TODO:
#  - Translate names
#  - Translate tags
../../tools/hg-fast-export/hg-fast-export.py -r ../joe-editor-hg --mapping=../hg-mapping.txt --heads=../hg-heads.txt --status=../hg-status.txt --marks=../hg-marks.txt >../hg-exp.txt --filter=../../crlf-filter.sh || exit $?
cd ../..

env/bin/python fixcvs.py out/cvs-blobs.txt out/cvs-cmds.txt out/cvs-fixed.txt || exit $?
env/bin/python fixhg.py out/hg-exp.txt out/hg-fixed.txt || exit $?
(env/bin/python fuse.py out/historic.txt out/cvs-fixed.txt out/hg-fixed.txt out/full-export.txt | tee out/export-log.txt) || exit $?

if [ -d out/git ]; then
	rm -rf out/git
fi

mkdir -p out/git
cd out/git
git init --bare

git fast-import --export-marks=../git-marks.txt <../full-export.txt
