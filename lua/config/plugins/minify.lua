function MinifyCSS(file)
    local i,_ = string.find(file, ".css")
    local command = "cleancss " .. file .. " -o " .. string.sub(file,1,i) .. "min.css"
    vim.api.nvim_call_function("jobstart", {{"bash", "-c", command}})
end

function MinifyJS(file)
    local i,_ = string.find(file, ".js")
    local command = "uglifyjs " .. file .. " -c -o " .. string.sub(file,1,i) .. "min.js"
    vim.api.nvim_call_function("jobstart", {{"bash", "-c", command}})
end

function MinifySourceFile()
    local file = vim.api.nvim_call_function("expand", {"%"})

    local isCSS,_ = string.find(file, ".css")
    local isJS,_ = string.find(file, ".js")

    if isCSS == nil and isJS == nil then
        print("not a css or js file")
        return
    end


    if isCSS ~= nil then
        MinifyCSS(file)
        print("minified css file")
        return
    end

    if isJS ~= nil then
        MinifyJS(file)
        print("minified js file")
        return
    end
end


vim.keymap.set("n", "<leader>m", "<cmd>lua MinifySourceFile()<CR>")
