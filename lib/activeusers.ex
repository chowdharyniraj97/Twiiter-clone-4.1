defmodule Activeusers do

	def startau() do
		:ets.new(:activeusers, [:set, :public, :named_table])
		{:ok,pid}=GenServer.start_link(__MODULE__,[],name: :activeusers)
		:ets.insert(:directory,{"activeusersid",pid})
	end

	def init(list) do
		{:ok,list}
	end

	def handle_cast({:add_auser,x},state) do
		if (!:ets.member(:activeusers,x)) do
			:ets.insert(:activeusers,{x})
		end
		{:noreply,state}
	end

end
