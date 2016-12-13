from robofab.pens.filterPen import flattenGlyph, thresholdGlyph
from g_outline import expand
import math
from random import randint 

#----- Variaveis importação

external_source = "U+2194_Matriz.ufo"

#----- Variaveis de controle

family_name = "U2194 "

# esse valor é o quanto ele vai detalhar a estrutura inicial
flatten_distance = 10

th = False
threshold_distance = 400

# efeito para mais de um contorno
multiple_outline = True
n_outline = 2

# esses são os comportamentos, valores que serão usados na simplificação por distância
# valores interessantes 50, 350, 600, 700
behaviors = [10, 350, 600, 700] 

# pesos
weigths = [40, 60, 100, 160]

# margens
left_margin = 50
right_margin = 50

#----- Funcoes

def dist(pointA, pointB):
    xA, yA = pointA 
    xB, yB = pointB
    return math.hypot(xA-xB, yA-yB)
        
def simple(min_distance, pointList):
        simplePen = font_dest_glyph.getPen()
        simplePen.moveTo(pointList[0])
        last_draw_point = (pointList[0])
    
        for index in range(len(pointList)):

            # verifica se não é o último ponto da lista
            if index != len(pointList)-1:  
            
                # verifica a distância entre último ponto desenhado e o próximo na lista,
                # se for maior que a distância minima desenha o ponto, se não for
                # atualiza o valor do analisa o proximo ponto
                next_point = pointList[index+1]
                distance_point = (dist(last_draw_point, next_point))
                if distance_point > min_distance:
                    simplePen.lineTo(pointList[index])
                    last_draw_point = pointList[index]
            else:
                if pointList[0] == pointList[index]:
                    # remove um -2 que subtraia o index
                    simplePen.lineTo(pointList[index])
                else:
                    simplePen.lineTo(pointList[index])
        simplePen.endPath()

#----- Redesenho dos Glifos

for behavior in behaviors:
    
    for weight in weigths:
        
        font_source = OpenFont("U+2194_Matriz.ufo", showUI=False)
        font_dest = NewFont()
        font_dest.info.familyName = family_name
        font_dest.info.styleName = "%s %s" % (behavior, weight)
        font_dest.info.fullName = "%s %s %s" % (family_name, behavior, weight)

        for font_source_glyph in font_source:
    
            # cria um glifo "temporario"
            work_glyph = font_source[font_source_glyph.name]
    
            # reparte e achata todos os segmentos de acordo com a distância
            flattenGlyph(work_glyph, flatten_distance)
            if th is True:
                thresholdGlyph(work_glyph, threshold_distance)
    
            # gera uma lista de pontos por contorno formatada em tuplas
            work_glyph_point_list = []
            for contour in range(len(work_glyph.contours)):
                work_glyph_contour_point_list = []
                for points in work_glyph[contour].points:
                    # pega somente pontos dentro da curva
                    if str(points.type) is not "offCurve":
                        work_glyph_contour_point_list += [(points.x, points.y)]
                        # work_glyph_contour_point_list += [(points.x+randint(0,200), points.y+randint(0,200))]
                work_glyph_point_list += [work_glyph_contour_point_list]
    
            # cria o espaço para o novo glifo na fonte destino    
            font_dest_glyph = font_dest.newGlyph(work_glyph.name)  
            font_dest_glyph.width = font_source_glyph.width
            for contour in work_glyph_point_list:
                # behavior = randint(50, 600)
                simple(behavior, contour)
            
            # join, cap, round
            # random
            # weight = randint(10, 60)
            expand(font_dest_glyph, font_dest_glyph, weight, 1, 1, False)
            font_dest_glyph.removeOverlap()
            font_dest_glyph.leftMargin = left_margin
            font_dest_glyph.rightMargin = right_margin
        
        # salva a fonte em ufo e otf
        # http://robofab.com/howto/generatefonts.html
        # font_dest.save("fontes/"+str(font_dest.info.fullName)+".ufo")
        font_dest.generate("fontes/"+str(font_dest.info.fullName)+".otf")
        font_dest.close()
    