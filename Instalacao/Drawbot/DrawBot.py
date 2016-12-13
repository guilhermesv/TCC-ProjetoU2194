from random import randint 
from fontTools.agl import UV2AGL

f = CurrentFont()
s = 0.03

size(1024, 768)
translate(30, 680)
stroke(1, 0, 0)
strokeWidth(30)
fill(None)


# txt = 'uma frase \ncom 3 \nlinhas'
txt = u'Esta é uma \nfrase de \ntrês linhas \n?!'
txt2 = u"the design is final visual form maybe \n       as  much to do with working against \n rules and logic as with working with them"

entreLinha = -50
larguraLinha = 0
linha = 0

for char in txt2:
    if char == "\n":
        translate(-larguraLinha, entreLinha)
        larguraLinha = 0;
    else:
        uni = ord(char)
        glyphName = UV2AGL.get(uni)
        if glyphName:
            save()
            scale(s)
            drawGlyph(f[glyphName])
            w = f[glyphName].width * s
            larguraLinha += w
            restore()
            translate(w, 0)
saveImage(["firstImage.svg"])
