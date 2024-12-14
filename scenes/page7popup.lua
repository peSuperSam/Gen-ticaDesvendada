local M = {}

function M.showPopup()
    local popupGroup = display.newGroup()

    -- Habilita Multitoque no sistema
    system.activate("multitouch")

    -- Fundo do Pop-Up
    local popupBackground = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, display.contentHeight * 0.7, 20)
    popupBackground:setFillColor(1, 1, 1)
    popupBackground.strokeWidth = 4
    popupBackground:setStrokeColor(0.2, 0.4, 0.6)

    -- Título
    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Ampliação de DNA: Use dois dedos para dar Zoom!",
        x = display.contentCenterX,
        y = popupBackground.y - popupBackground.height / 2 + 20,
        font = native.systemFontBold,
        fontSize = 16,
        align = "center"
    })
    popupTitle:setFillColor(0, 0, 0.7)

    -- Imagem do DNA
    local dnaImage = display.newImageRect(popupGroup, "assets/images/page7multitoque.png", 400, 300)
    dnaImage.x = display.contentCenterX
    dnaImage.y = display.contentCenterY
    dnaImage:scale(1, 1)

    -- Variáveis de controle de zoom
    local initialDistance = 0
    local maxScale = 3
    local minScale = 1

    local touches = {}
    local detailRevealed = false

    -- Pontos Interativos que aparecem no zoom
    local infoPoint1 = display.newText({
        parent = popupGroup,
        text = "NGS: Sequenciamento de Nova Geração",
        x = dnaImage.x - 50,
        y = dnaImage.y - 60,
        font = native.systemFontBold,
        fontSize = 14
    })
    infoPoint1:setFillColor(0.2, 0.6, 0.8)
    infoPoint1.isVisible = false

    local infoPoint2 = display.newText({
        parent = popupGroup,
        text = "CRISPR: Edição Genética",
        x = dnaImage.x + 80,
        y = dnaImage.y + 60,
        font = native.systemFontBold,
        fontSize = 14
    })
    infoPoint2:setFillColor(0.8, 0.4, 0.2)
    infoPoint2.isVisible = false

    local function calculateDistance(t1, t2)
        return math.sqrt((t2.x - t1.x)^2 + (t2.y - t1.y)^2)
    end

    local function zoomImage(event)
        if event.phase == "began" then
            touches[event.id] = { x = event.x, y = event.y }
        elseif event.phase == "moved" and touches[event.id] then
            touches[event.id] = { x = event.x, y = event.y }

            local touchKeys = {}
            for k in pairs(touches) do table.insert(touchKeys, k) end

            if #touchKeys == 2 then
                local t1 = touches[touchKeys[1]]
                local t2 = touches[touchKeys[2]]
                local currentDistance = calculateDistance(t1, t2)

                if initialDistance > 0 then
                    local scale = dnaImage.xScale * (currentDistance / initialDistance)
                    scale = math.max(minScale, math.min(maxScale, scale))

                    dnaImage.xScale = scale
                    dnaImage.yScale = scale

                    -- Revelar detalhes quando o zoom é maior que 2x
                    if scale > 2 and not detailRevealed then
                        infoPoint1.isVisible = true
                        infoPoint2.isVisible = true
                        transition.blink(infoPoint1, { time = 1000 })
                        transition.blink(infoPoint2, { time = 1000 })
                        detailRevealed = true
                    end
                end
                initialDistance = currentDistance
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            touches[event.id] = nil
            initialDistance = 0
        end
    end

    Runtime:addEventListener("touch", zoomImage)

    -- Botão de Fechar
    local closeButton = display.newRoundedRect(popupGroup, display.contentCenterX, popupBackground.y + popupBackground.height / 2 - 30, 100, 30, 10)
    closeButton:setFillColor(1, 0.3, 0.3)

    local closeText = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = closeButton.x,
        y = closeButton.y,
        font = native.systemFontBold,
        fontSize = 14
    })
    closeText:setFillColor(1, 1, 1)

    closeButton:addEventListener("tap", function()
        Runtime:removeEventListener("touch", zoomImage)
        system.deactivate("multitouch")

        -- Fechamento seguro do popup
        if popupGroup and popupGroup.removeSelf then
            transition.to(popupGroup, {
                time = 300,
                alpha = 0,
                onComplete = function()
                    popupGroup:removeSelf()
                    popupGroup = nil
                end
            })
        end
    end)
end

return M
