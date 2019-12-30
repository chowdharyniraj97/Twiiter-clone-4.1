defmodule Server do
  def fire(numUser,_numMsg) do
    Registry.start_link(name: :my_registry, keys: :unique)
    starttime=System.monotonic_time(:millisecond)
   # :ets.new(:usertable, [:set, :public, :named_table])
    :ets.new(:directory, [:set,:public, :named_table])
    :ets.new(:users, [:set,:public, :named_table])

    #:ets.new(:hashtag, [:set, :public, :named_table])
    #:ets.new(:mentions, [:set, :public, :named_table])
    #Creates users(GenServers)
    Newsfeed.startNewsFeed() #handles each users newsfeed
    TweetActor.startTweetActor()
    Followers.startFollowersList()
    Hashtag.startHashtag()
    Mentions.startMentions()
    Activeusers.startau()

    endtime=System.monotonic_time(:millisecond)-starttime
    IO.puts "Time to create tables = #{endtime} milliseconds"

    #Make users
    starttime=System.monotonic_time(:millisecond)
    make_users(numUser)
    endtime=System.monotonic_time(:millisecond)-starttime
    IO.puts "Time to create all the users = #{endtime} milliseconds"

    starttime=System.monotonic_time(:millisecond)
    create_active(numUser)
    endtime=System.monotonic_time(:millisecond)-starttime
    IO.puts "Time to create active users = #{endtime} milliseconds"
    #Process.sleep(500)
    #Makes random followers for users
    #make_followers(numUser)

    #Process.sleep(999);


    #Enum.map(1..numUser, fn(x)-> IO.puts(GenServer.call(via_tuple(x),:print)) end)
    #Enum.map(1..numUser, fn(x)->
    #  if(:ets.member(:tweets,x)) do
    #    [{user,a}] = :ets.lookup(:tweets,x)
    #    IO.puts "User #{user} has the following tweets"
    #    IO.inspect a
    #  end
    #end)
  end

  def shownewsfeed(k) do
    [{_user,id}]=:ets.lookup(:directory,"newsfeedid")
    GenServer.call(id,{:print,k})
  end

  def mostthashtag do
    [{_user,id}]=:ets.lookup(:directory,"hashtagid")
    GenServer.cast(id,{:getMax})
  end

  def check_active(x) do
      if(:ets.member(:activeusers,x)) do
        IO.inspect "#{x} is active"
      end
    end

  def delete_user(user) do
    Delete.del(user)
    #GenServer.stop(via_tuple(user))
  end

  def make_users(numUser) do
    Enum.map(1..numUser, fn(x)->
      user = "user#{x}"
      if(:ets.lookup(:users,x) == [{x}]) do
        "User already exits"
      else
        :ets.insert(:users,{x})
        start_node(user,x,"","Akash")
      end
    end)
  end

  def create_active(numUser) do
    [{_user,id}]=:ets.lookup(:directory,"activeusersid")
    Enum.map(1..numUser, fn(x)->
      k = Enum.random(0..1)
      if(k==1) do
        GenServer.cast(id,{:add_auser,x})
      end
    end)
  end

  def create_tweet(x,tweet) do
    [{_user,tweetid}]=:ets.lookup(:directory,"tweetactorid")
    GenServer.cast(tweetid,{:addTweet,tweet,x})
    #Process.sleep(100)
    list = Regex.scan(~r/\B#[á-úÁ-Úä-üÄ-Üa-zA-Z0-9_]+/, tweet) |> Enum.concat

    if(length(list) != 0) do
      [{_user,id}]=:ets.lookup(:directory,"hashtagid")
     GenServer.cast(id,{:addhashtag,list,tweet})
    end

    list = Regex.scan(~r/\B@[á-úÁ-Úä-üÄ-Üa-zA-Z0-9_]+/, tweet) |> Enum.concat
    if(length(list) != 0) do
       [{_user,id}]=:ets.lookup(:directory,"mentionid")
     GenServer.cast(id,{:addmentions,list,tweet})
   end
  end

  def retweet(user) do
    [{_user,listoffollowing}]=:ets.lookup(:following,user)
    k = Enum.random(listoffollowing)
    [{_user,list}]=:ets.lookup(:tweets,k)
    j = Enum.random(list)
    [{_user,tweetid}]=:ets.lookup(:directory,"tweetactorid")
    GenServer.cast(tweetid,{:addTweet,j,user})
  end

  def follow(followee,user) do
    [{_user,id}]=:ets.lookup(:directory,"followerid")
    GenServer.cast(id,{:addfollower,user,followee})
  end

  def checkmentions(user) do
    [{_user,b}]=:ets.lookup(:mentions,user)
    b
  end

  def start_node(user,x,password,name) do
    GenServer.start_link(__MODULE__,[user,password,name], name: via_tuple(x))
  end

  def handle_call(:print,_,state) do
    {:reply,state,state}
  end

  def init(list) do
    {:ok,list}
  end

  defp via_tuple(x) do
    {:via, Registry, {:my_registry, x}}      #returns pid of a process with that id
  end

  def handle_info(:kill,state) do
    {:stop, :normal, state}
  end

end
