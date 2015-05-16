local snax = require "snax"
snax.hotfix(snax.self(), [[
local snax
local handler
function response.echo(...)
    return handler.name .. "->" .. ...
end

function hotfix(...)
    snax.printf("perform hotfix ...")
end
]])
