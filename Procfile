# can't have dots in elixir node names, so replace them with underscores
web: yes | mix compile.protocols && elixir --sname $(echo $DYNO | tr '.' '_') -pa _build/prod/consolidated -S mix phoenix.server
