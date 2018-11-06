defmodule CliTest do 
  use ExUnit.Case
  doctest Doctors 

  import Doctors.CLI, only: [parse_args: 1]

  test ":help returned" do 
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test ":three values returned  if three given" do 
    assert  parse_args(["firstName", "lastName"]) == {"firstName", "lastName"}
  end 

  test ":test help menu returned in case of invalid arguments" do 
    assert  parse_args(["firstName", "lastName", "lastnameagin"]) == :help
  end 
end 
