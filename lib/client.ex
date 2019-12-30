defmodule Client do

  def fire(numUser,numMsg,flag) do

    if(flag == 1) do
      #create_tweets
      starttime=System.monotonic_time(:millisecond)
      send_tweet(numUser,numMsg)
      endtime=System.monotonic_time(:millisecond)-starttime
      IO.puts "Time to send tweets and generate newsfeeds = #{endtime} milliseconds"

      #make_followers
      Process.sleep(1000)
      starttime=System.monotonic_time(:millisecond)
      make_followers(numUser)
      endtime=System.monotonic_time(:millisecond)-starttime
      IO.puts "Time to make followers = #{endtime} milliseconds"

      Process.sleep(1000)
      starttime=System.monotonic_time(:millisecond)
      retweet(Enum.random(1..numUser))
      endtime=System.monotonic_time(:millisecond)-starttime
      IO.puts "Time to retweet = #{endtime} milliseconds"

      Process.sleep(1000)
      starttime=System.monotonic_time(:millisecond)
      checknewsfeed(Enum.random(1..numUser))
      endtime=System.monotonic_time(:millisecond)-starttime
      IO.puts "Time to fetch and display newsfeed = #{endtime} milliseconds"
      IO.puts ""

      Process.sleep(1000)
      starttime=System.monotonic_time(:millisecond)
      deleteacc(Enum.random(1..numUser))
      endtime=System.monotonic_time(:millisecond)-starttime
      IO.puts "Time to delete an account = #{endtime} milliseconds"
      
      Process.sleep(1000)
      starttime=System.monotonic_time(:millisecond)
      checkmentions(Enum.random(1..numUser))
      endtime=System.monotonic_time(:millisecond)-starttime
      IO.puts "Time to check mentions = #{endtime} milliseconds"
    else
      send_tweet(numUser,numMsg)
      make_followers(numUser)
    end

  end

  def send_tweet(numUser,numMsg) do
    #Creates tweets for users
    Enum.map(1..numUser, fn(i)->
      Enum.map(1..numMsg,fn(j)->
        k=Enum.random(0..1)
        message=if(k == 0) do
           "Hi, I am user#{i}, message no#{j}"
        else
           t = Enum.random(1..numUser)
           "Hi, I am user#{i} student of #COP5615 @user#{t}"
        end
      Server.create_tweet(i,message)
      end)
    end)
    Process.sleep(100)
    #Server.shownewsfeed(Enum.random(1..numUser))
  end

  def make_followers(numUser) do
    Enum.map(1..numUser, fn(x)->
        k = Enum.random(1..10)
        Enum.map(1..k, fn(_y)->
          r = Enum.random(1..numUser)
          if(x != r) do
            Server.follow(x,r)
          end
        end)
      end)
  end

  def retweet(user) do
    Server.retweet(user)
  end

  def checknewsfeed(user) do
    Server.shownewsfeed(user)
  end

  def deleteacc(user) do
    Server.delete_user(user)
  end

  def checktrending() do
    Server.mostthashtag()
  end

  def checkmentions(user) do
    a = Server.checkmentions(user)
    IO.puts ""
    IO.puts "User#{user} is mentioned in the following tweets"
    Enum.map(a,fn(x)-> IO.puts x end)
  end

end
