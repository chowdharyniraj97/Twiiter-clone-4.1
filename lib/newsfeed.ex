defmodule Newsfeed do

	def startNewsFeed() do
		:ets.new(:newsFeed, [:set, :public, :named_table])
		{:ok,pid}=GenServer.start_link(__MODULE__,[],name: :newsfeed)
		:ets.insert(:directory,{"newsfeedid",pid})
	end

 def init(list) do
    {:ok,list}
 end


 def handle_cast({:appendnewsfeed, tweet,user_id}, state) do
		if(!(:ets.member(:newsFeed,user_id))) do
     		 :ets.insert(:newsFeed,{user_id,[tweet]})
    else
      		[{_user,a}]=:ets.lookup(:newsFeed,user_id)
      		a = [tweet] ++ a
      		:ets.insert(:newsFeed,{user_id,a})
  	end
		[{_user,fid}]=:ets.lookup(:directory,"followerid")
		GenServer.cast(fid,{:addnewstofollowerswall,user_id,tweet})
   	{:noreply, state}
  end

  def handle_call({:print,k},_,state) do
  	if(:ets.member(:newsFeed,k)) do
  		[{_user,list}]=:ets.lookup(:newsFeed,k)
  		Enum.map(list, fn(x) -> IO.puts x end)
  	else
  		IO.puts "No news feed"
  	end
  	{:reply,state,state}
  end

end
