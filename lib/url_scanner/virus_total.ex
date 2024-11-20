defmodule UrlScanner.VirusTotal do
  @api_key "422c4d3aee6d914d1024bbc31959f6fcd35f2f99915d93b22f947ac81f650381"
  @base_url "https://www.virustotal.com/api/v3"

  def scan_ip(ip) do
  headers = [
    {"accept", "application/json"},
    {"x-apikey", @api_key}
  ]

  url = "#{@base_url}/ip_addresses/#{ip}"
  case HTTPoison.get(url, headers) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      {:ok, parse_response(body)}
    {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
      {:error, "Error: Received HTTP #{status} - #{body}"}
    {:error, reason} ->
      {:error, reason}
  end
end

def analyses_ip(id) do
  headers = [
    {"accept", "application/json"},
    {"x-apikey", @api_key}
  ]

  url = "#{@base_url}/analyses/#{id}"
  case HTTPoison.get(url, headers) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      {:ok, parse_response(body)}
    {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
      {:error, "Error: Received HTTP #{status} - #{body}"}
    {:error, reason} ->
      {:error, reason}
  end
end

  def scan_url(url) do
    # Ensure the URL has a scheme
    url =
      if String.starts_with?(url, ["http://", "https://"]) do
        url
      else
       url
      end

    # Encode the URL to Base64 (optional, depending on the VirusTotal API requirements)
    encoded_url = Base.url_encode64(url, padding: false)

    IO.inspect(url, label: "Final URL")

    body = "url=#{url}" # Or use the encoded_url if required
    headers = [
      {"accept","application/json"},
      {"x-apikey", @api_key},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    IO.inspect(body, label: "Request Body")
    IO.inspect(headers, label: "Request Headers")

    url = "#{@base_url}/urls"
    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_response(body)}

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:error, "Error: Received HTTP #{status}- #{body}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def analyses_url(id) do
    headers = [
      {"accept","application/json"},
      {"x-apikey", @api_key}
    ]

    IO.inspect(headers, label: "Request Headers")

    url = "#{@base_url}/analyses/#{id}"
    IO.inspect(url, label: "Request url")
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_response(body)}

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:error, "Error: Received HTTP #{status}- #{body}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def scan_file(file) do
    file_path = file.path
    file_name = file.filename

    # Read file content
    {:ok, file_content} = File.read(file_path)

    # Prepare multipart form-data
    multipart_data = {:multipart, [
      {"file", file_content, {"form-data", [name: "file", filename: file_name]}, []}
    ]}

    headers = [
      {"accept", "application/json"},
      {"x-apikey", @api_key}
    ]

    url = "#{@base_url}/files"

    # Make the request to VirusTotal
    case HTTPoison.post(url, multipart_data, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_response(body)}

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        {:error, "Error: Received HTTP #{status} - #{body}"}

      {:error, reason} ->
        {:error, reason}
    end
  end



  defp parse_response(body) do
    body
    |> Jason.decode!()
    |> Map.get("data")
  end
end
