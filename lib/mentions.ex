defmodule Mentions do

	def startMentions do
		:ets.new(:mentions, [:set, :public, :named_table])
		{:ok,pid}=GenServer.start_link(__MODULE__,[],name: :mentions)
		:ets.insert(:directory,{"mentionid",pid})

	end

  def init(list) do
    {:ok,list}
  end

  def handle_cast({:addmentions,list,tweet},state) do
  	   Enum.map(list, fn(k)->
       j = String.split(k, "user")
        {w,_} = Integer.parse(Enum.at(j,1))
        if(!:ets.member(:mentions,w)) do
          :ets.insert(:mentions,{w,[tweet]})
        else
          [{_user,b}]=:ets.lookup(:mentions,w)
          b = [tweet] ++ b
          :ets.insert(:mentions,{w,b})
        end
      end)
  	  {:noreply,state}
  end
end
