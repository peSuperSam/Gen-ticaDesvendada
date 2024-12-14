local M = {}
local popupLogic = require("scenes.page5popup_logic")

function M.showPopup(sceneGroup)
    local physics = require("physics")
    physics.start()
    physics.setGravity(0, 9.8)

    -- Grupo principal
    local popupGroup = display.newGroup()
    sceneGroup:insert(popupGroup)

    -- Fundo transparente
    local backgroundOverlay = display.newRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    backgroundOverlay:setFillColor(0, 0, 0, 0.6)

    -- Animação de escala do popup
    local function animatePopup(target)
        target.xScale = 0.5
        target.yScale = 0.5
        transition.to(target, { time = 500, xScale = 1, yScale = 1, transition = easing.outBack })
    end

    -- Popup com gradiente
    local popupBackground = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.85, 20)
    popupBackground.fill = {
        type = "gradient",
        color1 = { 0.98, 0.98, 1 },
        color2 = { 0.8, 0.85, 1 },
        direction = "down"
    }
    popupBackground.strokeWidth = 3
    popupBackground:setStrokeColor(0.2, 0.4, 0.6)
    popupBackground.alpha = 0.95
    animatePopup(popupBackground)

    -- Título do popup
    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Guie os Blocos até as Caixas!",
        x = display.contentCenterX,
        y = popupBackground.y - popupBackground.height / 2 + 40,
        font = native.systemFontBold,
        fontSize = 24
    })
    popupTitle:setFillColor(0.2, 0.4, 0.8)

    -- Timer com barra de progresso
    local timeLeft = 30
    local timerHandle
    local timerBar = display.newRect(popupGroup, display.contentCenterX, popupBackground.y - popupBackground.height / 2 + 100, display.contentWidth * 0.7, 20)
    timerBar:setFillColor(0.2, 0.8, 0.2)
    timerBar.anchorX = 0
    timerBar.x = display.contentCenterX - display.contentWidth * 0.35

    local timerText = display.newText({
        parent = popupGroup,
        text = "Tempo: " .. timeLeft,
        x = display.contentCenterX,
        y = timerBar.y + 30,
        font = native.systemFontBold,
        fontSize = 18
    })
    timerText:setFillColor(0.2, 0.8, 0.2)

    local alertSound = audio.loadSound("alert.wav")

    -- Função do Timer
    local function updateTimer()
        timeLeft = timeLeft - 1
        timerText.text = "Tempo: " .. timeLeft
        timerBar.xScale = timeLeft / 30

        if timeLeft <= 5 then
            timerText:setFillColor(1, 0, 0)
            timerBar:setFillColor(1, 0.3, 0.3)
            audio.play(alertSound)
        end

        if timeLeft <= 0 then
            local gameOverText = display.newText({
                parent = popupGroup,
                text = "Tempo Esgotado!",
                x = display.contentCenterX,
                y = display.contentCenterY,
                font = native.systemFontBold,
                fontSize = 28
            })
            gameOverText:setFillColor(1, 0, 0)
            physics.stop()
            if timerHandle then
                timer.cancel(timerHandle)
                timerHandle = nil
            end
        end
    end
    timerHandle = timer.performWithDelay(1000, updateTimer, timeLeft)

    -- Chamar lógica para criar paredes
    popupLogic.createWalls(popupGroup, popupBackground)

    -- Criar caixas de destino
    local boxes = popupLogic.createBoxes(popupGroup, popupBackground)

    -- Criar obstáculos circulares
    local obstacles = popupLogic.createObstacles(popupGroup, popupBackground, 30, 10)

    -- Criar blocos de DNA
    local blocks = popupLogic.createBlocks(popupGroup, popupBackground, boxes)

    -- Mensagem multimídia
    local multimediaMessage = display.newText({
        parent = popupGroup,
        text = "Acertou? Boa! Termine antes do tempo!",
        x = display.contentCenterX,
        y = popupBackground.y + 30,
        font = native.systemFont,
        fontSize = 18
    })
    multimediaMessage:setFillColor(0, 0, 0.6)
    
    -- Botão Fechar
    local closeButton = display.newRoundedRect(popupGroup, display.contentCenterX, popupBackground.y + popupBackground.height / 2 - 30, 140, 45, 12)
    closeButton.strokeWidth = 2
    closeButton:setStrokeColor(0.8, 0.2, 0.2)
    closeButton.fill = {
        type = "gradient",
        color1 = { 1, 0.4, 0.4 },
        color2 = { 0.9, 0.2, 0.2 },
        direction = "down"
    }

    local closeText = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = closeButton.x,
        y = closeButton.y,
        font = native.systemFontBold,
        fontSize = 18
    })
    closeText:setFillColor(1)

    closeButton:addEventListener("tap", function()
        if timerHandle then
            timer.cancel(timerHandle)
            timerHandle = nil
        end
        physics.stop()
        popupLogic.cleanup(blocks, obstacles)
        audio.stop()
        popupGroup:removeSelf()
    end)
end

return M
