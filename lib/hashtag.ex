defmodule Hashtag do

	def startHashtag do
		:ets.new(:hashtag, [:set, :public, :named_table])
		list = ["#COP5615"]
		{:ok,pid}=GenServer.start_link(__MODULE__,list,name: :hashtag)
		:ets.insert(:directory,{"hashtagid",pid})
	end

  def init(list) do
    {:ok,list}
  end

  def handle_cast({:addhashtag,list,tweet},state) do
  		akash=if(state != []) do
  			state
  		else
  			state
  		end
  	    Enum.map(list, fn(k)->
        _akash=if(!:ets.member(:hashtag,k) ) do
          :ets.insert(:hashtag,{k,[1,[tweet]]})
          akash++k
        else
         [{_hash,b}]=:ets.lookup(:hashtag,k)
          c= Enum.at(b,0)
          c=c+1
          d=Enum.at(b,1)
          d=[tweet] ++ d
          :ets.insert(:hashtag,{k,[c,d]})
          akash
        end
     end)
  	 {:noreply,state}
  end

  def handle_cast({:getMax},state) do
  	:ets.new(:max,[:set,:public, :named_table])
  	:ets.insert(:max,{"max",["COP5615",0]})
  	list_of_keys=List.flatten(state)

  	Enum.map(list_of_keys, fn(x)->
  		if(:ets.member(:hashtag,x)) do
  			[{_user,hash_list}]=:ets.lookup(:hashtag,x)
  			if(:ets.member(:max,"max")) do
  				[{_idc,cur_max}]=:ets.lookup(:max,"max")
  				if(Enum.at(hash_list,0)>Enum.at(cur_max,1)) do
  					:ets.insert(:max,{"max",[x,Enum.at(hash_list,0)]})
         		end
     		end
        end
  	end)
  	 [{_idc,_ans}]=:ets.lookup(:max,"max")
  	 #IO.puts "#{ans} is the most trending hashtag"
  	 {:noreply,state}
  end

end
