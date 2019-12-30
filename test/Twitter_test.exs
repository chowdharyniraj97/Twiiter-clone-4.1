defmodule ClientTest do
  use ExUnit.Case, async: false
  doctest Client

  def testing() do
  	  Newsfeed.startNewsFeed() #handles each users newsfeed
      TweetActor.startTweetActor()
      Followers.startFollowersList()
      Hashtag.startHashtag()
      Mentions.startMentions()
      Activeusers.startau()
  end

  test "create user" do
  	testing()
    IO.inspect("Creating user")
    Server.make_users(1)
    assert :ets.lookup(:users,1) == [{1}]
    IO.inspect "User successfully created"
  end

  test "create duplicate users" do
  	testing()
    IO.inspect("Creating user")
    Server.make_users(1)
    assert Server.make_users(1) == ["User already exits"]
    IO.inspect ("User1 already exists")
  end

  test "delete user" do
  	testing()
    Client.fire(10,10,0)
    Process.sleep(300)
    IO.inspect ("Deleting user1")
  	assert Server.delete_user(1) == :done
    IO.inspect "User1 deleted successfully"
    Process.sleep(300)
    IO.inspect ("Deleting user2")
    assert Server.delete_user(2) == :done
    IO.inspect "User2 deleted successfully"
  end

  test "send_tweet with hashtag" do
    testing()
    Server.make_users(1)
    Process.sleep(300)
    assert Server.create_tweet(1,"Hello, I am a student of #COP5615") == nil
    IO.inspect "Tweet sent"
  end

  test "send_tweet without hashtag" do
      testing()
      Server.make_users(10)
      Server.create_tweet(10,"Hi this is a normal tweet")
      Process.sleep(300)
      [{_user,a}]=:ets.lookup(:tweets,10)
      assert a == ["Hi this is a normal tweet"]
      IO.inspect "Tweet sent"
  end

  test "send tweet with mention" do
    testing()
    Server.make_users(10)
    Server.create_tweet(5,"Hi how are you @user5")
    Process.sleep(300)
    [{_user,a}]=:ets.lookup(:mentions,5)
    assert a == ["Hi how are you @user5"]
    IO.inspect "Tweet sent and User5 can see it in his Mentions"
  end

  test "follow user" do
    testing()
    Server.make_users(10)
    Server.follow(5,10)
    Process.sleep(300)
    [{_user,a}]=:ets.lookup(:followers,10)
    assert a == [5]
    IO.inspect "User5 is now following User10"
  end

  test "follow back" do
    testing()
    Server.make_users(10)
    Server.follow(10,5)
    Process.sleep(300)
    [{_user,a}]=:ets.lookup(:followers,5)
    assert a == [10]
    IO.inspect "User10 is now following User5"
  end

  test "follow user1" do
    testing()
    Server.make_users(10)
    Server.follow(10,2)
    Process.sleep(300)
    [{_user,a}]=:ets.lookup(:followers,2)
    assert a == [10]
    IO.inspect "User10 is now following User2"
  end

  test "retweet" do
    testing()
    Client.fire(10,2,0)
    Process.sleep(300)
    assert Server.retweet(2) == :ok
    IO.inspect "User2 retweeted"
  end

  test "retweet1" do
    testing()
    Client.fire(10,2,0)
    Process.sleep(300)
    assert Server.retweet(5) == :ok
    IO.inspect "User5 retweeted"
  end

  test "retweet2" do
    testing()
    Client.fire(5,1,0)
    Process.sleep(300)
    assert Server.retweet(3) == :ok
    IO.inspect "User3 retweeted"
  end

  test "most trending hashtag" do
    testing()
    Client.fire(10,10,0)
    Process.sleep(300)
    assert Server.mostthashtag == :ok
    IO.puts "#COP5615 is the most trending hashtag"
  end

  test "check if hashtag exists" do
    testing()
    Client.fire(10,10,0)
    Process.sleep(300)
    assert (:ets.member(:hashtag,"#COP5615")) == true
  end

end
