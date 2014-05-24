rm -rf agendas/split
mkdir agendas/split
cd agendas
for f in *.md; do split -p "##" $f "split/$f"; done
