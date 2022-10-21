# Software Versions

1. Erlang/OTP     22.3
2. Elixir         1.13
3. node           16.18.0 LTS
4. Python         2.7.18
5. Neo4j Desktop  1.4.15

# Install elixir

0. In Terminal/Powershell/cmd
1. `elixir -v` (to make sure elixir install properly)
2. `mix local.hex`
3. `cd <<repo directory>>`

# Install the Site

1. `mix deps.get`
2. `cd assets` -> `npm install` -> `cd ..`
3. open Neo4j Desktop and start the DBMS
  - if create new: 
    - Project -any name-
    - DBMS -any name- *version 3.5.17*
    - password set it as 'apartman'  (or use any and edit config/dev.exs)
4. `mix seed`
5. open a new terminal window as Administrator
6. `mix phx.server`


LiveView Site : `localhost:4000`

GraphQL : `localhost:4000/api/graphiql`