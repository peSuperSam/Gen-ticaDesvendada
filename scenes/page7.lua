local composer = require("composer")
local scene = composer.newScene()

local audio = require("audio")

local narrationSound
local narrationChannel
local isMuted = false
local muteButton
local unmuteButton

-- Função para navegar para a cena anterior
local function goToPreviousScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.page6", { effect = "slideRight", time = 500 })
end

-- Função para navegar para a próxima cena
local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.references", { effect = "slideLeft", time = 500 })
end

-- Lógica para Mutar e Desmutar
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

-- Abrir o pop-up da atividade
local function openActivityPopup()
    local popup = require("scenes.page7popup")
    popup.showPopup()
end

function scene:create(event)
    local sceneGroup = self.view

    -- Narração
    narrationSound = audio.loadStream("assets/audio/page7_narration.mp3")
    narrationChannel = audio.play(narrationSound, { loops = 0 })

    -- Fundo Branco
    local whiteBackground = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    whiteBackground:setFillColor(1, 1, 1)

    -- Imagens do Topo
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

    -- Conteúdo
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

    -- Subtítulo e Conteúdo Adicional
    local emergingTitle = display.newText({
        parent = sceneGroup,
        text = "Tecnologias Emergentes no Mapeamento Genético",
        x = 10,
        y = content.y + content.height + 50,
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
        y = emergingTitle.y + 150,
        width = display.contentWidth * 0.9,
        font = native.systemFont,
        fontSize = 22,
        align = "left"
    })
    emergingContent.anchorX = 0
    emergingContent:setFillColor(0, 0, 0)

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

    -- Botões de Mute/Unmute
    muteButton = display.newImageRect(sceneGroup, "assets/images/audio_icon.png", 50, 50)
    muteButton.x = display.contentWidth - 60
    muteButton.y = 60
    muteButton:addEventListener("tap", muteAudio)

    unmuteButton = display.newImageRect(sceneGroup, "assets/images/audio_mute_icon.png", 50, 50)
    unmuteButton.x = muteButton.x
    unmuteButton.y = muteButton.y
    unmuteButton.isVisible = false
    unmuteButton:addEventListener("tap", unmuteAudio)

    -- Botão de Atividade
    local activityButton = display.newText({
        parent = sceneGroup,
        text = "CLIQUE AQUI",
        x = footerIcon.x,
        y = footerIcon.y - 50,
        font = native.systemFontBold,
        fontSize = 22
    })
    activityButton:setFillColor(0, 0, 1)
    activityButton:addEventListener("tap", openActivityPopup)

    -- Número da Página
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
