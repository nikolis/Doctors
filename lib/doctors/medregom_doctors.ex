defmodule Doctors.MedregomDoctors do 
  
  def fetch(first_name, last_name) do
    issues_url(first_name, last_name)
    |> HTTPoison.post("",[{"Content-Type", "application/json"}])
    |> handle_response
    |> validate_names_using_query_results(first_name, last_name)
  end

  def issues_url(firstName, lastName) do
    "https://www.medregom.admin.ch/EN/Suche/GetSearchData?name=#{String.trim(lastName)}&Vorname=#{firstName}"
  end

  def handle_response({_, %{status_code: status, body: body}})do
    status |> check_for_error()
    result = 
      body 
      |> Poison.Parser.parse!()
      |> handle_doctor_details_extraction()
      |> extract_first_and_last_name()
       
  end


  def validate_names_using_query_results(r_list, f_name, l_name) do
    {f_name, l_name} in r_list 
    |> shape_end_result({f_name, l_name})
  end

  def shape_end_result(true, name_tuple) do
    {:doctor, name_tuple}
  end

  def shape_end_result(false, name_tuple) do
    {:not_doctor, name_tuple}
  end

  def extract_first_and_last_name(doctors_list) do 
    Enum.map(doctors_list, &({&1["FirstName"], &1["LastName"]})) 
  end

  def handle_doctor_details_extraction(json) do
    json["rows"]
  end
  


  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

end
