git add content/*
git commit -m "%date% %time%"
hugo -t hugo-notepadium
cd public
git add *
git commit -m "%date% %time%"
