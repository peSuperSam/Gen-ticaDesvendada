local M = {}

function M.showPopup(sceneGroup)
    local popupGroup = display.newGroup()
    sceneGroup:insert(popupGroup)

    -- Fundo do Popup
    local popupBackground = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.9, 20)
    popupBackground:setFillColor(0.95, 0.95, 0.95)
    popupBackground.strokeWidth = 4
    popupBackground:setStrokeColor(0.2, 0.4, 0.6)

    -- Título
    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Monte o cromossomo organizando os fragmentos de genes!",
        x = display.contentCenterX,
        y = display.contentCenterY - 250,
        font = native.systemFontBold,
        fontSize = 20,
        align = "center"
    })
    popupTitle:setFillColor(0.2, 0.4, 0.6)

    -- Cromossomo Base
    local chromosomeBase = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, 160, 400, 50)
    chromosomeBase:setFillColor(0.9, 0.9, 1)
    chromosomeBase.strokeWidth = 3
    chromosomeBase:setStrokeColor(0.2, 0.4, 0.6)

    -- Segmentos Vazios
    local segmentPositions = {
        { x = chromosomeBase.x, y = chromosomeBase.y - 120, id = 1 },
        { x = chromosomeBase.x, y = chromosomeBase.y, id = 2 },
        { x = chromosomeBase.x, y = chromosomeBase.y + 120, id = 3 }
    }

    local emptySegments = {}
    for _, pos in ipairs(segmentPositions) do
        local segment = display.newRoundedRect(popupGroup, pos.x, pos.y, 140, 50, 25)
        segment:setFillColor(0.8, 0.8, 1)
        segment.strokeWidth = 2
        segment:setStrokeColor(0.4, 0.6, 0.8)
        segment.id = pos.id
        table.insert(emptySegments, segment)
    end

    -- Caixa de Informação
    local infoBox = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY + 250, display.contentWidth * 0.8, 80, 10)
    infoBox:setFillColor(1, 1, 1)
    infoBox.strokeWidth = 2
    infoBox:setStrokeColor(0.7, 0.7, 0.7)

    local infoText = display.newText({
        parent = popupGroup,
        text = "Arraste os fragmentos para a posição correta.",
        x = infoBox.x,
        y = infoBox.y,
        width = infoBox.width * 0.9,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    })
    infoText:setFillColor(0, 0, 0)

    -- Fragmentos de Genes
    local fragments = {
        { label = "Gene A", info = "Gene A: Resistência a doenças.", correctId = 1 },
        { label = "Gene B", info = "Gene B: Metabolismo energético.", correctId = 2 },
        { label = "Gene C", info = "Gene C: Características físicas.", correctId = 3 }
    }

    local placedCount = 0

    -- Função para mostrar informações
    local function showInfo(message)
        infoText.text = message
    end

    -- Criar Fragmentos de Genes com Texto e Bloco Juntos
    for i, fragment in ipairs(fragments) do
        local startX = display.contentCenterX - 200
        local startY = display.contentCenterY - 100 + (i * 80)

        -- Criar um grupo para bloco e texto
        local fragmentGroup = display.newGroup()
        popupGroup:insert(fragmentGroup)

        local fragmentBox = display.newRoundedRect(fragmentGroup, 0, 0, 150, 50, 15)
        fragmentBox:setFillColor(0.4, 0.7, 0.9)
        fragmentBox.strokeWidth = 2
        fragmentBox:setStrokeColor(0.2, 0.4, 0.6)

        local fragmentText = display.newText({
            parent = fragmentGroup,
            text = fragment.label,
            x = 0,
            y = 0,
            font = native.systemFontBold,
            fontSize = 14
        })
        fragmentText:setFillColor(1, 1, 1)

        fragmentGroup.x = startX
        fragmentGroup.y = startY
        fragmentGroup.correctId = fragment.correctId
        fragmentGroup.info = fragment.info

        -- Drag and Drop
        local function onDrag(event)
            if event.phase == "began" then
                display.getCurrentStage():setFocus(fragmentGroup)
                fragmentGroup.startX = fragmentGroup.x
                fragmentGroup.startY = fragmentGroup.y
            elseif event.phase == "moved" then
                fragmentGroup.x = event.x
                fragmentGroup.y = event.y
            elseif event.phase == "ended" or event.phase == "cancelled" then
                display.getCurrentStage():setFocus(nil)

                local placed = false
                for _, segment in ipairs(emptySegments) do
                    if math.abs(fragmentGroup.x - segment.x) < 60 and math.abs(fragmentGroup.y - segment.y) < 30 and segment.id == fragmentGroup.correctId then
                        fragmentGroup.x = segment.x
                        fragmentGroup.y = segment.y
                        placed = true
                        showInfo(fragmentGroup.info)
                        placedCount = placedCount + 1
                        fragmentGroup:removeEventListener("touch", onDrag)
                        break
                    end
                end

                if not placed then
                    transition.to(fragmentGroup, { time = 300, x = fragmentGroup.startX, y = fragmentGroup.startY })
                end

                -- Verificar se todos foram encaixados
                if placedCount == #fragments then
                    timer.performWithDelay(500, function()
                        showInfo("Parabéns! Você completou o cromossomo!")
                    end)
                end
            end
            return true
        end
        fragmentGroup:addEventListener("touch", onDrag)
    end

    -- Botão de Fechar
    local closeButton = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentHeight - 50, 120, 40, 10)
    closeButton:setFillColor(1, 0.3, 0.3)
    closeButton.strokeWidth = 2
    closeButton:setStrokeColor(0.6, 0.1, 0.1)

    local closeText = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = closeButton.x,
        y = closeButton.y,
        fontSize = 16
    })
    closeText:setFillColor(1, 1, 1)

    closeButton:addEventListener("tap", function()
        popupGroup:removeSelf()
        popupGroup = nil
    end)
end

return M
