defmodule Proj4 do
  def start do
    numUser=String.to_integer(Enum.at(System.argv(),0))
    numMsg=String.to_integer(Enum.at(System.argv(),1))
    Server.fire(numUser,numMsg)
    Client.fire(numUser,numMsg,1)
    #Process.sleep(999)
    #Client.send_tweet(1,"Hi, I am Akash Jajoo. I am currently enrolled in #COP5615.")
    #Client.send_tweet(2,"Hi, #COP5615. My project partner is @user1 @user3")
    #Client.send_tweet(2,"Hi, I am also enrolled in #COP5725 @user10")
    #Enum.map(1..numUser-1, fn(x)->
    #  [{user,a}] = :ets.lookup(:tweets,x)
    #  IO.puts "User #{user} has the following tweets"
    #  IO.inspect a
    #end)
    #Enum.map(1..numUser-1, fn(x)->
    #  [{user,a}] = :ets.lookup(:followers,x)
    #  IO.puts "User #{user} is has these followers-"
    #  IO.inspect a
    #end)
    #[{_user,id}]=:ets.lookup(:directory,"newsfeedid")
    #GenServer.cast(id,{:print})
  end
end

Proj4.start
