local M = {}

-- Criar paredes invisíveis
function M.createWalls(group, popupBackground)
    local wallThickness = 10
    local popupBounds = {
        display.newRect(group, display.contentCenterX, popupBackground.y - popupBackground.height / 2 + 10, popupBackground.width, wallThickness),
        display.newRect(group, display.contentCenterX, popupBackground.y + popupBackground.height / 2 - 10, popupBackground.width, wallThickness),
        display.newRect(group, popupBackground.x - popupBackground.width / 2 + 10, display.contentCenterY, wallThickness, popupBackground.height),
        display.newRect(group, popupBackground.x + popupBackground.width / 2 - 10, display.contentCenterY, wallThickness, popupBackground.height)
    }
    for _, wall in ipairs(popupBounds) do
        wall.isVisible = false
        physics.addBody(wall, "static", { bounce = 0.1 })
    end
end

-- Criar caixas de destino
function M.createBoxes(group, popupBackground)
    local boxes = {}
    local boxColors = { { 0.5, 1, 0.5 }, { 1, 0.8, 0.5 }, { 0.5, 0.8, 1 } }

    for i = 1, 3 do
        local box = display.newRoundedRect(group,
            display.contentCenterX - 130 + (i - 1) * 130,
            popupBackground.y + popupBackground.height / 2 - 80,
            100, 100, 10)
        box.strokeWidth = 4
        box:setStrokeColor(unpack(boxColors[i]))
        box:setFillColor(0.9)
        box.id = i
        physics.addBody(box, "static", { isSensor = true })
        boxes[#boxes + 1] = box
    end
    return boxes
end

-- Criar obstáculos circulares com tamanho fixo
function M.createObstacles(group, popupBackground, size, totalObstacles)
    if type(totalObstacles) ~= "number" or totalObstacles <= 0 then
        totalObstacles = 5 -- Valor padrão
    end

    local obstacles = {}
    for i = 1, totalObstacles do
        local obstacle = display.newCircle(
            group,
            math.random(popupBackground.x - popupBackground.width * 0.4, popupBackground.x + popupBackground.width * 0.4),
            math.random(popupBackground.y - popupBackground.height * 0.3, popupBackground.y + popupBackground.height * 0.3),
            size
        )
        obstacle:setFillColor(math.random(), math.random(), math.random(), 0.8)
        obstacle.strokeWidth = 3
        obstacle:setStrokeColor(0.4, 0.4, 0.4)
        physics.addBody(obstacle, "static", { radius = size, friction = 0.3, bounce = 0.1 })
        table.insert(obstacles, obstacle)
    end
    return obstacles
end

-- Criar blocos de DNA com texto sincronizado e acelerômetro
function M.createBlocks(group, popupBackground, boxes)
    local blocks = {}
    local dnaFragments = { "A-T-C-G", "C-G-T-A", "T-A-G-C" }

    for i, text in ipairs(dnaFragments) do
        local blockGroup = display.newGroup()
        group:insert(blockGroup)

        -- Criar bloco
        local block = display.newRoundedRect(blockGroup,
            math.random(popupBackground.x - popupBackground.width * 0.4, popupBackground.x + popupBackground.width * 0.4),
            popupBackground.y - popupBackground.height * 0.4,
            100, 100, 10)
        block.strokeWidth = 2
        block:setStrokeColor(0.2, 0.4, 0.6)
        block:setFillColor(0.9)

        -- Criar texto associado
        local blockText = display.newText({
            parent = blockGroup,
            text = text,
            x = block.x,
            y = block.y,
            font = native.systemFontBold,
            fontSize = 14
        })
        blockText:setFillColor(0)

        physics.addBody(block, "dynamic", { density = 0.4, friction = 0.2, bounce = 0.1 })

        -- Sincronizar texto com o bloco
        local function syncText()
            blockText.x, blockText.y = block.x, block.y
        end
        Runtime:addEventListener("enterFrame", syncText)

        -- Listener de colisão para encaixar o bloco
        block.collision = function(self, event)
            if event.phase == "began" and event.other.id == i then
                -- Posicionar o texto no centro da caixa
                blockText.x, blockText.y = event.other.x, event.other.y

                -- Mudar cor da caixa
                event.other:setFillColor(0.5, 1, 0.5) -- Verde

                -- Remover o bloco
                display.remove(block)

                -- Remover sincronização do texto
                Runtime:removeEventListener("enterFrame", syncText)

                -- Remover listener de colisão
                block:removeEventListener("collision")
            end
        end
        block:addEventListener("collision")

        table.insert(blocks, blockGroup)
    end

    -- Listener do acelerômetro
    local function onAccelerate(event)
        local ax, ay = event.xGravity, event.yGravity
        for _, blockGroup in ipairs(blocks) do
            local block = blockGroup[1]
            if block and block.bodyType == "dynamic" then
                block:applyForce(ax * 10, -ay * 10, block.x, block.y)
            end
        end
    end
    Runtime:addEventListener("accelerometer", onAccelerate)

    -- Função de limpeza do acelerômetro
    function M.cleanupAccelerometer()
        Runtime:removeEventListener("accelerometer", onAccelerate)
    end

    return blocks
end

-- Limpar recursos
function M.cleanup(blocks, obstacles)
    for _, blockGroup in ipairs(blocks) do
        blockGroup:removeSelf()
    end
    for _, obstacle in ipairs(obstacles) do
        obstacle:removeSelf()
    end
    M.cleanupAccelerometer() -- Remove o listener do acelerômetro
end

return M
