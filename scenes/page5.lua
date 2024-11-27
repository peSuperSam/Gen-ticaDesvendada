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
    composer.gotoScene("scenes.page4", { effect = "slideRight", time = 500 })
end

local function goToNextScene()
    if narrationChannel then
        audio.stop(narrationChannel)
        narrationChannel = nil
    end
    composer.gotoScene("scenes.page6", { effect = "slideLeft", time = 500 })
end

local function openActivityPopup()
    local popupGroup = display.newGroup()

    local popupBackground = display.newRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, display.contentHeight * 0.6)
    popupBackground:setFillColor(1, 1, 1)
    popupBackground.strokeWidth = 2
    popupBackground:setStrokeColor(0, 0, 0)

    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Atividade: Explore o Genoma",
        x = display.contentCenterX,
        y = popupBackground.y - popupBackground.height * 0.4 + 10,
        font = native.systemFontBold,
        fontSize = 20,
        align = "center"
    })
    popupTitle:setFillColor(0, 0, 0)

    local instructions = display.newText({
        parent = popupGroup,
        text = "Use a inclinação do dispositivo para explorar o genoma e descobrir informações sobre NGS e SNPs.",
        x = display.contentCenterX,
        y = popupTitle.y + 50,
        width = popupBackground.width * 0.9,
        font = native.systemFont,
        fontSize = 15,
        align = "center"
    })
    instructions:setFillColor(0, 0, 0)

    local genomeBackground = display.newRect(popupGroup, display.contentCenterX, display.contentCenterY, popupBackground.width * 0.9, popupBackground.height * 0.6)
    genomeBackground:setFillColor(0.9, 0.9, 0.9)

    local magnifier = display.newCircle(popupGroup, display.contentCenterX, display.contentCenterY, 50)
    magnifier:setFillColor(0, 0, 0, 0.1)
    magnifier.strokeWidth = 2
    magnifier:setStrokeColor(0, 0, 0)

    local hiddenInfo = {
        { x = genomeBackground.x - 60, y = genomeBackground.y - 40, text = "NGS: Sequenciamento rápido e preciso" },
        { x = genomeBackground.x + 50, y = genomeBackground.y + 30, text = "SNPs: Mapas genéticos detalhados" }
    }

    for i = 1, #hiddenInfo do
        local info = hiddenInfo[i]
        local hiddenText = display.newText({
            parent = popupGroup,
            text = info.text,
            x = info.x,
            y = info.y,
            font = native.systemFont,
            fontSize = 16,
            align = "center"
        })
        hiddenText:setFillColor(0, 0, 0)
        hiddenText.isVisible = false -- Inicialmente oculto
        info.displayObject = hiddenText
    end

    local function onAccelerometer(event)
        magnifier.x = magnifier.x + (event.xGravity * 15)
        magnifier.y = magnifier.y + (event.yGravity * -15)

        if magnifier.x < genomeBackground.x - genomeBackground.width * 0.5 then
            magnifier.x = genomeBackground.x - genomeBackground.width * 0.5
        elseif magnifier.x > genomeBackground.x + genomeBackground.width * 0.5 then
            magnifier.x = genomeBackground.x + genomeBackground.width * 0.5
        end

        if magnifier.y < genomeBackground.y - genomeBackground.height * 0.5 then
            magnifier.y = genomeBackground.y - genomeBackground.height * 0.5
        elseif magnifier.y > genomeBackground.y + genomeBackground.height * 0.5 then
            magnifier.y = genomeBackground.y + genomeBackground.height * 0.5
        end

        for i = 1, #hiddenInfo do
            local info = hiddenInfo[i]
            if math.abs(magnifier.x - info.x) < 50 and math.abs(magnifier.y - info.y) < 50 then
                info.displayObject.isVisible = true
            end
        end
    end

    Runtime:addEventListener("accelerometer", onAccelerometer)

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
        Runtime:removeEventListener("accelerometer", onAccelerometer)
        popupGroup:removeSelf()
    end)
end

function scene:create(event)
    local sceneGroup = self.view

    narrationSound = audio.loadStream("assets/audio/page5_narration.mp3")
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