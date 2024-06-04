--Thinking flow--

--設定離線區要用的位置，用另一個變數記憶
--讀取房間的資料: 名字、出口、在roomuserdata裡讀descriptin、NPC、OBJ、store、sector、indoor、和Note
--房間移動方式1 點連結
--房間移動方式2 輸入特定指令
--
--播報員的function
--現在位置用的function
--秀資料用的function
--房間移動方式的function(也許用個參數好切換)
--回到現實世界地圖的function
Offline_MAP = {}
Offline_MAP.setting = ""
Offline_MAP.currentRoom = ""

function LoginOffLine(RoomID)
  if not RoomID and map.currentRoom then 
    說設定現在的房間或要去的地方
    return end
  else
  Offline_MAP.currentRoom = RoomID or tonumber(map.currentRoom)
  echo("Default Room is Here you are : "..Offline_MAP.currentRoom)
  centerview(Offline_MAP.currentRoom)
end
