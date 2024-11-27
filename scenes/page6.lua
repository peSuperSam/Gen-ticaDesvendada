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
    composer.gotoScene("scenes.page5", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.page7", { effect = "slideLeft", time = 500 })
end

local function openActivityPopup()
    local popupGroup = display.newGroup()

    local popupBackground = display.newRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, display.contentHeight * 0.6)
    popupBackground:setFillColor(1, 1, 1)
    popupBackground.strokeWidth = 2
    popupBackground:setStrokeColor(0, 0, 0)

    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Atividade: Monte a Cadeia de DNA",
        x = display.contentCenterX,
        y = display.contentCenterY - popupBackground.height * 0.4 + 30,
        font = native.systemFontBold,
        fontSize = 20,
        align = "center"
    })
    popupTitle:setFillColor(0, 0, 0)

    local dnaImage = display.newImageRect(popupGroup, "assets/images/dnaatividade.png", 150, 150)
    dnaImage.x = display.contentCenterX
    dnaImage.y = display.contentCenterY - 30

    local instructions = display.newText({
        parent = popupGroup,
        text = "Clique nas bases para formar a cadeia correta de DNA.",
        x = display.contentCenterX,
        y = popupTitle.y + 80,
        width = popupBackground.width * 0.9,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    instructions:setFillColor(0, 0, 0)

    local correctSequence = {"A", "T", "C", "G"}
    local userSequence = {}
    local baseButtons = {}
    local feedbackText

    local function playFeedbackSound(isCorrect)
        local soundFile = isCorrect and "assets/sounds/correct.mp3" or "assets/sounds/wrong.mp3"
        if soundFile then
            audio.play(audio.loadSound(soundFile))
        end
    end

    local function checkSequence()
        local isCorrect = true
        for i = 1, #correctSequence do
            if correctSequence[i] ~= userSequence[i] then
                isCorrect = false
                break
            end
        end

        if isCorrect and #userSequence == #correctSequence then
            feedbackText.text = "Parabéns! Você montou a sequência correta!"
            feedbackText:setFillColor(0, 0.6, 0)
            playFeedbackSound(true)

            transition.to(feedbackText, { xScale = 1.2, yScale = 1.2, time = 300, transition = easing.continuousLoop, onComplete = function()
                transition.to(feedbackText, { xScale = 1, yScale = 1, time = 300 })
            end })
        elseif #userSequence < #correctSequence then
            feedbackText.text = "Continue selecionando as bases!"
            feedbackText:setFillColor(0, 0, 0)
        else
            feedbackText.text = "Sequência incorreta. Tente novamente."
            feedbackText:setFillColor(1, 0, 0)
            playFeedbackSound(false)
        end
    end

    local function onBaseTap(event)
        if #userSequence < #correctSequence then
            table.insert(userSequence, event.target.text)
            event.target:setFillColor(0.5, 0.5, 0.5) 
            event.target:removeEventListener("tap", onBaseTap) 
            checkSequence()
        end
    end

    for i = 1, #correctSequence do
        baseButtons[i] = display.newText({
            parent = popupGroup,
            text = correctSequence[i],
            x = display.contentCenterX - 60 + (i * 40),
            y = dnaImage.y + 100,
            font = native.systemFontBold,
            fontSize = 18
        })
        baseButtons[i]:setFillColor(math.random(), math.random(), math.random())
        baseButtons[i]:addEventListener("tap", onBaseTap)
    end

    feedbackText = display.newText({
        parent = popupGroup,
        text = "Selecione as bases na ordem correta.",
        x = display.contentCenterX,
        y = dnaImage.y + 160,
        width = popupBackground.width * 0.9,
        font = native.systemFont,
        fontSize = 14,
        align = "center"
    })
    feedbackText:setFillColor(0, 0, 0)

    local restartButton = display.newText({
        parent = popupGroup,
        text = "Reiniciar",
        x = display.contentCenterX - 60,
        y = feedbackText.y + 50,
        font = native.systemFontBold,
        fontSize = 18
    })
    restartButton:setFillColor(0, 0, 1)
    restartButton:addEventListener("tap", function()
        userSequence = {}
        feedbackText.text = "Selecione as bases na ordem correta."
        feedbackText:setFillColor(0, 0, 0)
        for i = 1, #baseButtons do
            baseButtons[i]:setFillColor(math.random(), math.random(), math.random())
            baseButtons[i]:addEventListener("tap", onBaseTap)
        end
    end)

    local closeButton = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = display.contentCenterX + 60,
        y = feedbackText.y + 50,
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

    narrationSound = audio.loadStream("assets/audio/page6_narration.mp3")
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
        text = "Mapeamento Genético, Desafios e Estudos sobre Faraós",
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
O mapeamento genético é uma técnica essencial na biologia moderna, permitindo identificar e localizar genes em organismos. Essa abordagem é aplicada ao estudo de populações antigas, como os faraós do Egito, através da análise de DNA extraído de múmias, revelando informações sobre saúde, parentesco e ascendência.
        ]],
        x = 10,
        y = 300,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    content.anchorX = 0
    content:setFillColor(0, 0, 0)

    local faraoTitle = display.newText({
        parent = sceneGroup,
        text = "Desafios do Mapeamento Genético",
        x = 10,
        y = 400,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    faraoTitle.anchorX = 0
    faraoTitle:setFillColor(0, 0, 0)

    local faraoContent = display.newText({
        parent = sceneGroup,
        text = [[
Contudo, o mapeamento genético enfrenta desafios, como a degradação do DNA em amostras antigas e questões éticas relacionadas à privacidade e consentimento. Apesar dessas dificuldades, os estudos genéticos dos faraós oferecem valiosas perspectivas sobre a história e cultura da civilização egípcia, contribuindo para o avanço do conhecimento em genética e arqueologia.
        ]],
        x = 10,
        y = 520,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    faraoContent.anchorX = 0
    faraoContent:setFillColor(0, 0, 0)

    local conservationTitle = display.newText({
        parent = sceneGroup,
        text = "Mapeamento Genético em Conservação de Espécies",
        x = 10,
        y = 650,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    conservationTitle.anchorX = 0
    conservationTitle:setFillColor(0, 0, 0)

    local conservationContent = display.newText({
        parent = sceneGroup,
        text = [[
O mapeamento genético é crucial para a conservação de espécies ameaçadas, permitindo que cientistas compreendam a diversidade genética dentro de populações. Ele ajuda a monitorar a saúde genética de animais e plantas em risco de extinção, identificando variações genéticas que indicam adaptabilidade a mudanças ambientais, essencial para a preservação da biodiversidade.
        ]],
        x = 10,
        y = 780,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    conservationContent.anchorX = 0
    conservationContent:setFillColor(0, 0, 0)

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
         text = "6",
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
