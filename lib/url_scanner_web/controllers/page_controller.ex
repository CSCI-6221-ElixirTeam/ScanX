defmodule UrlScannerWeb.PageController do
 use UrlScannerWeb, :controller

 def index(conn, _params) do
   render(conn, "index.html")
 end

 def scan_url(conn, %{"url" => url}) do
   case UrlScanner.VirusTotal.scan_url(url) do
     {:ok, response} ->
       render(conn, "result.html", result: response)

     {:error, reason} ->
       render(conn, "error.html", error: reason)
   end
 end

 def url_analysis(conn, %{"_id" => id}) do
   case UrlScanner.VirusTotal.analyses_url(id) do
     {:ok, response} ->
       render(conn, "result.html", result: response)

     {:error, reason} ->
       render(conn, "error.html", error: reason)
   end
 end

 def scan_file(conn, %{"file" => file}) do
   case UrlScanner.VirusTotal.scan_file(file) do
     {:ok, response} ->
       render(conn, "result.html", result: response)

     {:error, reason} ->
       render(conn, "error.html", error: reason)
   end
 end

 def scan_ip(conn, %{"ip" => ip}) do
   case UrlScanner.VirusTotal.scan_ip(ip) do
     {:ok, response} ->
       render(conn, "result.html", result: response)

     {:error, reason} ->
       render(conn, "error.html", error: reason)
   end
 end

 def ip_analysis(conn, %{"_id" => id}) do
   case UrlScanner.VirusTotal.analyses_ip(id) do
     {:ok, response} ->
       render(conn, "result.html", result: response)

     {:error, reason} ->
       render(conn, "error.html", error: reason)
   end
 end
end