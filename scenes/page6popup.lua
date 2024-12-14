local M = {}

function M.showPopup()
    local popupGroup = display.newGroup()

    -- Som de Bom Resultado
    local goodResultSound = audio.loadSound("assets/audio/goodresult.mp3")

    -- Fundo do Pop-Up (menor)
    local popupBackground = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.7, display.contentHeight * 0.6, 20)
    popupBackground:setFillColor(1, 1, 1)
    popupBackground.strokeWidth = 4
    popupBackground:setStrokeColor(0.2, 0.4, 0.6)
    popupBackground.alpha = 0
    transition.to(popupBackground, { time = 500, alpha = 1 }) -- Efeito de fade-in

    -- Título com efeito
    local popupTitle = display.newText({
        parent = popupGroup,
        text = "AGITE PARA DESCOBRIR O QUE É!",
        x = display.contentCenterX,
        y = popupBackground.y - popupBackground.height / 2 + 20,
        font = native.systemFontBold,
        fontSize = 20,
        align = "center"
    })
    popupTitle:setFillColor(0, 0, 0.7)
    popupTitle.alpha = 0
    transition.to(popupTitle, { time = 800, alpha = 1, y = popupTitle.y + 10, transition = easing.outBounce })

    -- Imagem com Terra
    local comterra = display.newImageRect(popupGroup, "assets/images/geneanalise.png", 350, 200)
    comterra.x = display.contentCenterX
    comterra.y = display.contentCenterY

    -- Imagem sem Terra (Nova Espécie Descoberta - Inicialmente Invisível)
    local semterra = display.newImageRect(popupGroup, "assets/images/animalnovo.png", 350, 200)
    semterra.x = display.contentCenterX
    semterra.y = display.contentCenterY
    semterra.isVisible = false

    -- Tela de Carregamento (Inicialmente Invisível)
    local loadingBackground = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.5, display.contentHeight * 0.3, 20)
    loadingBackground:setFillColor(0.9, 0.9, 0.9)
    loadingBackground.strokeWidth = 3
    loadingBackground:setStrokeColor(0.3, 0.3, 0.3)
    loadingBackground.isVisible = false

    local loadingText = display.newText({
        parent = popupGroup,
        text = "Carregando...",
        x = display.contentCenterX,
        y = display.contentCenterY,
        font = native.systemFontBold,
        fontSize = 18
    })
    loadingText:setFillColor(0, 0, 0.6)
    loadingText.isVisible = false

    -- Mensagem ao Revelar Nova Espécie
    local revealMessage = display.newText({
        parent = popupGroup,
        text = "MÚMIA DESCOBERTA!",
        x = display.contentCenterX,
        y = comterra.y + 120,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center"
    })
    revealMessage:setFillColor(0, 0.6, 0)
    revealMessage.isVisible = false

    -- Variável para controlar a troca de imagem
    local hasShaken = false

    -- Detecção do Movimento do Acelerômetro
    local function celularMexendo(event)
        if event.isShake and not hasShaken then
            hasShaken = true

            -- Exibir Tela de Carregamento
            comterra.isVisible = false
            loadingBackground.isVisible = true
            loadingText.isVisible = true

            -- Simular um tempo de carregamento
            timer.performWithDelay(2000, function()
                -- Som de Bom Resultado
                audio.play(goodResultSound)

                -- Ocultar a Tela de Carregamento
                loadingBackground.isVisible = false
                loadingText.isVisible = false

                -- Mostrar Imagem sem Terra e Mensagem de Sucesso
                semterra.isVisible = true
                transition.to(semterra, { time = 500, alpha = 1 })
                revealMessage.isVisible = true
                transition.to(revealMessage, { time = 800, alpha = 1, yScale = 1.2, xScale = 1.2, transition = easing.outBounce })
            end)
        end
    end
    Runtime:addEventListener("accelerometer", celularMexendo)

    -- Botão de Fechar
    local closeButton = display.newRoundedRect(popupGroup, display.contentCenterX, popupBackground.y + popupBackground.height / 2 - 30, 100, 30, 10)
    closeButton:setFillColor(1, 0.3, 0.3)
    closeButton.strokeWidth = 2
    closeButton:setStrokeColor(0.6, 0.1, 0.1)

    local closeText = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = closeButton.x,
        y = closeButton.y,
        font = native.systemFontBold,
        fontSize = 14
    })
    closeText:setFillColor(1, 1, 1)

    -- Fechar o Popup
    closeButton:addEventListener("tap", function()
        Runtime:removeEventListener("accelerometer", celularMexendo)
        transition.to(popupGroup, { time = 300, alpha = 0, onComplete = function()
            popupGroup:removeSelf()
            popupGroup = nil
        end })
    end)
end

return M
