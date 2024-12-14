local composer = require("composer")
local scene = composer.newScene()

local audio = require("audio")

local narrationSound
local narrationChannel

local isMuted = false
local muteButton
local unmuteButton

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

    -- Carregar a narração
    narrationSound = audio.loadStream("assets/audio/page3_narration.mp3")
    narrationChannel = audio.play(narrationSound, { loops = 0 })

    -- Fundo branco
    local whiteBackground = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    whiteBackground:setFillColor(1, 1, 1)

    -- Imagens
    local dnaImage1 = display.newImageRect(sceneGroup, "assets/images/dna_image1.png", display.contentWidth * 0.4, 250)
    dnaImage1.x = dnaImage1.width * 0.5
    dnaImage1.y = 75

    local dnaImage2 = display.newImageRect(sceneGroup, "assets/images/dna_image2.png", display.contentWidth * 0.6, 100)
    dnaImage2.anchorX = 0
    dnaImage2.x = dnaImage1.width
    dnaImage2.y = 50

    -- Título
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

    -- Conteúdo principal
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

    -- Funções de Mute e Unmute
    local function muteAudio()
        if not isMuted then
            audio.setVolume(0, { channel = narrationChannel })
            isMuted = true
            muteButton.isVisible = false
            unmuteButton.isVisible = true
        end
    end

    local function unmuteAudio()
        if isMuted then
            audio.setVolume(1, { channel = narrationChannel })
            isMuted = false
            muteButton.isVisible = true
            unmuteButton.isVisible = false
        end
    end

    -- Botões de Mute/Unmute
    muteButton = display.newImageRect(sceneGroup, "assets/images/audio_icon.png", 50, 50)
    muteButton.x = display.contentWidth - 60
    muteButton.y = 60
    muteButton:addEventListener("tap", muteAudio)

    unmuteButton = display.newImageRect(sceneGroup, "assets/images/audio_mute_icon.png", 50, 50)
    unmuteButton.x = display.contentWidth - 60
    unmuteButton.y = 60
    unmuteButton.isVisible = false
    unmuteButton:addEventListener("tap", unmuteAudio)

    local popup = require("scenes.page3popup")

    local popupButton = display.newText({
        parent = sceneGroup,
        text = "CLIQUE AQUI",
        x = display.contentCenterX,
        y = display.contentHeight - 100,
        font = native.systemFontBold,
        fontSize = 22
    })
    popupButton:setFillColor(0, 0, 1)
    popupButton:addEventListener("tap", function()
        popup.showPopup(sceneGroup)
    end)

    -- Ícones de navegação
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
