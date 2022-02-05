::build project
hugo -t hugo-notepadium

::add & commit public
cd public
git add *
git commit -m "%date% %time%"
git push origin master

::add & commit source
cd ..
git add content/*
git commit -m "%date% %time%"
git push origin master
