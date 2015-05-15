local snax = require "snax"
snax.hotfix(snax.self(), [[
function response.echo(...)
    return handler.name .. ...
end

function hotfix(...)
end
]])
