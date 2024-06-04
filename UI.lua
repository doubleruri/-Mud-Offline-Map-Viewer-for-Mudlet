--Offline Mode Window UI--
--另一個用來呈現資料的視窗，避免影響原來頁面
--放置在一個adjustable.container讓使用者自行移動位置
OffLineWindow = Adjustable.Container:new({
  name="Offline_Mode",
  titleText = "離線逛街版",
  titleFormat = "16",
  buttonFontSize = 20,
  buttonsize = 30,
  buttonstyle=[[
                QLabel{ border-radius: 15px; background-color: rgba(140,140,140,100%);}
                QLabel::hover{ background-color: rgba(160,160,160,50%);}
              ]],
  auto_hidden = true,
})
OffLineWindow:hide()

local function OfflineModeCMD(text)
end

OffLineWorld = Geyser.MiniConsole:new({
  name="Offline_World",
  x="0%", y="5%",
  width="100%", height="95%",
  color = "black",
  font = "標楷體",
  fontSize = 16,
  scrollBar = true,
  autoWrap = true,
  commandLine = true, --false it if you don't need
  scrolling = true,
  actionFunc = "OfflineModeCMD", --避免輸入命令送到主視窗
},OffLineWindow)
