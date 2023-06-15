::build project
::hugo -t hugo-notepadium
::hugo -t hugo-PaperMod
hugo --config config.yml

::add & commit public
cd public
git add *
git checkout -B master
git commit -m "%date% %time%"
git push origin master
cd ..

::add & commit source
git add *
git checkout -B master
git commit -m "%date% %time%"
git push origin master