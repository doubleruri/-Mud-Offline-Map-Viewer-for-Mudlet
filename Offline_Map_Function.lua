--Thinking flow--

--設定離線區要用的位置，用另一個變數記憶
--讀取房間的資料: 名字、出口、在roomuserdata裡讀descriptin、NPC、OBJ、store、sector、indoor、和Note
--房間移動方式1 點連結
--房間移動方式2 輸入特定指令
--
--ok播報員的function
--現在位置用的function
--秀資料用的function
--房間移動方式的function(也許用個參數好切換)
--回到現實世界地圖的function
Offline_MAP = {}
Offline_MAP.setting = {}
Offline_MAP.setting.pattern = 2
Offline_MAP.setting.movemethod = "1"
Offline_MAP.currentRoom = ""
Offline_MAP.WhatInRoom = {"description","NPC","OBJ","Notes"}

--播報員的function
local MapperVoice = "<112,229,0>[Offline_MAP]: <255,255,255>"
local ErrorVoice = "<255,0,0>[<178,34,34>Offline_MAP<255,0,0>]: <255,255,255>"
function Offline_MAP.echo(what,err)
  if err then decho(ErrorVoice) else decho(MapperVoice) end
  echo(tostring(what))
  echo("\n")
end
----------
--設定離線區要用的位置
function LoginOffLine(RoomID)
  if not RoomID then
    if not  map.currentRoom then 
      Offline_MAP.echo("請找出現在的房間號或指定要去的地方",1)
    return
    else Offline_MAP.currentRoom = tonumber(map.currentRoom)
    end
  else
    Offline_MAP.currentRoom = RoomID
  end
    Offline_MAP.echo("Default Room is Here you are : "..Offline_MAP.currentRoom)
	decho(MapperVoice)
	echo("要從這裡開始嗎?  ")
	dechoLink("<34,139,34>[<u> YES </u>]", [[display("YES")]],"", true)
	echo("  ")
  dechoLink("<255,0,255>[<u> NO </u>]", [[display("No")]],"", true)
    centerview(Offline_MAP.currentRoom)
end
----------
function DataLoad(RoomID)
decho("<255,255,0>"..getRoomName(RoomID).."<255,255,255>\n")
--顯示RoomUserData,依照Offline_MAP.WhatInRoom裡的順序
for k,v in pairs (Offline_MAP.WhatInRoom) do
  local results = getRoomUserData(RoomID,v,true)
  if  results then echo(results.."\n\n")   end
end
--顯示出口
local exits, special_exits = getRoomExits(RoomID),getSpecialExits(RoomID)
decho("<255,255,0>出口：\n")
if Offline_MAP.setting.pattern == 2 then
  for dir,id in pairs (exits) do
    	dechoLink("<34,139,34>"..dir.."<192,192,192>－"..getRoomName(id).."\n", function() centerview(id) DataLoad(id) end,"", true)
  end
  for goRoom,v in pairs (special_exits) do
    for command,order in pairs(v) do
      dechoLink("<34,139,34>"..command.."<192,192,192>－"..getRoomName(goRoom).."\n", function() centerview(goRoom) DataLoad(goRoom) end,"", true)
    end
  end
else
  local NumberOfExits = 0
    --一般出口
  for dir,id in pairs (exits) do
    if NumberOfExits >0 then echo(" , ") end
    dechoLink("<34,139,34>"..dir.."<192,192,192>", function() centerview(id) DataLoad(id) end,getRoomName(id), true)
    NumberOfExits = NumberOfExits + 1
  end
  --抓取特殊出口--
  for goRoom,v in pairs (special_exits) do
    for command,order in pairs(v) do
      echo(" , ")
      dechoLink("<34,139,34>"..command.."<192,192,192>", function() centerview(goRoom) DataLoad(goRoom) end,getRoomName(goRoom), true)
    end
  end
end
echo("\n\n")
end