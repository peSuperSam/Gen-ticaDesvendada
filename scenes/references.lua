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
    composer.gotoScene("scenes.page7", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.contracapa", { effect = "slideLeft", time = 500 })
end

function scene:create(event)
    local sceneGroup = self.view

    -- Carregar a narração
    narrationSound = audio.loadStream("assets/audio/referencias_narration.mp3")
    narrationChannel = audio.play(narrationSound, { loops = 0 })

    -- Fundo
    local background = display.newImageRect(sceneGroup, "assets/images/background_dna.png", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Caixa Branca
    local whiteBox = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.7)
    whiteBox:setFillColor(1, 1, 1, 0.85)

    -- Título
    local title = display.newText({
        parent = sceneGroup,
        text = "Referências",
        x = display.contentCenterX,
        y = display.contentHeight * 0.18,
        width = display.contentWidth * 0.8,
        font = native.systemFontBold,
        fontSize = 32,
        align = "center"
    })
    title:setFillColor(0, 0, 0)

    -- Lista de Referências
    local references = {
        "https://www.researchgate.net/publication/343021843_Tecnologias_emergentes_em_genetica",
        "https://brasilescola.uol.com.br/biologia/genetica.html",
        "https://www.dasagenomica.com/blog/mapeamento-genetico/",
        "https://www.msdmanuals.com/pt/casa/fundamentos/genética/tecnologias-de-diagnóstico-genético",
        "https://rsdjournal.org/index.php/rsd/article/download/32762/27964/371176",
        "https://www.scielo.br/j/er/a/Pztdvs8nV5DXGQRnzDNzC4f/"
    }

    local startY = display.contentHeight * 0.25
    local spacing = 60

    for i, ref in ipairs(references) do
        local referenceText = display.newText({
            parent = sceneGroup,
            text = ref,
            x = display.contentCenterX,
            y = startY + (i - 1) * spacing,
            width = display.contentWidth * 0.85,
            font = native.systemFont,
            fontSize = 20,
            align = "left"
        })
        referenceText:setFillColor(0, 0, 0)
    end

    -- Botões Mute/Unmute
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
    local leftArrow = display.newPolygon(sceneGroup, display.contentCenterX - 100, display.contentHeight - 40, {-20, 0, 10, -10, 10, 10})
    leftArrow:setFillColor(0.75, 0.75, 0.75)
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

    local footerIcon = display.newImageRect(sceneGroup, "assets/images/icon_flower.png", 40, 40)
    footerIcon.x = display.contentCenterX
    footerIcon.y = display.contentHeight - 40

    local rightArrow = display.newPolygon(sceneGroup, display.contentCenterX + 100, display.contentHeight - 40, {20, 0, -10, -10, -10, 10})
    rightArrow:setFillColor(0.75, 0.75, 0.75)
    rightArrow:addEventListener("tap", goToNextScene)

    local rightArrowText = display.newText({
        parent = sceneGroup,
        text = "Avançar",
        x = rightArrow.x,
        y = rightArrow.y + 30,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    rightArrowText:setFillColor(1, 1, 1)

    -- Número da Página
    local pageNumber = display.newText({
        parent = sceneGroup,
        text = "8",
        x = display.contentWidth - 30,
        y = display.contentHeight - 30,
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
