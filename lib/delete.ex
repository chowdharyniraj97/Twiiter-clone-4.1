defmodule Delete do

	def del(z) do

		[{_user,list}] = :ets.lookup(:tweets,z)
		:ets.delete(:tweets,z)
		:ets.delete(:newsFeed,z)
		[{_idc,follower}]=:ets.lookup(:followers,z)

		Enum.map(follower,fn(x)->
			[{_idc,fan}]=:ets.lookup(:newsFeed,x)
			new_list=fan -- list
			:ets.insert(:newsFeed,{x,new_list})
		end)

		[{_idc,follower}]=:ets.lookup(:following,z)
		Enum.map(follower,fn(x)->
			[{_idc,fan}]=:ets.lookup(:followers,x)
			fan = fan -- [z]
			:ets.insert(:followers,{x,fan})
		end)

		:ets.delete(:activeusers,z)
		:done
	end

end
