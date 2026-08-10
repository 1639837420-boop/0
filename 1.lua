-- Chunk name: nil

game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "小男娘V3",   
  Text = "欢迎使用小男娘",  
  Duration = 4,
  Callback = bindable,
  Button1 = "感谢您的使用",
  Button2 = "每周更新两三次",
})
wait(4)
game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "小男娘",     -- 改
  Text = "每周都会更新几个服务器 更新有点慢 请见谅",
  Duration = 3,
  Callback = bindable,
  Button1 = "祝您使用愉快",
  Button2 = "玩的开心",
})
local window = library:new("小男娘V3")      
notifications:notify{
            Title = "小男娘",   -- 改
            Description = "已启用反挂机",
            Icon = 6031302918,
            Accept = {
                Text = "好的",
                Callback = function()
                    print("!!!")
                end
            },
            Length = 30
        }          