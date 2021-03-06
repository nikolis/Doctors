defmodule Doctors.CLI do 

  @moduledoc"""
  Handles the command line parsing and the dispatch to 
  the various functions that end up generating  a table
  of the last _n_ issues in a github project
  """

  def run(argv) do 
    argv 
    |> parse_args
    |> process
  end



  @doc"""
  'argv' can be -h or -help, which returns :help.

  Otherwise it's a github user name, project name, and optionally 
  the number of entries to format. 

  Return a tuple of '{user, project, count}', or ':help' if help was given
  """
  def parse_args(argv) do 
    OptionParser.parse(argv, switches: [help: :boolean], 
      aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([firstName, lastName]) do
    {firstName, lastName}
  end 

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do 
    IO.puts """
    usage: issue <firstName> <LastName> 
    """
    System.halt(0)
  end 

  def process({user, project})  do
    Doctors.MedregomDoctors.fetch(user, project)
    |> decode_response()
  end 

  def decode_response({ :ok, body}) do 
    body
  end  

  def decode_response({ :error, error}) do 
    IO.puts "Error fetching"
    System.halt(2)
  end




end
