local composer = require("composer")

-- Variável Global para controle de áudio
_G.isMuted = false

-- Funções globais para mutar e desmutar o áudio
function muteAudio(channel)
    if not _G.isMuted then
        audio.setVolume(0, { channel = channel })
        _G.isMuted = true
    end
end

function unmuteAudio(channel)
    if _G.isMuted then
        audio.setVolume(1, { channel = channel })
        _G.isMuted = false
    end
end

-- Iniciar o Composer pela cena "capa"
composer.gotoScene("scenes.capa")
