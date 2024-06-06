--Offline Mode Window UI--
--另一個用來呈現資料的視窗，避免影響原來頁面
--放置在一個adjustable.container讓使用者自行移動位置
-- Put World into an adjustable container
OfflineMapViewer = OfflineMapViewer or {}
OfflineMapViewer.OffLineWindow = Adjustable.Container:new({
  name="Offline_Mode",
  width = "75%" ,height = "70%" ,
  x = 10, y = 10,
  titleText = "Welcom to the WORLD",
  titleFormat = "16",
  buttonFontSize = 30,
  buttonsize = 60,
  buttonstyle=[[
                QLabel{ border-radius: 20px; background-color: rgba(140,140,140,100%);}
                QLabel::hover{ background-color: rgba(160,160,160,50%);}
              ]],
  auto_hidden = true,
})
OfflineMapViewer.OffLineWindow:hide()

OfflineMapViewer.OffLineMenuBar = Geyser.Container:new({
  name = "OffLineMenuBar",
  x = 10, y =60,
  width = "50%", height = "10%",
  color = "<192,192,192,0>",
},OfflineMapViewer.OffLineWindow)

OfflineMapViewer.OffLineMenuBar_1 = Geyser.Label:new({
  name = "OffLineWorld_Setting",
  x = 10 ,y = 0,
  width = 70, height = "100%",
  stylesheet = "border-image : url("..gfx_path.."/OfflineMapUI/Setting.png)",
  --message = "⚙",
  },OfflineMapViewer.OffLineMenuBar)
OfflineMapViewer.OffLineMenuBar_1:setCursor("PointingHand")
OfflineMapViewer.OffLineMenuBar_1:setClickCallback(OfflineMapViewer.config())

OfflineMapViewer.OffLineMenuBar_2 = Geyser.Label:new({
  name = "BackStepButton",
  x = 10+70*1 ,y = 0,
  height = "100%", width = 70,
  stylesheet = "border-image : url("..gfx_path.."/OfflineMapUI/Backstepbutton.png)",
  },OfflineMapViewer.OffLineMenuBar)
OfflineMapViewer.OffLineMenuBar_2:setClickCallback(function() centerview(OfflineMapViewer.previousRoom)
                                                          OfflineMapViewer.DataLoad(OfflineMapViewer.previousRoom)
														  OfflineMapViewer.currentRoom=tonumber(OfflineMapViewer.previousRoom)
														  end)
OfflineMapViewer.OffLineMenuBar_2:setCursor("PointingHand")

OfflineMapViewer.OffLineMenuBar_3 = Geyser.Label:new({
  name = "RecallButton",
  x = 10+70*2 ,y = 0,
  width = 70, height = "100%",
  stylesheet = "border-image : url("..gfx_path.."/OfflineMapUI/Recall.png)",
  },OfflineMapViewer.OffLineMenuBar)
OfflineMapViewer.OffLineMenuBar_3:setClickCallback(function()centerview(OfflineMapViewer.recallPoint)
                                                              OfflineMapViewer.DataLoad(OfflineMapViewer.recallPoint)
															  OfflineMapViewer.currentRoom = tonumber(OfflineMapViewer.recallPoint)
															  end)
OfflineMapViewer.OffLineMenuBar_3:setCursor("PointingHand")                            
 

local function OfflineModeCMD(text)
end

OfflineMapViewer.OffLineWorld = Geyser.MiniConsole:new({
  name="Offline_World",
  x="0%", y="20%",
  width="100%", height="70%",
  color = "black",
  font = "標楷體",
  fontSize = 16,
  scrollBar = true,
  autoWrap = true,
  commandLine = true, --false it if you don't need
  scrolling = true,
  actionFunc = "OfflineModeCMD", --避免輸入命令送到主視窗
},OfflineMapViewer.OffLineWindow)

OfflineMapViewer.OffLineHint = Geyser.Label:new({
  name = "",
  x = "10%",y = "90%"
  width = "80%", height = "10%",
  --color = "<>",
},OfflineMapViewer.OffLineWindow)