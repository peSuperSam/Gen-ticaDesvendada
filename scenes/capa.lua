local composer = require("composer")
local scene = composer.newScene()

local audio = require("audio")

local narrationSound
local narrationChannel

local hoverDescription

function scene:create(event)
    local sceneGroup = self.view

    narrationSound = audio.loadStream("assets/audio/capa_narration.mp3")


    narrationChannel = audio.play(narrationSound, { loops = 0 })

    local background = display.newImageRect(sceneGroup, "assets/images/background_dna.png", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local whiteBox = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.8)
    whiteBox:setFillColor(1, 1, 1, 0.85)
    whiteBox.strokeWidth = 8
    whiteBox:setStrokeColor(0.12, 0.18, 0.34)

    local title = display.newText({
        parent = sceneGroup,
        text = "Genética Desvendada",
        x = display.contentCenterX,
        y = display.contentHeight * 0.14,
        width = display.contentWidth * 0.8,
        font = native.systemFontBold,
        fontSize = 44,
        align = "center"
    })
    title:setFillColor(0, 0, 0)

    local subtitle = display.newText({
        parent = sceneGroup,
        text = "Explorando o Mapeamento Genético",
        x = display.contentCenterX,
        y = display.contentHeight * 0.18,
        width = display.contentWidth * 0.8,
        font = native.systemFontItalic,
        fontSize = 24,
        align = "center"
    })
    subtitle:setFillColor(0.2, 0.2, 0.2)

    local function addCircleImage(imagePath, xPos, yPos)
        local image = display.newImageRect(sceneGroup, imagePath, 110, 110)
        if not image then
            print("Erro: Não foi possível carregar " .. imagePath)
        else
            image.x = xPos
            image.y = yPos
        end
    end

    addCircleImage("assets/images/img1_circle.png", display.contentCenterX - 120, display.contentHeight * 0.42)
    addCircleImage("assets/images/img2_circle.png", display.contentCenterX, display.contentHeight * 0.36)
    addCircleImage("assets/images/img3_circle.png", display.contentCenterX + 120, display.contentHeight * 0.42)

    local authorBox = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight * 0.72, display.contentWidth * 0.8, 80)
    authorBox:setFillColor(1, 1, 1, 0.85)
    authorBox.strokeWidth = 4
    authorBox:setStrokeColor(0.12, 0.18, 0.34)

    local authorText = display.newText({
        parent = sceneGroup,
        text = "Mateus Antônio Ramos da Silva\n2024.2",
        x = display.contentCenterX,
        y = display.contentHeight * 0.72,
        width = display.contentWidth * 0.7,
        font = native.systemFont,
        fontSize = 20,
        align = "center"
    })
    authorText:setFillColor(0, 0, 0)

    local function goToPage2()
        if narrationChannel then
            audio.stop(narrationChannel)
            narrationChannel = nil
        end
        composer.gotoScene("scenes.indice", { effect = "slideLeft", time = 500 })
    end

    local startButtonIcon = display.newImageRect(sceneGroup, "assets/images/icon_start.png", 65, 65)
    startButtonIcon.x = display.contentCenterX
    startButtonIcon.y = display.contentHeight * 0.93
    startButtonIcon:addEventListener("tap", goToPage2)

    local startButtonText = display.newText({
        parent = sceneGroup,
        text = "Iniciar",
        x = display.contentCenterX,
        y = display.contentHeight * 0.98,
        font = native.systemFontBold,
        fontSize = 22,
        align = "center"
    })
    startButtonText:setFillColor(1, 1, 1)

    local pageNumber = display.newText({
        parent = sceneGroup,
        text = "1",
        x = display.contentWidth - 40,
        y = display.contentHeight - 40,
        font = native.systemFontBold,
        fontSize = 50,
        align = "center"
    })
    pageNumber:setFillColor(1, 1, 1)

    hoverDescription = display.newText({
        parent = sceneGroup,
        text = "",
        x = display.contentCenterX,
        y = display.contentHeight * 0.9,
        font = native.systemFont,
        fontSize = 18,
        align = "center"
    })
    hoverDescription:setFillColor(0, 0, 0)
    hoverDescription.isVisible = false

    local function showDescription(event)
        hoverDescription.text = "Clique para iniciar o e-book"
        hoverDescription.isVisible = true
    end

    local function hideDescription(event)
        hoverDescription.isVisible = false
    end

    startButtonIcon:addEventListener("mouse", showDescription)
    startButtonIcon:addEventListener("mouse", hideDescription)
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
