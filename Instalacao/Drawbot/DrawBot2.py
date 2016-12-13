from random import randint 
from fontTools.agl import UV2AGL

f = CurrentFont()

# Setup inicial
filePath = u"/Users/familiavieira/Dropbox/Anhembi/8º Semestre/TCC/Peças/Digitais/Instalação/Drawbot/Títulos_Apresentação.txt"
txtFile = open(filePath, mode='r')

# Funções
def geradorFrase (txt, s):
    entreLinha = -60
    larguraLinha = 0
    linha = 0
    for char in txt:
        if char == "*":
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

nome = 0
for txtLine in txtFile.readlines():
    newPage (1920, 1080)
    translate(30, 460)
    stroke(1, 0, 0)
    strokeWidth(30)
    fill(None)
    fraseUnicode = unicode(txtLine, "utf-8")
    geradorFrase(fraseUnicode, 0.04)
    saveImage([str(nome) + ".svg"])
    nome += 1