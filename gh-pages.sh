# This script is inspired by tschaub/grunt-gh-pages
#       (https://github.com/tschaub/grunt-gh-pages)

base=`pwd`
clone=${base}_gh-pages
branch='gh-pages'
remote=`git remote -v | awk '$1=="origin"&&$3=="(fetch)"{print $2}'`


if [ -d "$clone" ] ; then
    cd "$clone"
    git clean -f -d
    git fetch
else
    git clone "$remote" "$clone"
fi

cd "$clone"
git checkout "$branch"
git rm --ignore-unmatch -r -f .

cd "$base"
gulp publish --release --outputdir=$clone

cd "$clone"
git add .
git commit -m 'update'
#git push $remote $branch
