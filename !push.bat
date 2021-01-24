@echo off
echo Enter a description of this push(Optional):
set /p d=
git add -A
git commit -m "Des:%d%"
git push||git push||git push
echo Upgrade Res...
cd ..\res
git add -A
git commit -m "Des:%d%"
git push||git push||git push
echo Upgrade hexo-theme-matery...
cd ..\HEXO\themes\hexo-theme-matery
git add -A
git commit -m "Des:%d%"
git push||git push||git push