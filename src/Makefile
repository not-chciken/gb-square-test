
all: square_test.gb

%.2bpp: %.png
	rgbgfx -o $@ $<

%.1bpp: %.png
	rgbgfx -d 1 -o $@ $<

square_test.o: square_test.asm font.2bpp square_test_logo.2bpp
	rgbasm -Wunmapped-char=0 -o square_test.o square_test.asm

square_test.gb: square_test.o
	rgblink -n square_test.sym -m square_test.map -o $@ $<
	rgbfix -f gh -p 255 $@

	@if which md5sum &>/dev/null; then md5sum $@; else md5 $@; fi

clean:
	rm -f square_test.o square_test.gb square_test.sym square_test.map
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +