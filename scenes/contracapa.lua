local composer = require("composer")
local scene = composer.newScene()

local audio = require("audio")

local narrationSound
local narrationChannel

local muteButton
local unmuteButton

local function goToPreviousScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.references", { effect = "slideRight", time = 500 })
end

local function goToFirstScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.capa", { effect = "slideRight", time = 500 })
end

function scene:create(event)
    local sceneGroup = self.view

    -- Carregar a narração
    narrationSound = audio.loadStream("assets/audio/contracapa_narration.mp3")
    narrationChannel = audio.play(narrationSound, { loops = 0 })

    -- Fundo
    local background = display.newImageRect(sceneGroup, "assets/images/background_dna.png", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Caixa de Título
    local titleBox = display.newRoundedRect(sceneGroup, display.contentCenterX, display.contentHeight * 0.2, display.contentWidth * 0.9, display.contentHeight * 0.12, 15)
    titleBox:setFillColor(1, 1, 1, 0.9)

    local title = display.newText({
        parent = sceneGroup,
        text = "Genética Desvendada: Explorando o Mapeamento Genético",
        x = display.contentCenterX,
        y = titleBox.y,
        width = display.contentWidth * 0.85,
        font = native.systemFontBold,
        fontSize = 26,
        align = "center"
    })
    title:setFillColor(0.1, 0.1, 0.1)

    -- Caixa de Descrição
    local descriptionBox = display.newRoundedRect(sceneGroup, display.contentCenterX, display.contentHeight * 0.45, display.contentWidth * 0.9, display.contentHeight * 0.35, 15)
    descriptionBox:setFillColor(1, 1, 1, 0.9)

    local description = display.newText({
        parent = sceneGroup,
        text = [[
Apresenta uma visão acessível sobre genética e mapeamento genético. Explora os conceitos fundamentais, técnicas modernas e avanços na área, abordando também os aspectos éticos e sociais. Com exemplos práticos e interatividade, oferece uma experiência envolvente para compreender o impacto dessa tecnologia na ciência e na sociedade.
        ]],
        x = display.contentCenterX,
        y = descriptionBox.y,
        width = display.contentWidth * 0.85,
        font = native.systemFont,
        fontSize = 18,
        align = "left"
    })
    description:setFillColor(0.1, 0.1, 0.1)

    -- Botões Mute/Unmute centralizados (main.lua)
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

    -- Caixa de Créditos
    local creditsBox = display.newRoundedRect(sceneGroup, display.contentCenterX, display.contentHeight * 0.8, display.contentWidth * 0.9, display.contentHeight * 0.15, 15)
    creditsBox:setFillColor(1, 1, 1, 0.9)

    local credits = display.newText({
        parent = sceneGroup,
        text = [[
Autor: Mateus Antônio Ramos da Silva
Orientador: Prof. Ewerton Mendonça
Computação Gráfica e Sistemas Multimídia 2024.2
        ]],
        x = display.contentCenterX,
        y = creditsBox.y,
        width = display.contentWidth * 0.85,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    credits:setFillColor(0.1, 0.1, 0.1)

    -- Setas e Ícones
    local leftArrow = display.newPolygon(sceneGroup, display.contentCenterX - 100, display.contentHeight - 60, {-20, 0, 10, -10, 10, 10})
    leftArrow:setFillColor(0.4, 0.4, 0.4)
    leftArrow:addEventListener("tap", goToPreviousScene)

    local leftArrowText = display.newText({
        parent = sceneGroup,
        text = "Voltar",
        x = leftArrow.x,
        y = leftArrow.y + 30,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    leftArrowText:setFillColor(1, 1, 1)

    local footerIcon = display.newImageRect(sceneGroup, "assets/images/icon_flower.png", 50, 50)
    footerIcon.x = display.contentCenterX
    footerIcon.y = display.contentHeight - 60
    footerIcon:addEventListener("tap", goToFirstScene)

    local footerText = display.newText({
        parent = sceneGroup,
        text = "Início",
        x = footerIcon.x,
        y = footerIcon.y + 30,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    footerText:setFillColor(1, 1, 1)

    local pageNumber = display.newText({
        parent = sceneGroup,
        text = "9",
        x = display.contentWidth - 40,
        y = display.contentHeight - 40,
        font = native.systemFontBold,
        fontSize = 50
    })
    pageNumber:setFillColor(1, 1, 1)
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
