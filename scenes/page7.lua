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
    composer.gotoScene("scenes.page6", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.references", { effect = "slideLeft", time = 500 })
end

local function openActivityPopup()
    local popupGroup = display.newGroup()

    local popupBackground = display.newRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, display.contentHeight * 0.6)
    popupBackground:setFillColor(1, 1, 1)
    popupBackground.strokeWidth = 2
    popupBackground:setStrokeColor(0, 0, 0)

    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Atividade: Relacione as Tecnologias",
        x = display.contentCenterX,
        y = display.contentCenterY - popupBackground.height * 0.4 + 30,
        font = native.systemFontBold,
        fontSize = 20,
        align = "center"
    })
    popupTitle:setFillColor(0, 0, 0)

    local instructions = display.newText({
        parent = popupGroup,
        text = "Arraste cada tecnologia para sua descrição correspondente.",
        x = display.contentCenterX,
        y = popupTitle.y + 50,
        width = popupBackground.width * 0.9,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    instructions:setFillColor(0, 0, 0)

    local feedbackText = display.newText({
        parent = popupGroup,
        text = "",
        x = display.contentCenterX,
        y = display.contentCenterY + popupBackground.height * 0.3,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center"
    })
    feedbackText:setFillColor(0, 0, 0)

    local correctSound = audio.loadSound("assets/sounds/correct.mp3")
    local wrongSound = audio.loadSound("assets/sounds/wrong.mp3")

    local descriptions = {
        { text = "Permite análises rápidas e detalhadas do DNA.", x = display.contentCenterX - 120, y = display.contentCenterY + 50 },
        { text = "Facilita edições precisas em genes.", x = display.contentCenterX - 120, y = display.contentCenterY + 120 }
    }

    local targets = {}
    for i, desc in ipairs(descriptions) do
        local targetArea = display.newRect(popupGroup, desc.x, desc.y, 200, 40)
        targetArea:setFillColor(0.9, 0.9, 0.9)
        targetArea.strokeWidth = 2
        targetArea:setStrokeColor(0, 0, 0)

        local targetText = display.newText({
            parent = popupGroup,
            text = desc.text,
            x = desc.x,
            y = desc.y,
            font = native.systemFont,
            fontSize = 14,
            align = "left",
            width = 180
        })
        targetText:setFillColor(0, 0, 0)

        targets[i] = { area = targetArea, correct = false }
    end

    local techs = {
        { text = "NGS", x = display.contentCenterX - 100, y = display.contentCenterY - 20, correctTarget = descriptions[1].y },
        { text = "CRISPR", x = display.contentCenterX + 100, y = display.contentCenterY - 20, correctTarget = descriptions[2].y }
    }

    local function checkCompletion()
        local allCorrect = true
        for _, target in ipairs(targets) do
            if not target.correct then
                allCorrect = false
                break
            end
        end

        if allCorrect then
            feedbackText.text = "Parabéns! Você acertou todas as combinações!"
            feedbackText:setFillColor(0, 0.6, 0)
            audio.play(correctSound)
        else
            feedbackText.text = "Continue tentando..."
            feedbackText:setFillColor(1, 0, 0)
        end
    end

    for i, tech in ipairs(techs) do
        local draggableTech = display.newText({
            parent = popupGroup,
            text = tech.text,
            x = tech.x,
            y = tech.y,
            font = native.systemFontBold,
            fontSize = 18
        })
        draggableTech:setFillColor(math.random(), math.random(), math.random())

        draggableTech:addEventListener("touch", function(event)
            if event.phase == "began" then
                display.getCurrentStage():setFocus(draggableTech)
                draggableTech.isFocus = true
                draggableTech.markX = draggableTech.x
                draggableTech.markY = draggableTech.y
            elseif event.phase == "moved" then
                if draggableTech.isFocus then
                    draggableTech.x = event.x
                    draggableTech.y = event.y
                end
            elseif event.phase == "ended" or event.phase == "cancelled" then
                if draggableTech.isFocus then
                    display.getCurrentStage():setFocus(nil)
                    draggableTech.isFocus = false

                    local correctPlacement = false
                    for _, target in ipairs(targets) do
                        if math.abs(draggableTech.x - target.area.x) < target.area.width / 2 and
                           math.abs(draggableTech.y - target.area.y) < target.area.height / 2 then
                            draggableTech.x = target.area.x
                            draggableTech.y = target.area.y

                            if target.area.y == tech.correctTarget then
                                target.correct = true
                                target.area:setFillColor(0.2, 0.8, 0.2)
                                correctPlacement = true
                            else
                                audio.play(wrongSound)
                                draggableTech.x = draggableTech.markX
                                draggableTech.y = draggableTech.markY
                            end
                            break
                        end
                    end

                    if correctPlacement then
                        checkCompletion()
                    end
                end
            end
        end)
    end

    local closeButton = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = display.contentCenterX,
        y = display.contentCenterY + popupBackground.height * 0.4 - 20,
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

    narrationSound = audio.loadStream("assets/audio/page7_narration.mp3")
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
        text = "Inovações e Impactos no Mapeamento Genético",
        x = dnaImage2.x + 30,
        y = dnaImage2.y + dnaImage2.height * 0.5 + 50,
        width = display.contentWidth * 0.5,
        font = native.systemFontBold,
        fontSize = 24,
        align = "left"
    })
    title.anchorX = 0
    title:setFillColor(0, 0, 0)

    local content = display.newText({
        parent = sceneGroup,
        text = [[
O mapeamento genético está sendo revolucionado por inovações como o sequenciamento de nova geração (NGS), que permite análises rápidas e detalhadas do DNA, acelerando a identificação de variantes associadas a doenças. Outra inovação importante é a edição genética com CRISPR-Cas9, que possibilita modificações precisas em genes, ampliando a compreensão da função gênica.
        ]],
        x = 10,
        y = 320,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    content.anchorX = 0
    content:setFillColor(0, 0, 0)

    local secondaryContent = display.newText({
        parent = sceneGroup,
        text = [[
Essas tecnologias estão impulsionando áreas como medicina personalizada, onde tratamentos podem ser ajustados ao perfil genético dos pacientes. No entanto, esses avanços também levantam questões éticas e de privacidade, tornando essencial que a discussão sobre suas implicações acompanhe o progresso científico.
        ]],
        x = 10,
        y = content.y + content.height + 10,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    secondaryContent.anchorX = 0
    secondaryContent:setFillColor(0, 0, 0)

    local emergingTitle = display.newText({
        parent = sceneGroup,
        text = "Tecnologias Emergentes no Mapeamento Genético",
        x = 10,
        y = secondaryContent.y + secondaryContent.height + 150,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    emergingTitle.anchorX = 0
    emergingTitle:setFillColor(0, 0, 0)

    local emergingContent = display.newText({
        parent = sceneGroup,
        text = [[
Tecnologias emergentes estão revolucionando o mapeamento genético. O sequenciamento de terceira geração permite a leitura de longas sequências de DNA, revelando variações genéticas complexas. Além disso, a bioinformática, com o uso de inteligência artificial, facilita a análise de grandes volumes de dados genéticos, acelerando a identificação de padrões relacionados a doenças e características fenotípicas. Essas inovações aumentam a precisão do mapeamento e expandem as possibilidades de pesquisa na genética.
        ]],
        x = 10,
        y = emergingTitle.y + emergingTitle.height + 150,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    emergingContent.anchorX = 0
    emergingContent:setFillColor(0, 0, 0)

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
        text = "7",
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