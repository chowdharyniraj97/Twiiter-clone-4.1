:ets.new(:directory, [:set,:public, :named_table])
:ets.new(:users, [:set,:public, :named_table])
Registry.start_link(name: :my_registry, keys: :unique)
ExUnit.start()
