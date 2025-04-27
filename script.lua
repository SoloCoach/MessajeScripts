local screen = game:GetService("CoreGui")
local player = game.Players.LocalPlayer
local icon = Instance.new("ImageButton")
icon.Parent = screen
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 10, 0, 10)
icon.Image = "rbxassetid://10003972050"  -- Replace with your icon ID
icon.BackgroundTransparency = 1

local menu = Instance.new("Frame")
menu.Parent = screen
menu.Size = UDim2.new(0, 300, 0, 400)
menu.Position = UDim2.new(0, 10, 0, 70)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menu.BackgroundTransparency = 0.5
menu.Visible = false

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

local closeButton = Instance.new("TextButton")
closeButton.Parent = menu
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 10)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

local iconDragging = false
local iconDragStart = Vector3.new()
local iconStartPos = Vector3.new()

icon.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = icon.Position
    end
end)

icon.InputChanged:Connect(function(input)
    if iconDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - iconDragStart
        icon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
    end
end)

icon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = false
    end
end)

local menuDragging = false
local menuDragStart = Vector3.new()
local menuStartPos = Vector3.new()

menu.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDragging = true
        menuDragStart = input.Position
        menuStartPos = menu.Position
    end
end)

menu.InputChanged:Connect(function(input)
    if menuDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - menuDragStart
        menu.Position = UDim2.new(menuStartPos.X.Scale, menuStartPos.X.Offset + delta.X, menuStartPos.Y.Scale, menuStartPos.Y.Offset + delta.Y)
    end
end)

menu.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDragging = false
    end
end)

local tabsFrame = Instance.new("Frame")
tabsFrame.Parent = menu
tabsFrame.Size = UDim2.new(1, -20, 0, 30)
tabsFrame.Position = UDim2.new(0, 10, 0, 70)
tabsFrame.BackgroundTransparency = 1

local tabNames = {"All", "Public", "Private"}
local tabs = {}
local selectedTab = "All"

for i, name in ipairs(tabNames) do
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = tabsFrame
    tabButton.Size = UDim2.new(0, 90, 0, 30)
    tabButton.Position = UDim2.new(0, (i-1)*95, 0, 0)
    tabButton.Text = name
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.MouseButton1Click:Connect(function()
        selectedTab = name
        updateChatLog()
    end)
    tabs[name] = tabButton
end

local chatLog = Instance.new("ScrollingFrame")
chatLog.Parent = menu
chatLog.Size = UDim2.new(1, -20, 0, 250)
chatLog.Position = UDim2.new(0, 10, 0, 110)
chatLog.CanvasSize = UDim2.new(0, 0, 2, 0)
chatLog.ScrollBarThickness = 6
chatLog.BackgroundTransparency = 0.4
chatLog.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local messageBox = Instance.new("TextBox")
messageBox.Parent = menu
messageBox.Size = UDim2.new(1, -80, 0, 40)
messageBox.Position = UDim2.new(0, 10, 1, -50)
messageBox.PlaceholderText = "Mesaj yaz..."
messageBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
messageBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local sendButton = Instance.new("TextButton")
sendButton.Parent = menu
sendButton.Size = UDim2.new(0, 60, 0, 40)
sendButton.Position = UDim2.new(1, -70, 1, -50)
sendButton.Text = "Gönder"
sendButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local chatMessages = {
    {sender = "Player1", receiver = nil, text = "Selam millet!"},
    {sender = "Player2", receiver = "Player3", text = "Naber gizli?"},
    {sender = "Player4", receiver = nil, text = "Roblox çox güzəldi!"},
    {sender = "Player5", receiver = "Player6", text = "######"},
}

function updateChatLog()
    chatLog:ClearAllChildren()
    local yPos = 0
    for _, msg in ipairs(chatMessages) do
        if selectedTab == "All" or (selectedTab == "Public" and msg.receiver == nil) or (selectedTab == "Private" and msg.receiver ~= nil) then
            local messageLabel = Instance.new("TextLabel")
            messageLabel.Parent = chatLog
            messageLabel.Size = UDim2.new(1, -10, 0, 30)
            messageLabel.Position = UDim2.new(0, 5, 0, yPos)
            messageLabel.BackgroundTransparency = 1
            messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            local cleanText = msg.text
            if msg.receiver then
                messageLabel.Text = "["..msg.sender.." ➔ "..msg.receiver.."]: "..cleanText
            else
                messageLabel.Text = "["..msg.sender.."]: "..cleanText
            end

            yPos = yPos + 35
        end
    end
    chatLog.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

updateChatLog()

sendButton.MouseButton1Click:Connect(function()
    if messageBox.Text ~= "" then
        table.insert(chatMessages, {sender = player.Name, receiver = nil, text = messageBox.Text})
        messageBox.Text = ""
        updateChatLog()
    end
end)

local notificationButton = Instance.new("TextButton")
notificationButton.Parent = menu
notificationButton.Size = UDim2.new(0, 50, 0, 50)
notificationButton.Position = UDim2.new(1, -70, 1, -50)
notificationButton.Text = "(0)"
notificationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

local function updateNotificationCount()
    local newMessages = 0
    for _, msg in ipairs(chatMessages) do
        if msg.sender ~= player.Name then
            newMessages = newMessages + 1
        end
    end
    notificationButton.Text = "("..newMessages..")"
end

notificationButton.MouseButton1Click:Connect(function()
    chatLog.CanvasPosition = Vector2.new(0, chatLog.CanvasSize.Y.Offset)
    updateNotificationCount()
end)

updateNotificationCount()

local deleteButton = Instance.new("TextButton")
deleteButton.Parent = menu
deleteButton.Size = UDim2.new(0, 60, 0, 40)
deleteButton.Position = UDim2.new(1, -70, 1, -100)
deleteButton.Text = "Sil"
deleteButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
deleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local confirmDelete = false

deleteButton.MouseButton1Click:Connect(function()
    if not confirmDelete then
        local confirmButton = Instance.new("TextButton")
        confirmButton.Parent = menu
        confirmButton.Size = UDim2.new(0, 60, 0, 40)
        confirmButton.Position = UDim2.new(1, -70, 1, -150)
        confirmButton.Text = "Evet"
        confirmButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        -- confirmButton logic goes here...
    end
end)