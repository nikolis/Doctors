defmodule Doctors.MedregomDoctors do 
  @headers headers = ["Content-Type": "application/json"] 
  
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.post("",[{"Content-Type", "application/json"}])
    |> handle_response
  end

  def issues_url(firstName, lastName) do
    "https://www.medregom.admin.ch/EN/Suche/GetSearchData?name=#{String.trim(lastName)}&Vorname=#{firstName}"
  end

  def handle_response({_, %{status_code: status, body: body}})do
    { 
      status |> check_for_error(),
      body |> Poison.Parser.parse!()
    }  
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

end

