::build project
::hugo -t hugo-notepadium
hugo -t hugo-PaperMod

::add & commit public
cd public
git add *
git commit -m "%date% %time%"
git push origin master
cd ..

::add & commit source
git add content/*
git commit -m "%date% %time%"
git push origin master
