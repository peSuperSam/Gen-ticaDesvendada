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
    composer.gotoScene("scenes.page4", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.page6", { effect = "slideLeft", time = 500 })
end

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

function scene:create(event)
    local sceneGroup = self.view

    -- Narração
    narrationSound = audio.loadStream("assets/audio/page5_narration.mp3")
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
        text = "Principais Métodos e Tecnologias para Mapear o DNA",
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
O mapeamento de DNA envolve diversas técnicas que ajudam a identificar a localização dos genes e outras características genômicas importantes. Entre os métodos mais utilizados estão o sequenciamento de nova geração (NGS) e o mapeamento de polimorfismos de nucleotídeo único (SNPs), que desempenham papéis essenciais na genética moderna.
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

    -- NGS (Sequenciamento de Nova Geração)
    local ngsTitle = display.newText({
        parent = sceneGroup,
        text = "• Sequenciamento de Nova Geração (NGS)",
        x = 10,
        y = 400,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    ngsTitle.anchorX = 0
    ngsTitle:setFillColor(0, 0, 0)

    local ngsContent = display.newText({
        parent = sceneGroup,
        text = [[
O sequenciamento de nova geração (NGS) é uma tecnologia avançada que permite sequenciar rapidamente grandes porções do genoma com alta precisão. Ela fornece informações detalhadas sobre a estrutura genética, facilitando a identificação de mutações, variações genéticas e padrões de herança. O NGS é amplamente utilizado em pesquisas biomédicas, medicina personalizada e estudos de doenças genéticas.
        ]],
        x = 10,
        y = 520,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    ngsContent.anchorX = 0
    ngsContent:setFillColor(0, 0, 0)

    -- SNPs (Polimorfismos de Nucleotídeo Único)
    local snpTitle = display.newText({
        parent = sceneGroup,
        text = "• Mapeamento de Polimorfismos de Nucleotídeo Único (SNPs)",
        x = 10,
        y = 650,
        width = display.contentWidth * 0.9,
        font = native.systemFontBold,
        fontSize = 20,
        align = "left"
    })
    snpTitle.anchorX = 0
    snpTitle:setFillColor(0, 0, 0)

    local snpContent = display.newText({
        parent = sceneGroup,
        text = [[
Outro método importante é o mapeamento de polimorfismos de nucleotídeo único (SNPs), que utiliza variações genéticas comuns no DNA para criar mapas genéticos detalhados. Os SNPs são marcadores úteis para estudos de associação genética, ajudando a identificar genes ligados a doenças hereditárias e características específicas em populações.
        ]],
        x = 10,
        y = 780,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    snpContent.anchorX = 0
    snpContent:setFillColor(0, 0, 0)

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

    local popup = require("scenes.page5popup")

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
        text = "5",
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
