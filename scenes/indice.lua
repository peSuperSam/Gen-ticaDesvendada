local composer = require("composer")
local scene = composer.newScene()

local audio = require("audio")

local narrationSound
local narrationChannel

local muteButton
local unmuteButton

function scene:create(event)
    local sceneGroup = self.view

    -- Carregar a narração
    narrationSound = audio.loadStream("assets/audio/indice_narration.mp3")
    narrationChannel = audio.play(narrationSound, { loops = 0 })

    -- Fundo branco
    local whiteBackground = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    whiteBackground:setFillColor(1, 1, 1)

    -- Header
    local headerBackground = display.newRect(sceneGroup, display.contentCenterX, 50, display.contentWidth, 100)
    headerBackground:setFillColor(0.07, 0.14, 0.34)

    local sideBar = display.newRect(sceneGroup, 20, display.contentCenterY, 40, display.contentHeight)
    sideBar:setFillColor(0.07, 0.14, 0.34)

    local circleBackground = display.newCircle(sceneGroup, 60, 50, 25)
    circleBackground:setFillColor(0.22, 0.73, 0.89)

    local flowerIcon = display.newImageRect(sceneGroup, "assets/images/icon_start.png", 30, 30)
    flowerIcon.x = 75
    flowerIcon.y = 35

    local circleText = display.newText({
        parent = sceneGroup,
        text = "Í",
        x = 60,
        y = 50,
        font = native.systemFontBold,
        fontSize = 28,
        align = "center"
    })
    circleText:setFillColor(0, 0, 0)

    local headerTitle = display.newText({
        parent = sceneGroup,
        text = "ndice",
        x = 140,
        y = 50,
        font = native.systemFontBold,
        fontSize = 36,
        align = "left"
    })
    headerTitle:setFillColor(1, 1, 1)

    -- Conteúdo
    local contentY = 130
    local titles = {
        "Introdução",
        "O que é Mapeamento Genético?",
        "Técnicas de Mapeamento Genético",
        "Aplicações e Desafios do Mapeamento Genético",
        "O Futuro do Mapeamento Genético"
    }

    local subContent = {
        {"1.1 Visão geral sobre genética", "1.2 A Importância da Genética nas Ciências Aplicadas"},
        {"2.1 Conceito do mapeamento genético", "2.2 Mapeamento Físico.", "2.3 Mapeamento Genético."},
        {"3.1 Principais métodos e tecnologias utilizadas para mapear o DNA."},
        {"4.1 Mapeamento genético, desafios e estudos sobre faraós.", "4.2 Mapeamento Genético em Conservação de Espécies."},
        {"5.1 Tendências e inovações que podem impactar o mapeamento genético.", "5.2 Impacto das Tecnologias Emergentes no Mapeamento Genético"}
    }

    for i, title in ipairs(titles) do
        local titleText = display.newText({
            parent = sceneGroup,
            text = title,
            x = display.contentCenterX + 20,
            y = contentY,
            width = display.contentWidth * 0.8,
            font = native.systemFontBold,
            fontSize = 20,
            align = "left"
        })
        titleText:setFillColor(0, 0, 0)
        contentY = contentY + 50

        if subContent[i] then
            for _, subText in ipairs(subContent[i]) do
                local subTextContent = display.newText({
                    parent = sceneGroup,
                    text = subText,
                    x = display.contentCenterX + 20,
                    y = contentY,
                    width = display.contentWidth * 0.8,
                    font = native.systemFont,
                    fontSize = 16,
                    align = "left"
                })
                subTextContent:setFillColor(0.2, 0.2, 0.2)
                contentY = contentY + 35
            end
        end
        contentY = contentY + 15
    end

    -- Botões de Mute/Unmute usando funções globais
    muteButton = display.newImageRect(sceneGroup, "assets/images/audio_icon.png", 50, 50)
    muteButton.x = display.contentWidth - 60
    muteButton.y = 60
    muteButton:addEventListener("tap", function()
        muteAudio(narrationChannel)
        muteButton.isVisible = false
        unmuteButton.isVisible = true
    end)

    unmuteButton = display.newImageRect(sceneGroup, "assets/images/audio_mute_icon.png", 50, 50)
    unmuteButton.x = display.contentWidth - 60
    unmuteButton.y = 60
    unmuteButton.isVisible = false
    unmuteButton:addEventListener("tap", function()
        unmuteAudio(narrationChannel)
        muteButton.isVisible = true
        unmuteButton.isVisible = false
    end)

    -- Botões de Navegação
    local function goToPreviousScene()
        if narrationChannel then
            audio.stop(narrationChannel)
            narrationChannel = nil
        end
        composer.gotoScene("scenes.capa", { effect = "slideRight", time = 500 })
    end

    local function goToNextScene()
        if narrationChannel then
            audio.stop(narrationChannel)
            narrationChannel = nil
        end
        composer.gotoScene("scenes.page3", { effect = "slideLeft", time = 500 })
    end

    local leftArrow = display.newPolygon(sceneGroup, display.contentCenterX - 100, display.contentHeight - 40, {-20, 0, 10, -10, 10, 10})
    leftArrow:setFillColor(0.75, 0.75, 0.75)
    leftArrow:addEventListener("tap", goToPreviousScene)

    local rightArrow = display.newPolygon(sceneGroup, display.contentCenterX + 100, display.contentHeight - 40, {20, 0, -10, -10, -10, 10})
    rightArrow:setFillColor(0.75, 0.75, 0.75)
    rightArrow:addEventListener("tap", goToNextScene)
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
