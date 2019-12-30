defmodule TweetActor do

	def startTweetActor() do

		:ets.new(:tweets, [:set, :public, :named_table])
		{:ok,pid}=GenServer.start_link(__MODULE__,[],name: :tweetactor)
		:ets.insert(:directory,{"tweetactorid",pid})
	end


 def init(list) do
    {:ok,list}
  end

	def handle_cast({:addTweet, tweet,user_id}, state) do
		#[{_user,news}]=:ets.lookup(:tweets,user_id)
		if( !(:ets.member(:tweets,user_id))) do
     		 :ets.insert(:tweets,{user_id,[tweet]})
    	else
      		[{_user,a}]=:ets.lookup(:tweets,user_id)
      		a = [tweet] ++ a
      		:ets.insert(:tweets,{user_id,a})
    	end
    	[{_n,newsfeedid}]=:ets.lookup(:directory,"newsfeedid")
    	GenServer.cast(newsfeedid,{:appendnewsfeed,tweet,user_id})
      {:noreply, state}
  end

end
