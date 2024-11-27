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
    composer.gotoScene("scenes.page3", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.page5", { effect = "slideLeft", time = 500 })
end

local function openActivityPopup()
    local popupGroup = display.newGroup()

    local popupBackground = display.newRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, display.contentHeight * 0.6)
    popupBackground:setFillColor(1, 1, 1)
    popupBackground.strokeWidth = 2
    popupBackground:setStrokeColor(0, 0, 0)

    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Atividade: Toque na Sequência Correta",
        x = display.contentCenterX,
        y = popupBackground.y - popupBackground.height * 0.4 + 30,
        width = popupBackground.width * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "center"
    })
    popupTitle:setFillColor(0, 0, 0)

    local instructions = display.newText({
        parent = popupGroup,
        text = "Toque nos elementos na ordem correta para completar o mapeamento genético.",
        x = display.contentCenterX,
        y = popupTitle.y + 40,
        width = popupBackground.width * 0.9,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    instructions:setFillColor(0, 0, 0)

    local steps = { "Identificar genes", "Calcular distância", "Criar mapa" }
    local correctSequence = { 1, 2, 3 }
    local userSequence = {}
    local feedbackText

    local function checkSequence()
        local isCorrect = true
        for i = 1, #correctSequence do
            if userSequence[i] ~= correctSequence[i] then
                isCorrect = false
                break
            end
        end

        if feedbackText then feedbackText:removeSelf() end
        if isCorrect and #userSequence == #correctSequence then
            feedbackText = display.newText({
                parent = popupGroup,
                text = "Parabéns! Você completou a sequência.",
                x = display.contentCenterX,
                y = popupBackground.y + popupBackground.height * 0.3,
                width = popupBackground.width * 0.8,
                font = native.systemFontBold,
                fontSize = 18,
                align = "center"
            })
            feedbackText:setFillColor(0, 0.8, 0)
        else
            feedbackText = display.newText({
                parent = popupGroup,
                text = "Tente novamente! Toque nos passos na ordem correta.",
                x = display.contentCenterX,
                y = popupBackground.y + popupBackground.height * 0.3,
                width = popupBackground.width * 0.8,
                font = native.systemFontBold,
                fontSize = 18,
                align = "center"
            })
            feedbackText:setFillColor(0.8, 0, 0)
        end
    end

    for i = 1, #steps do
        local stepButton = display.newRect(popupGroup, display.contentCenterX, instructions.y + 50 + (i * 50), popupBackground.width * 0.7, 40)
        stepButton:setFillColor(0.8, 0.8, 1)
        stepButton.strokeWidth = 2
        stepButton:setStrokeColor(0, 0, 0)

        local stepLabel = display.newText({
            parent = popupGroup,
            text = steps[i],
            x = stepButton.x,
            y = stepButton.y,
            font = native.systemFont,
            fontSize = 16,
            align = "center"
        })
        stepLabel:setFillColor(0, 0, 0)

        stepButton:addEventListener("tap", function()
            table.insert(userSequence, i)
            stepButton:setFillColor(0.4, 1, 0.4) 
            if #userSequence == #correctSequence then
                checkSequence()
            end
        end)
    end

    local closeButton = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = display.contentCenterX,
        y = popupBackground.y + popupBackground.height * 0.4 - 20,
        font = native.systemFontBold,
        fontSize = 18
    })
    closeButton:setFillColor(1, 0, 0)

    closeButton:addEventListener("tap", function()
        popupGroup:removeSelf()
    end)
end

function scene:create(event)
    local sceneGroup = self.view

    narrationSound = audio.loadStream("assets/audio/page4_narration.mp3")
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
        text = "Conceito do Mapeamento Genético",
        x = dnaImage2.x + 30,
        y = dnaImage2.y + dnaImage2.height * 0.5 + 50,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 24,
        align = "left"
    })
    title.anchorX = 0
    title:setFillColor(0, 0, 0)

    local contentY = title.y + 180
    local contentText = [[
O mapeamento genético é uma técnica fundamental na genética que permite identificar a localização e a ordem dos genes em um cromossomo. Essa abordagem é crucial para compreender a estrutura e a função do genoma, facilitando a determinação de quais genes estão associados a características específicas e a doenças, sendo assim existem dois principais tipos de mapeamento genético.
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

    local physicalTitleY = content.y + content.height + 5
    local physicalTitle = display.newText({
        parent = sceneGroup,
        text = "Mapeamento Físico",
        x = 10,
        y = physicalTitleY,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    physicalTitle.anchorX = 0
    physicalTitle:setFillColor(0, 0, 0)

    local physicalContentY = physicalTitle.y + physicalTitle.height + 150
    local physicalContentText = [[
O mapeamento físico é uma técnica genética que determina a localização exata dos genes em um cromossomo por meio do sequenciamento de DNA. Ao contrário do mapeamento genético, que se baseia na recombinação, o mapeamento físico fornece uma representação detalhada do genoma, permitindo identificar a posição específica de cada gene.
    ]]

    local physicalContent = display.newText({
        parent = sceneGroup,
        text = physicalContentText,
        x = 10,
        y = physicalContentY,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    physicalContent.anchorX = 0
    physicalContent:setFillColor(0, 0, 0)

    local geneticTitleY = physicalContent.y + physicalContent.height + 5
    local geneticTitle = display.newText({
        parent = sceneGroup,
        text = "Mapeamento Genético",
        x = 10,
        y = geneticTitleY,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    geneticTitle.anchorX = 0
    geneticTitle:setFillColor(0, 0, 0)

    local geneticContentY = geneticTitle.y + geneticTitle.height + 150
    local geneticContentText = [[
O mapeamento genético utiliza a frequência de recombinação entre genes para estimar a distância entre eles, permitindo a criação de mapas que mostram a proximidade relativa dos genes. Essa técnica é vital para identificar genes relacionados a doenças, possibilitando o desenvolvimento de testes genéticos que ajudam no diagnóstico e na prevenção de condições hereditárias.
    ]]

    local geneticContent = display.newText({
        parent = sceneGroup,
        text = geneticContentText,
        x = 10,
        y = geneticContentY,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    geneticContent.anchorX = 0
    geneticContent:setFillColor(0, 0, 0)

    local leftArrow = display.newPolygon(sceneGroup, display.contentCenterX - 100, display.contentHeight - 40, {-20, 0, 10, -10, 10, 10})
    leftArrow:setFillColor(0.75, 0.75, 0.75)
    leftArrow:addEventListener("tap", goToPreviousScene)

    local footerIcon = display.newImageRect(sceneGroup, "assets/images/icon_flower.png", 40, 40)
    footerIcon.x = display.contentCenterX
    footerIcon.y = display.contentHeight - 40

    local rightArrow = display.newPolygon(sceneGroup, display.contentCenterX + 100, display.contentHeight - 40, {20, 0, -10, -10, -10, 10})
    rightArrow:setFillColor(0.75, 0.75, 0.75)
    rightArrow:addEventListener("tap", goToNextScene)

    local activityButton = display.newText({
        parent = sceneGroup,
        text = "Atividade",
        x = footerIcon.x,
        y = footerIcon.y - 50,
        font = native.systemFontBold,
        fontSize = 22
    })
    activityButton:setFillColor(0, 0, 1)
    activityButton:addEventListener("tap", openActivityPopup)

    local pageNumber = display.newText({
        parent = sceneGroup,
        text = "4",
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
