#!/bin/sh

echo "Deleting old publication"
echo worktree remove gh-pages - UB : Give fatal error in case you removed folder already

cd ../
rm -r gh-pages
git worktree prune 
git worktree add --no-checkout gh-pages gh-pages

# git worktree list
# git worktree remove gh-pages
# git worktree list
# git worktree add gh-pages 
# git worktree list
# mv gh-pages gh-pages_ori
# git worktree list
# mkdir gh-pages
# git worktree list
# cp gh-pages_ori/.git gh-pages/
# git worktree list
# find ./gh-pages -mindepth 1 -maxdepth 1 ! -name ".*" -exec rm -r {} \;
# cd ../
#git worktree remove gh-pages
#echo git worktree add gh-pages
#git worktree add gh-pages
#echo Clearning gh-pages to have clean slate
#find ./gh-pages -mindepth 1 -maxdepth 1 ! -name ".*" -exec rm -r {} \;
cd builder
#exit 0

#rm -f hugo.toml
echo "doing rm -rf publicTmp"
rm -rf publicTmp
mkdir publicTmp

echo "Generating site"
npm run build
echo "Copying to gh-pages"
echo 'beaconstreetusa.com' >> publicTmp/CNAME

cp -a publicTmp/. ../gh-pages
# cd ../gh-pages

# in case you are not able to updae gh-pages, delete the gh-pages on disk and run this command
# git worktree add -f gh-pages;

cd ../gh-pages && git add --all && git commit -m "Updated gh-pages branch on `date`"
echo "Pushing to github gh-pages branch"
git push origin gh-pages
# HUGO_ENV=production  hugo # -t "ananke"


echo "Updating builder branch"
cd ../builder && rm -rf publicTmp && git add --all && git commit -m "Updated builder branch on `date`"

git push