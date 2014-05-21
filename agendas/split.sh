rm -rf split
mkdir split
for f in *.md; do split -p "##" $f "split/$f"; done