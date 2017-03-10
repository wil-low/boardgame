#ITC Cheltenham

#find pnp -name '*.png' -type f -exec realpath {} \; | perl -lne 'print "\"$_\""' | sort > all.txt
#grep gevt- all.txt > gevt.txt
#grep guil- all.txt > guil.txt
#grep inno- all.txt > inno.txt
#grep murd- all.txt > murd.txt
#grep plot- all.txt > plot.txt
#grep spec- all.txt > spec.txt
#grep tw- all.txt > tw.txt

#montage @gevt.txt -tile 3x3 -geometry +0+0 output/gevt.png
#montage @guil.txt -tile 3x3 -geometry +0+0 output/guil.png
#montage @inno.txt -tile 3x3 -geometry +0+0 output/inno.png
#montage @murd.txt -tile 3x3 -geometry +0+0 output/murd.png
#montage @plot.txt -tile 3x3 -geometry +0+0 output/plot.png
montage @tw.txt -tile 3x3 -geometry +0+0 output/tw.png

exit

puz-simple:

mogrify -crop 444x444+79+77 bits/puz-simple/*.png
montage @puz-simple.txt -tile 5x5 -geometry +0+0 bits/puz-simple.png


convert out.png null: ../border-grey.png -layers Composite -fuzz 30% -trim -gravity Center -extent '673x1033' +repage null: ../frame-b.png -layers Composite 1.png

