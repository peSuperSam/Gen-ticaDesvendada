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
    composer.gotoScene("scenes.page5", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.page7", { effect = "slideLeft", time = 500 })
end

-- Lógica de Mutar e Desmutar a Narração
local function muteAudio()
    if narrationChannel then
        audio.setVolume(0, { channel = narrationChannel })
        isMuted = true
        muteButton.isVisible = false
        unmuteButton.isVisible = true
    end
end

local function unmuteAudio()
    if narrationChannel then
        audio.setVolume(1, { channel = narrationChannel })
        isMuted = false
        muteButton.isVisible = true
        unmuteButton.isVisible = false
    end
end

-- Função para Abrir o Pop-Up da Atividade
local function openActivityPopup()
    local activityPopup = require("scenes.page6popup")
    activityPopup.showPopup()
end

function scene:create(event)
    local sceneGroup = self.view

    -- Narração
    narrationSound = audio.loadStream("assets/audio/page6_narration.mp3")
    narrationChannel = audio.play(narrationSound, { loops = 0 })

    -- Fundo
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

    -- Conteúdo
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

    -- Desafios do Mapeamento Genético
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

    -- Conservação de Espécies
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

    -- Botões de Navegação
    local leftArrow = display.newPolygon(sceneGroup, display.contentCenterX - 100, display.contentHeight - 40, {-20, 0, 10, -10, 10, 10})
    leftArrow:setFillColor(0.75, 0.75, 0.75)
    leftArrow:addEventListener("tap", goToPreviousScene)

    local footerIcon = display.newImageRect(sceneGroup, "assets/images/icon_flower.png", 40, 40)
    footerIcon.x = display.contentCenterX
    footerIcon.y = display.contentHeight - 40

    local rightArrow = display.newPolygon(sceneGroup, display.contentCenterX + 100, display.contentHeight - 40, {20, 0, -10, -10, -10, 10})
    rightArrow:setFillColor(0.75, 0.75, 0.75)
    rightArrow:addEventListener("tap", goToNextScene)

    -- Botão de Atividade
    local activityButton = display.newText({
        parent = sceneGroup,
        text = "CLIQUE AQUI",
        x = display.contentCenterX,
        y = footerIcon.y - 50,
        font = native.systemFontBold,
        fontSize = 22
    })
    activityButton:setFillColor(0, 0, 1)
    activityButton:addEventListener("tap", openActivityPopup)

    -- Botão de Mute/Unmute
    muteButton = display.newImageRect(sceneGroup, "assets/images/audio_icon.png", 50, 50)
    muteButton.x = display.contentWidth - 60
    muteButton.y = 60
    muteButton:addEventListener("tap", muteAudio)

    unmuteButton = display.newImageRect(sceneGroup, "assets/images/audio_mute_icon.png", 50, 50)
    unmuteButton.x = muteButton.x
    unmuteButton.y = muteButton.y
    unmuteButton.isVisible = false
    unmuteButton:addEventListener("tap", unmuteAudio)

    -- Número da Página
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
