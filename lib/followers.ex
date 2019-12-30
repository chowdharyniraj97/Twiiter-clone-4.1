defmodule Followers do

	def startFollowersList() do
		:ets.new(:followers, [:set, :public, :named_table])
    :ets.new(:following, [:set, :public, :named_table])
		{:ok,pid}=GenServer.start_link(__MODULE__,[],name: :following)
		:ets.insert(:directory,{"followerid",pid})

	end

  def init(list) do
    {:ok,list}
  end

  def handle_cast({:addfollower,user,followee}, fss) do
		#IO.puts :ets.member(:follower,user)
		if(:ets.member(:followers,user)) do
		    [{_user,listoffollowers}]=:ets.lookup(:followers,user)
		    listoffollowers=[followee]++listoffollowers
		    listoffollowers = Enum.uniq(listoffollowers)
		    :ets.insert(:followers,{user,listoffollowers})
	 else
		    :ets.insert(:followers,{user,[followee]})
	 end

   if(:ets.member(:following,followee)) do
        [{_user,listoffollowing}]=:ets.lookup(:following,followee)
        listoffollowing=[user]++listoffollowing
        listoffollowing = Enum.uniq(listoffollowing)
        :ets.insert(:following,{followee,listoffollowing})
   else
        :ets.insert(:following,{followee,[user]})
   end

	 {:noreply, fss}
   end

  def handle_cast({:addnewstofollowerswall,user_id,tweet},state) do
    if( :ets.member(:followers,user_id)) do
  	[{_d,list}]=:ets.lookup(:followers,user_id)

  	Enum.map(list, fn(y)->
	  	if(:ets.member(:newsFeed,y)) do
	      [{_user,news}]=:ets.lookup(:newsFeed,y)
	      news = [tweet] ++ news
	      :ets.insert(:newsFeed,{y,news})
	  	else
	  		:ets.insert(:newsFeed,{y,[tweet]})
	  	end
    end)
  end
  {:noreply,state}
  end
end
