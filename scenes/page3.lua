local composer = require("composer")
local scene = composer.newScene()

local audio = require("audio")

local narrationSound
local narrationChannel

local function goToPreviousScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.indice", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.page4", { effect = "slideLeft", time = 500 })
end

function scene:create(event)
    local sceneGroup = self.view

    narrationSound = audio.loadStream("assets/audio/page3_narration.mp3")

    narrationChannel = audio.play(narrationSound, { loops = 0 })

    local whiteBackground = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    whiteBackground:setFillColor(1, 1, 1)

    local dnaImage1 = display.newImageRect(sceneGroup, "assets/images/dna_image1.png", display.contentWidth * 0.4, 250)
    dnaImage1.x = dnaImage1.width * 0.5
    dnaImage1.y = 75

    local dnaImage2 = display.newImageRect(sceneGroup, "assets/images/dna_image2.png", display.contentWidth * 0.6, 100)
    dnaImage2.anchorX = 0
    dnaImage2.x = dnaImage1.width
    dnaImage2.y = 50

    local title = display.newText({
        parent = sceneGroup,
        text = "Visão geral sobre genética.",
        x = dnaImage2.x + 50,
        y = dnaImage2.y + dnaImage2.height * 0.5 + 50,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 24,
        align = "left"
    })
    title.anchorX = 0
    title:setFillColor(0, 0, 0)

    local contentY = title.y + 250
    local contentText = [[
    A genética é a ciência que estuda os genes, a hereditariedade e a variação nos organismos. Os genes, que são unidades fundamentais da hereditariedade, estão localizados nos cromossomos e contêm as instruções necessárias para o desenvolvimento, funcionamento e reprodução dos seres vivos.

    A importância da genética na biologia é inegável, pois fornece a base para compreender como características e traços são transmitidos de uma geração para outra. Essa disciplina permite que os cientistas explorem questões cruciais, como a causa de doenças hereditárias, a diversidade genética nas populações e as interações entre genes e meio ambiente.
    ]]

    local content = display.newText({
        parent = sceneGroup,
        text = contentText,
        x = display.contentCenterX,
        y = contentY,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    content.anchorX = 0
    content.x = 10
    content:setFillColor(0, 0, 0)

    local newTitleY = content.y + content.height + 10
    local newTitle = display.newText({
        parent = sceneGroup,
        text = "A Importância da Genética nas Ciências Aplicadas",
        x = 10,
        y = newTitleY,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    newTitle.anchorX = 0
    newTitle:setFillColor(0, 0, 0)

    local newContentY = newTitle.y + newTitle.height + 200
    local newContentText = [[
    A genética desempenha um papel essencial em várias áreas, incluindo medicina, agricultura, biotecnologia e conservação de espécies. Na medicina, por exemplo, a compreensão dos mecanismos genéticos é fundamental para o desenvolvimento de terapias para doenças genéticas e câncer. Na agricultura, a genética ajuda a desenvolver novas culturas e aumentar a resistência a pragas e doenças, promovendo a segurança alimentar.

    Em resumo, a genética é uma área central da biologia que não apenas ajuda a decifrar os mistérios da vida, mas também fornece ferramentas práticas para resolver problemas e melhorar a saúde e o bem-estar da sociedade. A pesquisa genética continuará a avançar, ampliando as possibilidades para o futuro da ciência e da medicina.
    ]]

    local newContent = display.newText({
        parent = sceneGroup,
        text = newContentText,
        x = 10,
        y = newContentY,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    newContent.anchorX = 0
    newContent:setFillColor(0, 0, 0)

local function showPopup()
    local popupGroup = display.newGroup()
    sceneGroup:insert(popupGroup)

    local popupBackground = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, display.contentHeight * 0.8, 20)
    popupBackground:setFillColor(1, 1, 1)
    popupBackground.strokeWidth = 4
    popupBackground:setStrokeColor(0, 0, 0)

    local instructions = display.newText({
        parent = popupGroup,
        text = "Arraste os conceitos da esquerda para as definições corretas à direita:",
        x = display.contentCenterX,
        y = display.contentCenterY - 200,
        width = display.contentWidth * 0.7,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center"
    })
    instructions:setFillColor(0, 0, 0)

    local concepts = {
        { text = "Gene", x = display.contentCenterX - 100, y = display.contentCenterY - 150 },
        { text = "Hereditariedade", x = display.contentCenterX - 100, y = display.contentCenterY - 100 },
        { text = "Cromossomos", x = display.contentCenterX - 100, y = display.contentCenterY - 50 }
    }

    local definitions = {
        { text = "a. Transmissão de características", x = display.contentCenterX + 100, y = display.contentCenterY - 150, correctId = 2 },
        { text = "b. Unidade funcional da hereditariedade", x = display.contentCenterX + 100, y = display.contentCenterY - 100, correctId = 1 },
        { text = "c. Estruturas que contêm DNA", x = display.contentCenterX + 100, y = display.contentCenterY - 50, correctId = 3 }
    }

    local draggableItems = {}
    local matchedCount = 0 -- Contador de correspondências corretas

    for i, concept in ipairs(concepts) do
        local item = display.newText({
            parent = popupGroup,
            text = concept.text,
            x = concept.x,
            y = concept.y,
            font = native.systemFontBold,
            fontSize = 18
        })
        item:setFillColor(0, 0, 1)
        item.isDraggable = true
        item.id = i
        table.insert(draggableItems, item)
    end

    for i, definition in ipairs(definitions) do
        local target = display.newText({
            parent = popupGroup,
            text = definition.text,
            x = definition.x,
            y = definition.y,
            font = native.systemFont,
            fontSize = 18
        })
        target:setFillColor(0, 0, 0)
        target.id = i
        target.correctId = definition.correctId
    end

    local function onDrag(event)
        local target = event.target
        if target.isDraggable then
            if event.phase == "began" then
                display.getCurrentStage():setFocus(target)
                target.startX = target.x
                target.startY = target.y
                target:setFillColor(0.5, 0.5, 1) -- Destaque visual ao arrastar
            elseif event.phase == "moved" then
                target.x = event.x
                target.y = event.y
            elseif event.phase == "ended" or event.phase == "cancelled" then
                display.getCurrentStage():setFocus(nil)
                target:setFillColor(0, 0, 1) -- Restaurar cor após soltar

                local matched = false
                for _, definition in ipairs(definitions) do
                    local dx = math.abs(target.x - definition.x)
                    local dy = math.abs(target.y - definition.y)
                    if dx < 50 and dy < 20 and target.id == definition.correctId then
                        target.x = definition.x
                        target.y = definition.y
                        target:setFillColor(0, 1, 0) -- Cor verde para indicar sucesso
                        matched = true
                        matchedCount = matchedCount + 1
                        break
                    end
                end

                if not matched then
                    target.x = target.startX
                    target.y = target.startY
                    target:setFillColor(1, 0, 0) -- Cor vermelha para indicar falha
                end

                if matchedCount == #concepts then
                    local successText = display.newText({
                        parent = popupGroup,
                        text = "Parabéns! Você completou a atividade!",
                        x = display.contentCenterX,
                        y = display.contentCenterY + 200,
                        font = native.systemFontBold,
                        fontSize = 18,
                        align = "center"
                    })
                    successText:setFillColor(0, 0.5, 0)
                end
            end
        end
        return true
    end

    for _, item in ipairs(draggableItems) do
        item:addEventListener("touch", onDrag)
    end

    local closeButton = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = display.contentCenterX,
        y = display.contentCenterY + 250,
        font = native.systemFontBold,
        fontSize = 20
    })
    closeButton:setFillColor(1, 0, 0)

    closeButton:addEventListener("tap", function()
        popupGroup:removeSelf()
        popupGroup = nil
    end)
end

    local popupButton = display.newText({
        parent = sceneGroup,
        text = "Atividade",
        x = display.contentCenterX,
        y = display.contentHeight - 100,
        font = native.systemFontBold,
        fontSize = 22
    })
    popupButton:setFillColor(0, 0, 1)
    popupButton:addEventListener("tap", showPopup)

    local footerIcon = display.newImageRect(sceneGroup, "assets/images/icon_flower.png", 40, 40)
    footerIcon.x = display.contentCenterX
    footerIcon.y = display.contentHeight - 40

    local leftArrow = display.newPolygon(sceneGroup, display.contentCenterX - 100, display.contentHeight - 40, {-20, 0, 10, -10, 10, 10})
    leftArrow:setFillColor(0.75, 0.75, 0.75)
    leftArrow:addEventListener("tap", goToPreviousScene)

    local rightArrow = display.newPolygon(sceneGroup, display.contentCenterX + 100, display.contentHeight - 40, {20, 0, -10, -10, -10, 10})
    rightArrow:setFillColor(0.75, 0.75, 0.75)
    rightArrow:addEventListener("tap", goToNextScene)

    local pageNumber = display.newText({
        parent = sceneGroup,
        text = "3",
        x = display.contentWidth - 30,
        y = display.contentHeight - 30,
        font = native.systemFontBold,
        fontSize = 50
    })
    pageNumber:setFillColor(0, 0, 0)
end

function scene:destroy(event)
    if narrationSound then
        audio.dispose(narrationSound)
        narrationSound = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)

return scene
