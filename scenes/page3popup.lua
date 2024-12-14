local M = {}

function M.showPopup(sceneGroup)
    local popupGroup = display.newGroup()
    sceneGroup:insert(popupGroup)

    -- Carrega o som de explosão
    local explosionSound = audio.loadSound("assets/audio/explosionsoud.mp3")

    -- Fundo do Popup
    local popupBackground = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.8, 20)
    popupBackground:setFillColor(0.95, 0.95, 0.95)
    popupBackground.strokeWidth = 5
    popupBackground:setStrokeColor(0.2, 0.4, 0.6)

    -- Título
    local popupTitle = display.newText({
        parent = popupGroup,
        text = "Toque nos blocos para rachá-los e descobrir informações!",
        x = display.contentCenterX,
        y = popupBackground.y - popupBackground.height / 2 + 20,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center"
    })
    popupTitle:setFillColor(0.1, 0.3, 0.6)

    -- Caixa de Definição (maior e mais abaixo)
    local definitionBox = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY + 200, display.contentWidth * 0.8, 100, 15)
    definitionBox:setFillColor(1, 1, 1)
    definitionBox.strokeWidth = 3
    definitionBox:setStrokeColor(0.8, 0.8, 0.8)

    local definitionText = display.newText({
        parent = popupGroup,
        text = "Toque em um bloco para revelar o conteúdo.",
        x = definitionBox.x,
        y = definitionBox.y,
        width = definitionBox.width * 0.9,
        font = native.systemFont,
        fontSize = 18,
        align = "center"
    })
    definitionText:setFillColor(0, 0, 0)

    -- Função para "explodir" o bloco
    local function explodeBlock(block)
        local blockX, blockY = block.x, block.y
        audio.play(explosionSound)

        -- Criação de partículas
        for i = 1, 10 do
            local size = math.random(15, 25)
            local particle = display.newRect(popupGroup, blockX, blockY, size, size)
            particle:setFillColor(0.3, 0.3, 0.3)
            transition.to(particle, {
                x = blockX + math.random(-60, 60),
                y = blockY + math.random(-60, 60),
                alpha = 0,
                time = 500,
                onComplete = function()
                    if particle then particle:removeSelf() end
                end
            })
        end

        -- Remove o bloco
        if block then
            block:removeSelf()
            if block.text then block.text:removeSelf() end
        end
    end

    -- Função para tremor do bloco
    local function shakeBlock(block, callback)
        transition.to(block, { x = block.x - 5, time = 50, transition = easing.continuousLoop, onComplete = function()
            transition.to(block, { x = block.x + 10, time = 50, onComplete = function()
                transition.to(block, { x = block.x - 5, time = 50, onComplete = callback })
            end })
        end })
    end

    -- Definições e blocos
    local terms = {
        { text = "Gene", definition = "Unidade funcional da hereditariedade que carrega informações genéticas." },
        { text = "Cromossomos", definition = "Estruturas presentes no núcleo das células que contêm DNA." },
        { text = "Hereditariedade", definition = "Transmissão de características de pais para filhos." }
    }

    -- Criar blocos (maiores)
    local startY = display.contentCenterY - 100
    for i, term in ipairs(terms) do
        local block = display.newRoundedRect(popupGroup, display.contentCenterX, startY + (i - 1) * 90, 300, 80, 10)
        block:setFillColor(0.9, 0.9, 0.9)
        block.strokeWidth = 2
        block:setStrokeColor(0.5, 0.5, 0.5)
        block.state = 0 -- Estado inicial

        block.text = display.newText({
            parent = popupGroup,
            text = term.text,
            x = block.x,
            y = block.y,
            font = native.systemFontBold,
            fontSize = 20
        })
        block.text:setFillColor(0, 0, 0)

        -- Interação com o bloco
        block:addEventListener("tap", function()
            block.state = block.state + 1
            shakeBlock(block, function()
                if block.state == 3 then
                    definitionText.text = term.definition
                    explodeBlock(block)
                end
            end)
        end)
    end

    -- Botão de Fechar
    local closeButton = display.newRoundedRect(popupGroup, display.contentCenterX, display.contentCenterY + 280, 120, 40, 10)
    closeButton:setFillColor(1, 0.3, 0.3)
    local closeText = display.newText({
        parent = popupGroup,
        text = "Fechar",
        x = closeButton.x,
        y = closeButton.y,
        font = native.systemFontBold,
        fontSize = 18
    })
    closeText:setFillColor(1, 1, 1)

    closeButton:addEventListener("tap", function()
        transition.to(popupGroup, { time = 300, alpha = 0, onComplete = function()
            popupGroup:removeSelf()
        end })
    end)
end

return M
