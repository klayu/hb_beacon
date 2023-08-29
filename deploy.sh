#!/bin/sh

echo "Deleting old publication"
# Replace "filename.txt" with the actual name of your file
gh_repository=$(cat reponame.txt)

# Now the variable "file_contents" holds the content of the file


echo "Hint : sudo nano ~/.bashrc and export gh_token= and export gh_token=gh_username should already have been done"
echo GitHub User : $gh_username
echo GitHub Pass : $gh_token
echo GitHub Repo : $gh_repository
git config --global push.autoSetupRemote true
git remote remove origin
git remote add origin https://$gh_username:$gh_token@github.com/klayu/$gh_repository.git
git remote -v

# cd ../gh-pages
# git checkout --orphan empty_commit_branch
# git rm -rf .
# git commit --allow-empty -m "Empty commit"
# git push origin empty_commit_branch:gh-pages
# git push -f origin empty_commit_branch:gh-pages
# cd ..
# git worktree remove /path/to/worktree-dir
# git branch -D empty_commit_branch
# git worktree remove gh-pages
# git worktree add gh-pages

# find ../gh-pages -mindepth 1 -maxdepth 1 ! -name ".*" -exec rm -r {} \;
rm -f hugo.toml
rm -rf publicTmp
mkdir publicTmp

echo "Generating site"
npm run build
# HUGO_ENV=production  hugo # -t "ananke"
# echo 'www.monsty.co' >> publicTmp/CNAME


echo "Emptying gh-pages"
# git branch -D gh-pages
# git push origin --delete gh-pages
git push origin --delete --force gh-pages

cd ..
git worktree remove -f gh-pages
git worktree add gh-pages
find ./gh-pages -mindepth 1 -maxdepth 1 ! -name ".*" -exec rm -r {} \;


echo "Copying to gh-pages"
cd builder
cp -a publicTmp/. ../gh-pages
# cd ../gh-pages
cd ../gh-pages && git add --all && git commit -m "gh-pages branch `date`"
echo "Pushing to github gh-pages branch"
# git commit -m "gh-pages branch `date`"
# git push origin gh-pages 
git push origin HEAD:gh-pages



echo "Updating builder branch"
cd ../builder && rm -rf publicTmp && git add --all && git commit -m "Saving to builder branch"

git push

echo Use : git pull --rebase to check if others have changed before you